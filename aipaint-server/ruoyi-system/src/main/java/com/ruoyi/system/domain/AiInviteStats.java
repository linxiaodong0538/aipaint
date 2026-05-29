package com.ruoyi.system.domain;

/**
 * 邀请奖励统计
 */
public class AiInviteStats
{
    private Integer totalInvites;

    private Integer totalRewardCredits;

    private Integer todayInvites;

    public AiInviteStats()
    {
    }

    public AiInviteStats(Integer totalInvites, Integer totalRewardCredits, Integer todayInvites)
    {
        this.totalInvites = totalInvites;
        this.totalRewardCredits = totalRewardCredits;
        this.todayInvites = todayInvites;
    }

    public Integer getTotalInvites()
    {
        return totalInvites;
    }

    public void setTotalInvites(Integer totalInvites)
    {
        this.totalInvites = totalInvites;
    }

    public Integer getTotalRewardCredits()
    {
        return totalRewardCredits;
    }

    public void setTotalRewardCredits(Integer totalRewardCredits)
    {
        this.totalRewardCredits = totalRewardCredits;
    }

    public Integer getTodayInvites()
    {
        return todayInvites;
    }

    public void setTodayInvites(Integer todayInvites)
    {
        this.todayInvites = todayInvites;
    }
}
