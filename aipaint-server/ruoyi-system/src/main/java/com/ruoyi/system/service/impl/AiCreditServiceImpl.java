package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.system.domain.AiCreditBatch;
import com.ruoyi.system.domain.AiCreditRecord;
import com.ruoyi.system.mapper.AiCreditMapper;
import com.ruoyi.system.service.IAiCreditService;

/**
 * 用户积分 服务层处理
 */
@Service
public class AiCreditServiceImpl implements IAiCreditService
{
    private static final String SOURCE_NEW_USER_GIFT = "NEW_USER_GIFT";

    private static final String SOURCE_SIGNIN = "SIGNIN";

    private static final String SOURCE_GENERATION_REFUND = "GENERATION_REFUND";

    private static final String SOURCE_INVITE_REWARD = "INVITE_REWARD";

    private static final String RELATED_GENERATION = "GENERATION";

    private static final String CHANGE_GENERATION_CONSUME = "GENERATION_CONSUME";

    private static final String CHANGE_CREDIT_EXPIRE = "CREDIT_EXPIRE";

    @Autowired
    private AiCreditMapper creditMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int getAvailableBalance(Long userId)
    {
        processExpiredCredits(userId);
        Integer balance = creditMapper.selectAvailableBalance(userId);
        return balance == null ? 0 : balance.intValue();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean grantNewUserGiftIfNeeded(Long userId)
    {
        String sourceId = String.valueOf(userId);
        if (creditMapper.countBatchBySource(userId, SOURCE_NEW_USER_GIFT, sourceId) > 0)
        {
            return false;
        }

        Date now = DateUtils.getNowDate();
        Date expireTime = DateUtils.addDays(now, NEW_USER_GIFT_VALID_DAYS);
        try
        {
            grantCredits(userId, SOURCE_NEW_USER_GIFT, sourceId, NEW_USER_GIFT_AMOUNT, expireTime, "新人礼包，7天有效");
            return true;
        }
        catch (DuplicateKeyException e)
        {
            // 并发首次登录时，唯一键保证只发放一次。
            return false;
        }
    }

    @Override
    public AiCreditBatch getNewUserGiftBatch(Long userId)
    {
        return creditMapper.selectBatchBySource(userId, SOURCE_NEW_USER_GIFT, String.valueOf(userId));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean grantDailySigninIfNeeded(Long userId)
    {
        String sourceId = DateUtils.getDate();
        if (creditMapper.countBatchBySource(userId, SOURCE_SIGNIN, sourceId) > 0)
        {
            return false;
        }

        try
        {
            grantCredits(userId, SOURCE_SIGNIN, sourceId, DAILY_SIGNIN_AMOUNT, DateUtils.addDays(DateUtils.getNowDate(), 7),
                    "每日签到奖励，7天有效");
            return true;
        }
        catch (DuplicateKeyException e)
        {
            // 连点或并发请求时，唯一键保证每天只发一次。
            return false;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void consumeForGeneration(Long userId, Long taskId, int amount)
    {
        if (amount <= 0)
        {
            return;
        }

        processExpiredCredits(userId);
        int balance = getAvailableBalance(userId);
        if (balance < amount)
        {
            throw new ServiceException("积分不足，请先充值");
        }

        int remaining = amount;
        List<AiCreditBatch> batches = creditMapper.selectAvailableBatchesForUpdate(userId);
        for (AiCreditBatch batch : batches)
        {
            if (remaining <= 0)
            {
                break;
            }
            int batchRemaining = batch.getRemainingAmount() == null ? 0 : batch.getRemainingAmount().intValue();
            int deductAmount = Math.min(batchRemaining, remaining);
            if (deductAmount > 0)
            {
                creditMapper.deductCreditBatch(batch.getBatchId(), deductAmount);
                remaining -= deductAmount;
            }
        }

        if (remaining > 0)
        {
            throw new ServiceException("积分不足，请先充值");
        }

        insertRecord(userId, CHANGE_GENERATION_CONSUME, -amount, getAvailableBalance(userId), RELATED_GENERATION,
                String.valueOf(taskId), "图片生成扣费");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void refundForGenerationFailure(Long userId, Long taskId, int amount)
    {
        if (amount <= 0)
        {
            return;
        }
        String sourceId = String.valueOf(taskId);
        if (creditMapper.countBatchBySource(userId, SOURCE_GENERATION_REFUND, sourceId) > 0)
        {
            return;
        }
        if (creditMapper.countRecordByChange(userId, CHANGE_GENERATION_CONSUME, RELATED_GENERATION, sourceId) <= 0)
        {
            return;
        }
        try
        {
            grantCredits(userId, SOURCE_GENERATION_REFUND, sourceId, amount, DateUtils.addDays(DateUtils.getNowDate(), NEW_USER_GIFT_VALID_DAYS),
                    "生成失败退款，7天有效");
        }
        catch (DuplicateKeyException e)
        {
            // 同一任务失败处理可能被重复触发，退款只保留一笔。
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void grantPaymentCredits(Long userId, String sourceType, String sourceId, int amount, Date expireTime, String remark)
    {
        if (amount <= 0)
        {
            return;
        }
        try
        {
            grantCredits(userId, sourceType, sourceId, amount, expireTime, remark);
        }
        catch (DuplicateKeyException e)
        {
            // 支付回调可能重复到达，唯一键保证同一订单只到账一次。
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean grantInviteRewardIfNeeded(Long userId, Long invitedUserId)
    {
        if (userId == null || invitedUserId == null)
        {
            return false;
        }
        String sourceId = String.valueOf(invitedUserId);
        if (creditMapper.countBatchBySource(userId, SOURCE_INVITE_REWARD, sourceId) > 0)
        {
            return false;
        }
        try
        {
            grantCredits(userId, SOURCE_INVITE_REWARD, sourceId, INVITE_REWARD_AMOUNT, null, "邀请好友奖励，永久有效");
            return true;
        }
        catch (DuplicateKeyException e)
        {
            // 同一被邀请人只为邀请人发放一次奖励。
            return false;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<AiCreditRecord> listUserRecords(Long userId, Integer limit)
    {
        processExpiredCredits(userId);
        int normalizedLimit = limit == null ? 50 : Math.max(1, Math.min(100, limit.intValue()));
        return creditMapper.selectCreditRecordsByUserId(userId, normalizedLimit);
    }

    private void processExpiredCredits(Long userId)
    {
        List<AiCreditBatch> expiredBatches = creditMapper.selectExpiredBatchesForUpdate(userId);
        for (AiCreditBatch batch : expiredBatches)
        {
            int expiredAmount = batch.getRemainingAmount() == null ? 0 : batch.getRemainingAmount().intValue();
            if (expiredAmount <= 0)
            {
                continue;
            }
            int updated = creditMapper.expireCreditBatch(batch.getBatchId());
            if (updated > 0)
            {
                Integer balanceAfter = creditMapper.selectAvailableBalance(userId);
                insertRecord(userId, CHANGE_CREDIT_EXPIRE, -expiredAmount, balanceAfter == null ? 0 : balanceAfter.intValue(),
                        batch.getSourceType(), batch.getSourceId(), resolveExpireRemark(batch));
            }
        }
    }

    private String resolveExpireRemark(AiCreditBatch batch)
    {
        String sourceType = batch.getSourceType();
        if (SOURCE_SIGNIN.equals(sourceType))
        {
            return "签到积分过期";
        }
        if (SOURCE_NEW_USER_GIFT.equals(sourceType))
        {
            return "新人礼包积分过期";
        }
        if ("PAYMENT_MEMBERSHIP".equals(sourceType))
        {
            return "会员赠送积分过期";
        }
        if (SOURCE_GENERATION_REFUND.equals(sourceType))
        {
            return "退款积分过期";
        }
        if (SOURCE_INVITE_REWARD.equals(sourceType))
        {
            return "邀请奖励积分过期";
        }
        return "积分过期";
    }

    private void grantCredits(Long userId, String sourceType, String sourceId, int amount, Date expireTime, String remark)
    {
        AiCreditBatch batch = new AiCreditBatch();
        batch.setUserId(userId);
        batch.setSourceType(sourceType);
        batch.setSourceId(sourceId);
        batch.setTotalAmount(amount);
        batch.setRemainingAmount(amount);
        batch.setExpireTime(expireTime);
        batch.setRemark(remark);
        creditMapper.insertCreditBatch(batch);

        insertRecord(userId, sourceType, amount, getAvailableBalance(userId), sourceType, sourceId, remark);
    }

    private void insertRecord(Long userId, String changeType, int amount, int balanceAfter, String relatedType, String relatedId, String remark)
    {
        AiCreditRecord record = new AiCreditRecord();
        record.setUserId(userId);
        record.setChangeType(changeType);
        record.setAmount(amount);
        record.setBalanceAfter(balanceAfter);
        record.setRelatedType(relatedType);
        record.setRelatedId(relatedId);
        record.setRemark(remark);
        creditMapper.insertCreditRecord(record);
    }
}
