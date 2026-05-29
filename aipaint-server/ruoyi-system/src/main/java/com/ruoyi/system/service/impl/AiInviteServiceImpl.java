package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiInviteRecord;
import com.ruoyi.system.domain.AiInviteStats;
import com.ruoyi.system.mapper.AiInviteMapper;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.IAiInviteService;
import com.ruoyi.system.service.ISysUserService;

/**
 * 邀请奖励 服务层处理
 */
@Service
public class AiInviteServiceImpl implements IAiInviteService
{
    private static final String REWARD_STATUS_GRANTED = "GRANTED";

    @Autowired
    private AiInviteMapper inviteMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private IAiCreditService creditService;

    @Override
    public List<AiInviteRecord> selectInviteRecordList(AiInviteRecord record)
    {
        return inviteMapper.selectInviteRecordList(record);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean handleNewUserInvite(Long invitedUserId, String inviteCode)
    {
        Long inviterUserId = parseInviteCode(inviteCode);
        if (invitedUserId == null || inviterUserId == null || invitedUserId.equals(inviterUserId))
        {
            return false;
        }
        if (inviteMapper.countByInvitedUserId(invitedUserId) > 0)
        {
            return false;
        }

        SysUser inviter = userService.selectUserById(inviterUserId);
        if (inviter == null || UserConstants.USER_DISABLE.equals(inviter.getStatus()))
        {
            return false;
        }

        try
        {
            AiInviteRecord record = new AiInviteRecord();
            record.setInviterUserId(inviterUserId);
            record.setInvitedUserId(invitedUserId);
            record.setRewardAmount(IAiCreditService.INVITE_REWARD_AMOUNT);
            record.setRewardStatus(REWARD_STATUS_GRANTED);
            inviteMapper.insertInviteRecord(record);
            if (!creditService.grantInviteRewardIfNeeded(inviterUserId, invitedUserId))
            {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                return false;
            }
            return true;
        }
        catch (DuplicateKeyException e)
        {
            return false;
        }
    }

    @Override
    public AiInviteStats getInviteStats(Long inviterUserId)
    {
        AiInviteStats stats = inviteMapper.selectInviteStats(inviterUserId);
        return stats == null ? new AiInviteStats(0, 0, 0) : stats;
    }

    private Long parseInviteCode(String inviteCode)
    {
        if (StringUtils.isBlank(inviteCode))
        {
            return null;
        }
        try
        {
            return Long.valueOf(inviteCode.trim());
        }
        catch (NumberFormatException e)
        {
            return null;
        }
    }
}
