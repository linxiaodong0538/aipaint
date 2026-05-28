package com.ruoyi.web.controller.mini;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.IAiGenerationTaskService;
import com.ruoyi.web.service.AiPromptPolishService;
import com.ruoyi.web.service.image.AiImageProviderConfig;
import com.ruoyi.web.service.image.AiImageService;
import com.ruoyi.web.service.image.AiImageTaskRunner;

/**
 * 小程序图片生成接口
 */
@RestController
@RequestMapping("/mini/generate")
public class MiniGenerateController extends BaseController
{
    private static final String MODEL_GPT_IMAGE_2 = "gpt-image-2";

    private static final String MODEL_GPT_IMAGE_2_VIP = "gpt-image-2-vip";

    private static final String MODEL_NANO_BANANA_2 = "nano-banana-2";

    private static final String MODEL_NANO_BANANA_PRO = "nano-banana-pro";

    private static final String MODEL_NANO_BANANA = "nano-banana";

    @Autowired
    private IAiGenerationTaskService taskService;

    @Autowired
    private AiImageTaskRunner imageTaskRunner;

    @Autowired
    private AiImageService aiImageService;

    @Autowired
    private IAiCreditService creditService;

    @Autowired
    private AiPromptPolishService aiPromptPolishService;

    @PostMapping("/image")
    public AjaxResult createImage(@RequestBody GenerateImageRequest request)
    {
        if (request == null || StringUtils.isBlank(request.getPrompt()))
        {
            return error("请输入画面描述");
        }

        String requestedModel = normalizeRequestModel(request.getModel());
        AiImageProviderConfig providerConfig;
        try
        {
            providerConfig = aiImageService.resolveProviderForModel(requestedModel);
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }

        Long userId = SecurityUtils.getUserId();
        String model = normalizeModel(requestedModel, providerConfig.getModel());
        String ratio = normalizeRatioForModel(model, normalizeRatio(request.getRatio()));
        String resolution = normalizeResolutionForModel(model, ratio, normalizeResolution(request.getResolution()));
        Integer imageCount = normalizeImageCount(request.getN());
        List<String> imageUrls = normalizeImageUrls(request.getImageUrls(), request.getReferenceImageUrl());
        String size = normalizeImageSize(model, ratio, resolution, request.getSize());

        AiGenerationTask task = new AiGenerationTask();
        task.setUserId(userId);
        task.setProviderCode(providerConfig.getProviderCode());
        task.setPrompt(request.getPrompt().trim());
        task.setModel(model);
        task.setQuality("auto");
        task.setRatio(ratio);
        task.setSize(size);
        task.setResolution(resolution);
        task.setImageUrls(StringUtils.join(imageUrls, ","));
        task.setImageCount(imageCount);
        task.setStatus("pending");
        task.setProgress(0);
        int creditCost = calculateCreditCost(model, resolution, imageCount);
        task.setCreditCost(creditCost);
        task.setCreateBy(SecurityUtils.getUsername());
        taskService.insertGenerationTask(task);

        try
        {
            creditService.consumeForGeneration(userId, task.getTaskId(), creditCost);
        }
        catch (ServiceException e)
        {
            task.setStatus("failed");
            task.setProgress(100);
            task.setErrorMessage(e.getMessage());
            taskService.updateGenerationTask(task);
            throw e;
        }

        imageTaskRunner.submit(task.getTaskId());

        return success(new GenerateImageResponse(task.getTaskId()));
    }

    @PostMapping("/prompt/polish")
    public AjaxResult polishPrompt(@RequestBody PolishPromptRequest request)
    {
        if (request == null || StringUtils.isBlank(request.getPrompt()))
        {
            return error("请输入画面描述");
        }

        try
        {
            return success(new PolishPromptResponse(aiPromptPolishService.polish(request.getPrompt())));
        }
        catch (ServiceException e)
        {
            return error(e.getMessage());
        }
    }

