package com.ruoyi.web.controller.mini;

import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.service.IAiGenerationTaskService;
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
    @Autowired
    private IAiGenerationTaskService taskService;

    @Autowired
    private AiImageTaskRunner imageTaskRunner;

    @Autowired
    private AiImageService aiImageService;

    @PostMapping("/image")
    public AjaxResult createImage(@RequestBody GenerateImageRequest request)
    {
        if (request == null || StringUtils.isBlank(request.getPrompt()))
        {
            return error("请输入画面描述");
        }

        AiImageProviderConfig providerConfig;
        try
        {
            providerConfig = aiImageService.resolveActiveProvider();
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }

        Long userId = SecurityUtils.getUserId();
        String model = normalizeModel(request.getModel(), providerConfig.getModel());
        String ratio = normalizeRatio(request.getRatio());
        String resolution = normalizeResolution(request.getResolution());
        String quality = normalizeQuality(request.getQuality());
        Integer imageCount = normalizeImageCount(request.getN());
        List<String> imageUrls = normalizeImageUrls(request.getImageUrls(), request.getReferenceImageUrl());
        String size = normalizeImageSize(ratio, resolution, request.getSize());
        if ("4K".equals(resolution) && ("1:1".equals(ratio) || "4:3".equals(ratio) || "3:4".equals(ratio)))
        {
            return error("4K 分辨率仅支持 16:9、9:16、2:1");
        }

        AiGenerationTask task = new AiGenerationTask();
        task.setUserId(userId);
        task.setProviderCode(providerConfig.getProviderCode());
        task.setPrompt(request.getPrompt().trim());
        task.setModel(model);
        task.setQuality(quality);
        task.setRatio(ratio);
        task.setSize(size);
        task.setResolution(resolution);
        task.setImageUrls(StringUtils.join(imageUrls, ","));
        task.setImageCount(imageCount);
        task.setStatus("pending");
        task.setProgress(0);
        task.setCreditCost(resolveCreditCost(quality) * imageCount.intValue());
        task.setCreateBy(SecurityUtils.getUsername());
        taskService.insertGenerationTask(task);

        imageTaskRunner.submit(task.getTaskId());

        return success(new GenerateImageResponse(task.getTaskId()));
    }

    @GetMapping("/tasks/{taskId}")
    public AjaxResult getTask(@PathVariable Long taskId)
    {
        AiGenerationTask task = taskService.selectGenerationTaskByIdAndUserId(taskId, SecurityUtils.getUserId());
        return task == null ? error("任务不存在") : success(task);
    }

    @GetMapping("/tasks")
    public AjaxResult listTasks(String status)
    {
        String normalizedStatus = normalizeStatus(status);
        List<AiGenerationTask> tasks = taskService.selectGenerationTasksByUserId(SecurityUtils.getUserId(), normalizedStatus);
        return success(tasks);
    }

    private String normalizeRatio(String ratio)
    {
        if ("1:1".equals(ratio) || "3:4".equals(ratio) || "4:3".equals(ratio)
                || "16:9".equals(ratio) || "9:16".equals(ratio) || "2:1".equals(ratio))
        {
            return ratio;
        }
        return "1:1";
    }

    private String normalizeModel(String model, String defaultModel)
    {
        if ("gpt-image-2".equals(model))
        {
            return model;
        }
        return StringUtils.defaultIfBlank(defaultModel, "gpt-image-2");
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

    private String normalizeQuality(String quality)
    {
        if ("low".equals(quality) || "medium".equals(quality) || "high".equals(quality))
        {
            return quality;
        }
        if ("1K".equals(quality))
        {
            return "low";
        }
        if ("4K".equals(quality))
        {
            return "high";
        }
        return "medium";
    }

    private String normalizeImageSize(String ratio, String resolution, String requestSize)
    {
        String expectedSize = resolveExpectedSize(ratio, resolution);
        if (StringUtils.isBlank(requestSize))
        {
            return expectedSize;
        }
        return expectedSize.equals(requestSize) ? requestSize : expectedSize;
    }

    private String resolveExpectedSize(String ratio, String resolution)
    {
        if ("1:1".equals(ratio))
        {
            return "1K".equals(resolution) ? "1024x1024" : "2048x2048";
        }
        if ("4:3".equals(ratio))
        {
            return "1K".equals(resolution) ? "1024x768" : "2048x1536";
        }
        if ("3:4".equals(ratio))
        {
            return "1K".equals(resolution) ? "768x1024" : "1536x2048";
        }
        if ("16:9".equals(ratio))
        {
            return "1K".equals(resolution) ? "1536x864" : "2K".equals(resolution) ? "2048x1152" : "3840x2160";
        }
        if ("9:16".equals(ratio))
        {
            return "1K".equals(resolution) ? "864x1536" : "2K".equals(resolution) ? "1152x2048" : "2160x3840";
        }
        if ("2:1".equals(ratio))
        {
            return "1K".equals(resolution) ? "2048x1024" : "2K".equals(resolution) ? "2688x1344" : "3840x1920";
        }
        return "1024x1024";
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
        if ("pending".equals(status) || "processing".equals(status) || "success".equals(status) || "failed".equals(status))
        {
            return status;
        }
        return null;
    }

    private int resolveCreditCost(String quality)
    {
        if ("high".equals(quality))
        {
            return 6;
        }
        if ("low".equals(quality))
        {
            return 2;
        }
        return 4;
    }

    public static class GenerateImageRequest
    {
        private String prompt;
        private String model;
        private String quality;
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

        public String getQuality()
        {
            return quality;
        }

        public void setQuality(String quality)
        {
            this.quality = quality;
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
}
