package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiInviteRecord;
import com.ruoyi.system.domain.AiInviteStats;

/**
 * 邀请奖励 数据层
 */
public interface AiInviteMapper
{
    public List<AiInviteRecord> selectInviteRecordList(AiInviteRecord record);

    public int insertInviteRecord(AiInviteRecord record);

    public int countByInvitedUserId(@Param("invitedUserId") Long invitedUserId);

    public AiInviteStats selectInviteStats(@Param("inviterUserId") Long inviterUserId);
}
