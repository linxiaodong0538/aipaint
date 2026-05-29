package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiInviteRecord;
import com.ruoyi.system.domain.AiInviteStats;

/**
 * 邀请奖励 服务层
 */
public interface IAiInviteService
{
    public List<AiInviteRecord> selectInviteRecordList(AiInviteRecord record);

    public boolean handleNewUserInvite(Long invitedUserId, String inviteCode);

    public AiInviteStats getInviteStats(Long inviterUserId);
}
