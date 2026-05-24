package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 用户会员 ai_user_membership
 */
public class AiUserMembership extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long userId;

    private String memberTier;

    private Integer addonBonus;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getMemberTier()
    {
        return memberTier;
    }

    public void setMemberTier(String memberTier)
    {
        this.memberTier = memberTier;
    }

    public Integer getAddonBonus()
    {
        return addonBonus;
    }

    public void setAddonBonus(Integer addonBonus)
    {
        this.addonBonus = addonBonus;
    }

    public Date getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Date expireTime)
    {
        this.expireTime = expireTime;
    }
}