    @PostMapping(value = "/prompt/polish/stream", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void polishPromptStream(@RequestBody(required = false) Map<String, Object> request, HttpServletResponse response) throws IOException
    {
        String prompt = request == null ? "" : StringUtils.defaultString((String) request.get("prompt"));
        response.setStatus(HttpServletResponse.SC_OK);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.TEXT_EVENT_STREAM_VALUE);
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("X-Accel-Buffering", "no");

        OutputStream outputStream = response.getOutputStream();
        try
        {
            if (StringUtils.isBlank(prompt))
            {
                writeSseEvent(outputStream, "error", "请输入画面描述");
                return;
            }

            aiPromptPolishService.polishStream(prompt, chunk -> {
                try
                {
                    writeSseEvent(outputStream, "message", chunk);
                }
                catch (IOException e)
                {
                    throw new ServiceException("Prompt 润色失败：流式响应写入失败");
                }
            });
            writeSseEvent(outputStream, "done", "");
        }
        catch (ServiceException e)
        {
            writeSseEvent(outputStream, "error", e.getMessage());
        }
        catch (Exception e)
        {
            writeSseEvent(outputStream, "error", "Prompt 润色失败：" + e.getMessage());
        }
    }

    private void writeSseEvent(OutputStream outputStream, String event, String content) throws IOException
    {
        JSONObject data = new JSONObject();
        data.put("content", StringUtils.defaultString(content));
        String payload = "event: " + event + "\n"
                + "data: " + data.toJSONString() + "\n\n";
        outputStream.write(payload.getBytes(StandardCharsets.UTF_8));
        outputStream.flush();
    }

    @GetMapping("/tasks/{taskId}")
    public AjaxResult getTask(@PathVariable Long taskId)
    {
        AiGenerationTask task = taskService.selectGenerationTaskByIdAndUserId(taskId, SecurityUtils.getUserId());
        return task == null ? error("任务不存在") : success(task);
    }

    @GetMapping("/tasks")
    public TableDataInfo listTasks(String status)
    {
        String normalizedStatus = normalizeStatus(status);
        startPage();
        List<AiGenerationTask> tasks = taskService.selectGenerationTasksByUserId(SecurityUtils.getUserId(), normalizedStatus);
        return getDataTable(tasks);
    }

    @DeleteMapping("/tasks/{taskId}")
    public AjaxResult deleteTask(@PathVariable Long taskId)
    {
        Long userId = SecurityUtils.getUserId();
        AiGenerationTask task = taskService.selectGenerationTaskByIdAndUserId(taskId, userId);
        if (task == null)
        {
            return error("任务不存在");
        }
        if (!"success".equals(task.getStatus()))
        {
            return error("仅已完成作品可删除");
        }
        return taskService.deleteGenerationTask(taskId, userId) > 0 ? success() : error("删除失败");
    }

    private String normalizeRatio(String ratio)
    {
        if ("auto".equals(ratio) || "1:1".equals(ratio) || "3:4".equals(ratio) || "4:3".equals(ratio)
                || "16:9".equals(ratio) || "9:16".equals(ratio) || "2:1".equals(ratio)
                || "3:2".equals(ratio) || "2:3".equals(ratio) || "5:4".equals(ratio)
                || "4:5".equals(ratio) || "21:9".equals(ratio) || "9:21".equals(ratio)
                || "1:3".equals(ratio) || "3:1".equals(ratio) || "1:2".equals(ratio)
                || "1:4".equals(ratio) || "4:1".equals(ratio) || "1:8".equals(ratio)
                || "8:1".equals(ratio))
        {
            return ratio;
        }
        return "1:1";
    }

