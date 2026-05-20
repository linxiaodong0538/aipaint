package com.ruoyi.web.controller.mini;

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
import com.ruoyi.web.service.image.AiImageProperties;
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
    private AiImageProperties imageProperties;

    @PostMapping("/image")
    public AjaxResult createImage(@RequestBody GenerateImageRequest request)
    {
        if (!imageProperties.hasApiKey())
        {
            return error("图片生成服务未配置 OPENAI_IMAGE_API_KEY");
        }
        if (request == null || StringUtils.isBlank(request.getPrompt()))
        {
            return error("请输入画面描述");
        }
        if (StringUtils.isNotBlank(request.getReferenceImageUrl()))
        {
            return error("参考图生成暂未接入");
        }

        Long userId = SecurityUtils.getUserId();
        String ratio = normalizeRatio(request.getRatio());
        String quality = normalizeQuality(request.getQuality());
        String size = resolveSize(ratio);

        AiGenerationTask task = new AiGenerationTask();
        task.setUserId(userId);
        task.setPrompt(request.getPrompt().trim());
        task.setModel(imageProperties.getModel());
        task.setQuality(quality);
        task.setRatio(ratio);
        task.setSize(size);
        task.setStatus("pending");
        task.setCreditCost(resolveCreditCost(quality));
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

    private String normalizeRatio(String ratio)
    {
        if ("1:1".equals(ratio) || "4:3".equals(ratio) || "3:2".equals(ratio) || "16:9".equals(ratio))
        {
            return ratio;
        }
        return "4:3";
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

    private String resolveSize(String ratio)
    {
        if (imageProperties.isTestMode() && isValidImageSize(imageProperties.getTestSize()))
        {
            return imageProperties.getTestSize();
        }
        if ("1:1".equals(ratio))
        {
            return "1024x1024";
        }
        return "1536x1024";
    }

    private boolean isValidImageSize(String size)
    {
        if (StringUtils.isBlank(size) || !size.matches("\\d+x\\d+"))
        {
            return false;
        }
        String[] parts = size.split("x");
        int width = Integer.parseInt(parts[0]);
        int height = Integer.parseInt(parts[1]);
        return width > 0 && height > 0 && width % 16 == 0 && height % 16 == 0;
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
