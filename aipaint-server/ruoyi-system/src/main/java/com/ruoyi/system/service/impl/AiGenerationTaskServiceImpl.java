package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.mapper.AiGenerationTaskMapper;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.IAiGenerationTaskService;

/**
 * AI图片生成任务 服务层处理
 */
@Service
public class AiGenerationTaskServiceImpl implements IAiGenerationTaskService
{
    private static final String STALE_PROCESSING_ERROR_MESSAGE = "生成超时，请重新生成";

    @Autowired
    private AiGenerationTaskMapper taskMapper;

    @Autowired
    private IAiCreditService creditService;

    @Override
    public AiGenerationTask selectGenerationTaskById(Long taskId)
    {
        return taskMapper.selectGenerationTaskById(taskId);
    }

    @Override
    public AiGenerationTask selectGenerationTaskByIdAndUserId(Long taskId, Long userId)
    {
        return taskMapper.selectGenerationTaskByIdAndUserId(taskId, userId);
    }

    @Override
    public List<AiGenerationTask> selectGenerationTasksByUserId(Long userId, String status)
    {
        return taskMapper.selectGenerationTasksByUserId(userId, status);
    }

    @Override
    public void markStaleProcessingTasksFailed(int timeoutMinutes)
    {
        int normalizedTimeoutMinutes = Math.max(1, Math.min(60, timeoutMinutes));
        Date beforeTime = new Date(System.currentTimeMillis() - normalizedTimeoutMinutes * 60L * 1000L);
        List<AiGenerationTask> staleTasks = taskMapper.selectStaleProcessingTasks(beforeTime);
        if (staleTasks == null || staleTasks.isEmpty())
        {
            return;
        }
        for (AiGenerationTask staleTask : staleTasks)
        {
            if (staleTask != null && staleTask.getTaskId() != null)
            {
                markFailed(staleTask.getTaskId(), STALE_PROCESSING_ERROR_MESSAGE);
            }
        }
    }

    @Override
    public int insertGenerationTask(AiGenerationTask task)
    {
        return taskMapper.insertGenerationTask(task);
    }

    @Override
    public int updateGenerationTask(AiGenerationTask task)
    {
        return taskMapper.updateGenerationTask(task);
    }

    @Override
    public void markProcessing(Long taskId)
    {
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setStatus("processing");
        task.setProgress(10);
        task.setRunStartTime(new Date());
        taskMapper.updateGenerationTask(task);
    }

    @Override
    public void markProcessingWithMessage(Long taskId, String message)
    {
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setStatus("processing");
        task.setProgress(95);
        task.setErrorMessage(message);
        taskMapper.updateGenerationTask(task);
    }

    @Override
    public void markSuccess(Long taskId, String resultImageUrl)
    {
        markSuccess(taskId, resultImageUrl, null);
    }

    @Override
    public void markSuccess(Long taskId, String resultImageUrl, String providerCode)
    {
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setProviderCode(providerCode);
        task.setStatus("success");
        task.setProgress(100);
        task.setResultImageUrl(resultImageUrl);
        task.setPreviewImageUrl(resolvePreviewImageUrl(resultImageUrl));
        task.setFinishTime(new Date());
        taskMapper.updateGenerationTask(task);
    }

    private String resolvePreviewImageUrl(String resultImageUrl)
    {
        if (resultImageUrl == null)
        {
            return null;
        }
        int commaIndex = resultImageUrl.indexOf(',');
        return commaIndex >= 0 ? resultImageUrl.substring(0, commaIndex) : resultImageUrl;
    }

    @Override
    public void markFailed(Long taskId, String errorMessage)
    {
        AiGenerationTask existingTask = taskMapper.selectGenerationTaskById(taskId);
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setStatus("failed");
        task.setProgress(100);
        task.setErrorMessage(errorMessage);
        task.setFinishTime(new Date());
        taskMapper.updateGenerationTask(task);
        if (existingTask != null && existingTask.getUserId() != null && existingTask.getCreditCost() != null)
        {
            creditService.refundForGenerationFailure(existingTask.getUserId(), taskId, existingTask.getCreditCost());
        }
    }

    @Override
    public void updateArchivedResult(Long taskId, String resultImageUrl)
    {
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setResultImageUrl(resultImageUrl);
        task.setPreviewImageUrl(resolvePreviewImageUrl(resultImageUrl));
        taskMapper.updateGenerationTask(task);
    }

    @Override
    public int deleteGenerationTask(Long taskId, Long userId)
    {
        return taskMapper.markDeletedByIdAndUserId(taskId, userId);
    }
}
