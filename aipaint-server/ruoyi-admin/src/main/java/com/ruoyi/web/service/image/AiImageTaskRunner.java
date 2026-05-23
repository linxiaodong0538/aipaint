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

    private static final String AMBIGUOUS_RESPONSE_MARKER = "图片生成响应异常";

    private static final String AMBIGUOUS_RESPONSE_MESSAGE = "图片生成响应异常，本地未收到生成结果，请重试";

    private final IAiGenerationTaskService taskService;

    private final AiImageService aiImageService;

    private final ExecutorService executorService = Executors.newFixedThreadPool(2);

    public AiImageTaskRunner(IAiGenerationTaskService taskService, AiImageService aiImageService)
    {
        this.taskService = taskService;
        this.aiImageService = aiImageService;
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

            AiImageGenerateResult result = aiImageService.generateAndSave(task);
            taskService.markSuccess(taskId, result.getResultImageUrl(), result.getProviderCode());
        }
        catch (Exception e)
        {
            log.error("AI图片生成任务失败，taskId={}", taskId, e);
            if (isAmbiguousResponseException(e))
            {
                taskService.markFailed(taskId, AMBIGUOUS_RESPONSE_MESSAGE);
                return;
            }
            taskService.markFailed(taskId, e.getMessage());
        }
    }

    private boolean isAmbiguousResponseException(Exception e)
    {
        return e != null && e.getMessage() != null && e.getMessage().contains(AMBIGUOUS_RESPONSE_MARKER);
    }

    @PreDestroy
    public void shutdown()
    {
        executorService.shutdown();
    }
}
