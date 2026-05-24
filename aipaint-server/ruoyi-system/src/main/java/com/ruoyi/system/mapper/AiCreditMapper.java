package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiCreditBatch;
import com.ruoyi.system.domain.AiCreditRecord;

/**
 * 用户积分 数据层
 */
public interface AiCreditMapper
{
    public Integer selectAvailableBalance(@Param("userId") Long userId);

    public int countBatchBySource(@Param("userId") Long userId, @Param("sourceType") String sourceType, @Param("sourceId") String sourceId);

    public AiCreditBatch selectBatchBySource(@Param("userId") Long userId, @Param("sourceType") String sourceType, @Param("sourceId") String sourceId);

    public int countRecordByChange(@Param("userId") Long userId, @Param("changeType") String changeType,
            @Param("relatedType") String relatedType, @Param("relatedId") String relatedId);

    public List<AiCreditBatch> selectAvailableBatchesForUpdate(@Param("userId") Long userId);

    public int insertCreditBatch(AiCreditBatch batch);

    public int deductCreditBatch(@Param("batchId") Long batchId, @Param("amount") Integer amount);

    public int insertCreditRecord(AiCreditRecord record);

    public List<AiCreditRecord> selectCreditRecordsByUserId(@Param("userId") Long userId, @Param("limit") Integer limit);
}
