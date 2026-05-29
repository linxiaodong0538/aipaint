package com.ruoyi.system.domain;

import java.util.Date;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 邀请奖励记录 ai_invite_record
 */
public class AiInviteRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "记录ID", cellType = ColumnType.NUMERIC)
    private Long recordId;

    @Excel(name = "邀请人ID", cellType = ColumnType.NUMERIC)
    private Long inviterUserId;

    @Excel(name = "被邀请人ID", cellType = ColumnType.NUMERIC)
    private Long invitedUserId;

    @Excel(name = "奖励积分")
    private Integer rewardAmount;

    @Excel(name = "奖励状态")
    private String rewardStatus;

    @Excel(name = "邀请人昵称")
    private String inviterNickName;

    @Excel(name = "邀请人账号")
    private String inviterUserName;

    @Excel(name = "被邀请人昵称")
    private String invitedNickName;

    @Excel(name = "被邀请人账号")
    private String invitedUserName;

    @Excel(name = "邀请时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date inviteTime;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getInviterUserId()
    {
        return inviterUserId;
    }

    public void setInviterUserId(Long inviterUserId)
    {
        this.inviterUserId = inviterUserId;
    }

    public Long getInvitedUserId()
    {
        return invitedUserId;
    }

    public void setInvitedUserId(Long invitedUserId)
    {
        this.invitedUserId = invitedUserId;
    }

    public Integer getRewardAmount()
    {
        return rewardAmount;
    }

    public void setRewardAmount(Integer rewardAmount)
    {
        this.rewardAmount = rewardAmount;
    }

    public String getRewardStatus()
    {
        return rewardStatus;
    }

    public void setRewardStatus(String rewardStatus)
    {
        this.rewardStatus = rewardStatus;
    }

    public String getInviterNickName()
    {
        return inviterNickName;
    }

    public void setInviterNickName(String inviterNickName)
    {
        this.inviterNickName = inviterNickName;
    }

    public String getInviterUserName()
    {
        return inviterUserName;
    }

    public void setInviterUserName(String inviterUserName)
    {
        this.inviterUserName = inviterUserName;
    }

    public String getInvitedNickName()
    {
        return invitedNickName;
    }

    public void setInvitedNickName(String invitedNickName)
    {
        this.invitedNickName = invitedNickName;
    }

    public String getInvitedUserName()
    {
        return invitedUserName;
    }

    public void setInvitedUserName(String invitedUserName)
    {
        this.invitedUserName = invitedUserName;
    }

    public Date getInviteTime()
    {
        return inviteTime;
    }

    public void setInviteTime(Date inviteTime)
    {
        this.inviteTime = inviteTime;
    }
}
