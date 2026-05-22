package com.ruoyi.web.controller.mini;

import java.util.List;
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
        if (StringUtils.isNotBlank(request.getReferenceImageUrl()))
        {
            return error("参考图生成暂未接入");
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
        String ratio = normalizeRatio(request.getRatio());
        String quality = normalizeQuality(request.getQuality());
        String size = aiImageService.resolveImageSize(ratio);

        AiGenerationTask task = new AiGenerationTask();
        task.setUserId(userId);
        task.setProviderCode(providerConfig.getProviderCode());
        task.setPrompt(request.getPrompt().trim());
        task.setModel(providerConfig.getModel());
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
