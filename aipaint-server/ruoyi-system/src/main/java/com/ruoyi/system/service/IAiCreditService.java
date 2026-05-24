package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiCreditBatch;
import com.ruoyi.system.domain.AiCreditRecord;

/**
 * 用户积分 服务层
 */
public interface IAiCreditService
{
    public static final int NEW_USER_GIFT_AMOUNT = 100;

    public static final int NEW_USER_GIFT_VALID_DAYS = 7;

    public int getAvailableBalance(Long userId);

    public boolean grantNewUserGiftIfNeeded(Long userId);

    public AiCreditBatch getNewUserGiftBatch(Long userId);

    public void consumeForGeneration(Long userId, Long taskId, int amount);

    public void refundForGenerationFailure(Long userId, Long taskId, int amount);

    public List<AiCreditRecord> listUserRecords(Long userId, Integer limit);
}
