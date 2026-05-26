package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiGenerationTask;

/**
 * AI图片生成任务 服务层
 */
public interface IAiGenerationTaskService
{
    public AiGenerationTask selectGenerationTaskById(Long taskId);

    public AiGenerationTask selectGenerationTaskByIdAndUserId(Long taskId, Long userId);

    public List<AiGenerationTask> selectGenerationTasksByUserId(Long userId, String status);

    public int insertGenerationTask(AiGenerationTask task);

    public int updateGenerationTask(AiGenerationTask task);

    public void markProcessing(Long taskId);

    public void markProcessingWithMessage(Long taskId, String message);

    public void markSuccess(Long taskId, String resultImageUrl);

    public void markSuccess(Long taskId, String resultImageUrl, String providerCode);

    public void markFailed(Long taskId, String errorMessage);

    public int deleteGenerationTask(Long taskId, Long userId);
}
