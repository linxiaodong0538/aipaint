package com.ruoyi.web.service.image;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.service.IAiGenerationTaskService;

/**
 * AI图片生成后台任务执行器
 */
@Component
public class AiImageTaskRunner
{
    private static final Logger log = LoggerFactory.getLogger(AiImageTaskRunner.class);

    private final IAiGenerationTaskService taskService;

    private final AiImageGatewayClient gatewayClient;

    private final ExecutorService executorService = Executors.newFixedThreadPool(2);

    public AiImageTaskRunner(IAiGenerationTaskService taskService, AiImageGatewayClient gatewayClient)
    {
        this.taskService = taskService;
        this.gatewayClient = gatewayClient;
    }

    public void submit(Long taskId)
    {
        executorService.submit(() -> run(taskId));
    }

    private void run(Long taskId)
    {
        try
        {
            taskService.markProcessing(taskId);
            AiGenerationTask task = taskService.selectGenerationTaskById(taskId);
            if (task == null)
            {
                return;
            }

            String resultImageUrl = gatewayClient.generateAndSave(task.getPrompt(), task.getSize(), task.getQuality(),
                    previewImageUrl -> taskService.updatePreviewImage(taskId, previewImageUrl));
            taskService.markSuccess(taskId, resultImageUrl);
        }
        catch (Exception e)
        {
            log.error("AI图片生成任务失败，taskId={}", taskId, e);
            taskService.markFailed(taskId, e.getMessage());
        }
    }

    @PreDestroy
    public void shutdown()
    {
        executorService.shutdown();
    }
}
