package com.ruoyi.web.service.image;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.annotation.Value;
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

    private static final String AMBIGUOUS_RESPONSE_MESSAGE = "图片生成已提交，上游仍可能继续处理，请稍后到作品中查看";

    private final IAiGenerationTaskService taskService;

    private final AiImageService aiImageService;

    private final AiImageArchiveService archiveService;

    private final ExecutorService executorService;

    public AiImageTaskRunner(IAiGenerationTaskService taskService, AiImageService aiImageService,
            AiImageArchiveService archiveService,
            @Value("${ai.image.task-runner.pool-size:4}") Integer poolSize)
    {
        this.taskService = taskService;
        this.aiImageService = aiImageService;
        this.archiveService = archiveService;
        this.executorService = Executors.newFixedThreadPool(normalizePoolSize(poolSize));
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
            archiveService.archiveAsync(taskId, result.getResultImageUrl());
        }
        catch (Exception e)
        {
            if (isAmbiguousResponseException(e))
            {
                log.warn("AI图片生成响应状态不确定，taskId={}", taskId, e);
                taskService.markProcessingWithMessage(taskId, AMBIGUOUS_RESPONSE_MESSAGE);
                return;
            }
            log.error("AI图片生成任务失败，taskId={}", taskId, e);
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

    private int normalizePoolSize(Integer poolSize)
    {
        if (poolSize == null)
        {
            return 4;
        }
        return Math.max(1, Math.min(16, poolSize.intValue()));
    }
}