    private String normalizeRatioForModel(String model, String ratio)
    {
        if (StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "1K"))
                || StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "2K"))
                || StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "4K")))
        {
            return ratio;
        }
        return "1:1";
    }

    private String normalizeModel(String model, String defaultModel)
    {
        if (isSupportedModel(model))
        {
            return model;
        }
        if (isSupportedModel(defaultModel))
        {
            return defaultModel;
        }
        return MODEL_GPT_IMAGE_2;
    }

    private String normalizeRequestModel(String model)
    {
        if (isSupportedModel(model))
        {
            return model;
        }
        return "";
    }

    private boolean isSupportedModel(String model)
    {
        return MODEL_GPT_IMAGE_2.equals(model) || MODEL_GPT_IMAGE_2_VIP.equals(model)
                || MODEL_NANO_BANANA_2.equals(model) || MODEL_NANO_BANANA_PRO.equals(model)
                || MODEL_NANO_BANANA.equals(model);
    }

    private String normalizeResolution(String resolution)
    {
        if ("1k".equalsIgnoreCase(resolution) || "1K".equals(resolution))
        {
            return "1K";
        }
        if ("4k".equalsIgnoreCase(resolution) || "4K".equals(resolution))
        {
            return "4K";
        }
        return "2K";
    }

    private String normalizeResolutionForModel(String model, String ratio, String resolution)
    {
        if (StringUtils.isNotBlank(resolveExpectedSize(model, ratio, resolution)))
        {
            return resolution;
        }
        if (StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "1K")))
        {
            return "1K";
        }
        if (StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "2K")))
        {
            return "2K";
        }
        if (StringUtils.isNotBlank(resolveExpectedSize(model, ratio, "4K")))
        {
            return "4K";
        }
        return "1K";
    }

    private String normalizeImageSize(String model, String ratio, String resolution, String requestSize)
    {
        if (MODEL_NANO_BANANA.equals(model))
        {
            return "";
        }
        String expectedSize = StringUtils.defaultIfBlank(resolveExpectedSize(model, ratio, resolution), "1024x1024");
        if (StringUtils.isBlank(requestSize))
        {
            return expectedSize;
        }
        return expectedSize.equals(requestSize) ? requestSize : expectedSize;
    }

    private String resolveExpectedSize(String model, String ratio, String resolution)
    {
        if (MODEL_GPT_IMAGE_2.equals(model))
        {
            return resolveGptImage2Size(ratio, resolution);
        }
        if (MODEL_GPT_IMAGE_2_VIP.equals(model))
        {
            return resolveGptImage2VipSize(ratio, resolution);
        }
        if (isNanoBananaModel(model))
        {
            return resolveNanoBananaSize(model, ratio, resolution);
        }
        return resolveDefaultSize(ratio, resolution);
    }

    private String resolveGptImage2Size(String ratio, String resolution)
    {
        if (!"1K".equals(resolution))
        {
            return null;
        }
        if ("1:1".equals(ratio)) return "1024x1024";
        if ("16:9".equals(ratio)) return "1672x941";
        if ("9:16".equals(ratio)) return "941x1672";
        if ("4:3".equals(ratio)) return "1443x1090";
        if ("3:4".equals(ratio)) return "1090x1443";
        if ("3:2".equals(ratio)) return "1536x1024";
        if ("2:3".equals(ratio)) return "1024x1536";
        if ("5:4".equals(ratio)) return "1408x1120";
        if ("4:5".equals(ratio)) return "1120x1408";
        if ("21:9".equals(ratio)) return "1920x832";
        if ("9:21".equals(ratio)) return "832x1920";
        if ("1:2".equals(ratio)) return "896x1792";
        if ("2:1".equals(ratio)) return "1792x896";
        return null;
    }

    private String resolveGptImage2VipSize(String ratio, String resolution)
    {
        if ("1:1".equals(ratio))
        {
            return "1K".equals(resolution) ? "1024x1024" : "2K".equals(resolution) ? "2048x2048" : "4K".equals(resolution) ? "2880x2880" : null;
        }
        if ("16:9".equals(ratio))
        {
            return "1K".equals(resolution) ? "1280x720" : "2K".equals(resolution) ? "2048x1152" : "4K".equals(resolution) ? "3840x2160" : null;
        }
        if ("9:16".equals(ratio))
        {
            return "1K".equals(resolution) ? "720x1280" : "2K".equals(resolution) ? "1152x2048" : "4K".equals(resolution) ? "2160x3840" : null;
        }
        if ("4:3".equals(ratio))
        {
            return "1K".equals(resolution) ? "1152x864" : "2K".equals(resolution) ? "2304x1728" : "4K".equals(resolution) ? "3264x2448" : null;
        }
        if ("3:4".equals(ratio))
        {
            return "1K".equals(resolution) ? "864x1152" : "2K".equals(resolution) ? "1728x2304" : "4K".equals(resolution) ? "2448x3264" : null;
        }
        if ("3:2".equals(ratio))
        {
            return "1K".equals(resolution) ? "1536x1024" : "2K".equals(resolution) ? "2048x1360" : "4K".equals(resolution) ? "3504x2336" : null;
        }
        if ("2:3".equals(ratio))
        {
            return "1K".equals(resolution) ? "1024x1536" : "2K".equals(resolution) ? "1360x2048" : "4K".equals(resolution) ? "2336x3504" : null;
        }
        if ("5:4".equals(ratio))
        {
            return "1K".equals(resolution) ? "1120x896" : "2K".equals(resolution) ? "2240x1792" : "4K".equals(resolution) ? "3200x2560" : null;
        }
        if ("4:5".equals(ratio))
        {
            return "1K".equals(resolution) ? "896x1120" : "2K".equals(resolution) ? "1792x2240" : "4K".equals(resolution) ? "2560x3200" : null;
        }
        if ("21:9".equals(ratio))
        {
            return "1K".equals(resolution) ? "1456x624" : "2K".equals(resolution) ? "2912x1248" : "4K".equals(resolution) ? "3840x1648" : null;
        }
        if ("9:21".equals(ratio))
        {
            return "1K".equals(resolution) ? "624x1456" : "2K".equals(resolution) ? "1248x2912" : "4K".equals(resolution) ? "1648x3840" : null;
        }
        if ("1:3".equals(ratio))
        {
            return "2K".equals(resolution) ? "688x2048" : "4K".equals(resolution) ? "1280x3840" : null;
        }
        if ("3:1".equals(ratio))
        {
            return "2K".equals(resolution) ? "2048x688" : "4K".equals(resolution) ? "3840x1280" : null;
        }
        if ("2:1".equals(ratio))
        {
            return "1K".equals(resolution) ? "1536x768" : "2K".equals(resolution) ? "3072x1536" : "4K".equals(resolution) ? "3840x1920" : null;
        }
        if ("1:2".equals(ratio))
        {
            return "1K".equals(resolution) ? "768x1536" : "2K".equals(resolution) ? "1536x3072" : "4K".equals(resolution) ? "1920x3840" : null;
        }
        return null;
    }

    private String resolveDefaultSize(String ratio, String resolution)
    {
        if ("1:1".equals(ratio)) return "1K".equals(resolution) ? "1024x1024" : "2K".equals(resolution) ? "2048x2048" : null;
        if ("4:3".equals(ratio)) return "1K".equals(resolution) ? "1024x768" : "2K".equals(resolution) ? "2048x1536" : null;
        if ("3:4".equals(ratio)) return "1K".equals(resolution) ? "768x1024" : "2K".equals(resolution) ? "1536x2048" : null;
        if ("16:9".equals(ratio)) return "1K".equals(resolution) ? "1536x864" : "2K".equals(resolution) ? "2048x1152" : "4K".equals(resolution) ? "3840x2160" : null;
        if ("9:16".equals(ratio)) return "1K".equals(resolution) ? "864x1536" : "2K".equals(resolution) ? "1152x2048" : "4K".equals(resolution) ? "2160x3840" : null;
        if ("2:1".equals(ratio)) return "1K".equals(resolution) ? "2048x1024" : "2K".equals(resolution) ? "2688x1344" : "4K".equals(resolution) ? "3840x1920" : null;
        return null;
    }

    private boolean isNanoBananaModel(String model)
    {
        return MODEL_NANO_BANANA.equals(model) || MODEL_NANO_BANANA_2.equals(model)
                || MODEL_NANO_BANANA_PRO.equals(model);
    }

    private String resolveNanoBananaSize(String model, String ratio, String resolution)
    {
        if (MODEL_NANO_BANANA.equals(model))
        {
            return resolveNanoBanana1KSize(ratio, resolution);
        }
        if ("1:1".equals(ratio)) return scaleSize(resolution, "1024x1024", "2048x2048", "4096x4096");
        if ("16:9".equals(ratio)) return scaleSize(resolution, "1536x864", "2048x1152", "3840x2160");
        if ("9:16".equals(ratio)) return scaleSize(resolution, "864x1536", "1152x2048", "2160x3840");
        if ("4:3".equals(ratio)) return scaleSize(resolution, "1024x768", "2048x1536", "4096x3072");
        if ("3:4".equals(ratio)) return scaleSize(resolution, "768x1024", "1536x2048", "3072x4096");
        if ("3:2".equals(ratio)) return scaleSize(resolution, "1536x1024", "2048x1365", "3840x2560");
        if ("2:3".equals(ratio)) return scaleSize(resolution, "1024x1536", "1365x2048", "2560x3840");
        if ("5:4".equals(ratio)) return scaleSize(resolution, "1280x1024", "2048x1638", "3840x3072");
        if ("4:5".equals(ratio)) return scaleSize(resolution, "1024x1280", "1638x2048", "3072x3840");
        if ("21:9".equals(ratio)) return scaleSize(resolution, "1792x768", "2688x1152", "3840x1646");
        if (MODEL_NANO_BANANA_2.equals(model))
        {
            if ("1:4".equals(ratio)) return scaleSize(resolution, "512x2048", "1024x4096", "1024x4096");
            if ("4:1".equals(ratio)) return scaleSize(resolution, "2048x512", "4096x1024", "4096x1024");
            if ("1:8".equals(ratio)) return scaleSize(resolution, "256x2048", "512x4096", "512x4096");
            if ("8:1".equals(ratio)) return scaleSize(resolution, "2048x256", "4096x512", "4096x512");
        }
        return null;
    }

    private String resolveNanoBanana1KSize(String ratio, String resolution)
    {
        if (!"1K".equals(resolution))
        {
            return null;
        }
        if ("auto".equals(ratio)) return "1024x1024";
        if ("1:1".equals(ratio)) return "1024x1024";
        if ("16:9".equals(ratio)) return "1536x864";
        if ("9:16".equals(ratio)) return "864x1536";
        if ("4:3".equals(ratio)) return "1024x768";
        if ("3:4".equals(ratio)) return "768x1024";
        if ("3:2".equals(ratio)) return "1536x1024";
        if ("2:3".equals(ratio)) return "1024x1536";
        if ("5:4".equals(ratio)) return "1280x1024";
        if ("4:5".equals(ratio)) return "1024x1280";
        if ("21:9".equals(ratio)) return "1792x768";
        return null;
    }

    private String scaleSize(String resolution, String size1k, String size2k, String size4k)
    {
        if ("1K".equals(resolution)) return size1k;
        if ("2K".equals(resolution)) return size2k;
        if ("4K".equals(resolution)) return size4k;
        return null;
    }

    private List<String> normalizeImageUrls(List<String> imageUrls, String referenceImageUrl)
    {
        List<String> result = new ArrayList<>();
        if (imageUrls != null)
        {
            for (String imageUrl : imageUrls)
            {
                if (StringUtils.isNotBlank(imageUrl) && result.size() < 4)
                {
                    result.add(imageUrl.trim());
                }
            }
        }
        if (result.isEmpty() && StringUtils.isNotBlank(referenceImageUrl))
        {
            result.add(referenceImageUrl.trim());
        }
        return result;
    }

    private Integer normalizeImageCount(Integer imageCount)
    {
        if (imageCount == null)
        {
            return Integer.valueOf(1);
        }
        return Integer.valueOf(Math.max(1, Math.min(4, imageCount.intValue())));
    }

    private String normalizeStatus(String status)
    {
        if ("visible".equals(status) || "generating".equals(status)
                || "pending".equals(status) || "processing".equals(status)
                || "success".equals(status) || "failed".equals(status))
        {
            return status;
        }
        return null;
    }

    private int calculateCreditCost(String model, String resolution, Integer imageCount)
    {
        int singleCost = calculateSingleCreditCost(model, resolution);
        int count = imageCount == null ? 1 : Math.max(1, imageCount.intValue());
        return singleCost * count;
    }

    private int calculateSingleCreditCost(String model, String resolution)
    {
        return (int) Math.ceil(getModelBaseCredits(model) * getResolutionCreditMultiplier(resolution));
    }

    private int getModelBaseCredits(String model)
    {
        if (MODEL_GPT_IMAGE_2.equals(model))
        {
            return 6;
        }
        if (MODEL_NANO_BANANA_2.equals(model))
        {
            return 12;
        }
        if (MODEL_GPT_IMAGE_2_VIP.equals(model) || MODEL_NANO_BANANA.equals(model))
        {
            return 15;
        }
        if (MODEL_NANO_BANANA_PRO.equals(model))
        {
            return 20;
        }
        return 6;
    }

    private double getResolutionCreditMultiplier(String resolution)
    {
        if ("2K".equals(resolution))
        {
            return 1.2D;
        }
        if ("4K".equals(resolution))
        {
            return 1.5D;
        }
        return 1.0D;
    }

    public static class GenerateImageRequest
    {
        private String prompt;
        private String model;
        private String ratio;
        private String size;
        private String resolution;
        private Integer n;
        @JsonProperty("image_urls")
        private List<String> imageUrls;
        private String referenceImageUrl;

        public String getPrompt()
        {
            return prompt;
        }

        public void setPrompt(String prompt)
        {
            this.prompt = prompt;
        }

        public String getModel()
        {
            return model;
        }

        public void setModel(String model)
        {
            this.model = model;
        }

        public String getRatio()
        {
            return ratio;
        }

        public void setRatio(String ratio)
        {
            this.ratio = ratio;
        }

        public String getSize()
        {
            return size;
        }

        public void setSize(String size)
        {
            this.size = size;
        }

        public String getResolution()
        {
            return resolution;
        }

        public void setResolution(String resolution)
        {
            this.resolution = resolution;
        }

        public Integer getN()
        {
            return n;
        }

        public void setN(Integer n)
        {
            this.n = n;
        }

        public List<String> getImageUrls()
        {
            return imageUrls;
        }

        public void setImageUrls(List<String> imageUrls)
        {
            this.imageUrls = imageUrls;
        }

        public String getReferenceImageUrl()
        {
            return referenceImageUrl;
        }

        public void setReferenceImageUrl(String referenceImageUrl)
        {
            this.referenceImageUrl = referenceImageUrl;
        }
    }

    public static class GenerateImageResponse
    {
        private Long taskId;

        public GenerateImageResponse(Long taskId)
        {
            this.taskId = taskId;
        }

        public Long getTaskId()
        {
            return taskId;
        }

        public void setTaskId(Long taskId)
        {
            this.taskId = taskId;
        }
    }

    public static class PolishPromptRequest
    {
        private String prompt;

        public String getPrompt()
        {
            return prompt;
        }

        public void setPrompt(String prompt)
        {
            this.prompt = prompt;
        }
    }

    public static class PolishPromptResponse
    {
        private String prompt;

        public PolishPromptResponse(String prompt)
        {
            this.prompt = prompt;
        }

        public String getPrompt()
        {
            return prompt;
        }

        public void setPrompt(String prompt)
        {
            this.prompt = prompt;
        }
    }
}
