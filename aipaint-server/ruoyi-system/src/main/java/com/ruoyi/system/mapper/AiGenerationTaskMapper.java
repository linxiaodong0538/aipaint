package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiGenerationTask;

/**
 * AI图片生成任务 数据层
 */
public interface AiGenerationTaskMapper
{
    public AiGenerationTask selectGenerationTaskById(Long taskId);

    public AiGenerationTask selectGenerationTaskByIdAndUserId(@Param("taskId") Long taskId, @Param("userId") Long userId);

    public List<AiGenerationTask> selectGenerationTasksByUserId(@Param("userId") Long userId, @Param("status") String status);

    public int insertGenerationTask(AiGenerationTask task);

    public int updateGenerationTask(AiGenerationTask task);
}
