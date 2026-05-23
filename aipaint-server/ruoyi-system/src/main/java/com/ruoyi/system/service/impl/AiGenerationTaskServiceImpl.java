package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.mapper.AiGenerationTaskMapper;
import com.ruoyi.system.service.IAiGenerationTaskService;

/**
 * AI图片生成任务 服务层处理
 */
@Service
public class AiGenerationTaskServiceImpl implements IAiGenerationTaskService
{
    @Autowired
    private AiGenerationTaskMapper taskMapper;

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
        task.setPreviewImageUrl(resultImageUrl);
        task.setFinishTime(new Date());
        taskMapper.updateGenerationTask(task);
    }

    @Override
    public void markFailed(Long taskId, String errorMessage)
    {
        AiGenerationTask task = new AiGenerationTask();
        task.setTaskId(taskId);
        task.setStatus("failed");
        task.setProgress(100);
        task.setErrorMessage(errorMessage);
        task.setFinishTime(new Date());
        taskMapper.updateGenerationTask(task);
    }
}
