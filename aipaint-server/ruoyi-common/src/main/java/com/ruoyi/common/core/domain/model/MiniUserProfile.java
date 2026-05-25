package com.ruoyi.common.core.domain.model;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * 小程序用户资料
 */
public class MiniUserProfile
{
    private String id;

    private String nickname;

    private String avatar;

    private Integer creditBalance;

    private Boolean newUserGiftGranted;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date newUserGiftExpireTime;

    private String memberTier;

    private Integer memberAddonBonus;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date memberExpireTime;

    public MiniUserProfile()
    {
    }

    public MiniUserProfile(String id, String nickname, String avatar)
    {
        this(id, nickname, avatar, 0);
    }

    public MiniUserProfile(String id, String nickname, String avatar, Integer creditBalance)
    {
        this.id = id;
        this.nickname = nickname;
        this.avatar = avatar;
        this.creditBalance = creditBalance;
    }

    public String getId()
    {
        return id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    public String getNickname()
    {
        return nickname;
    }

    public void setNickname(String nickname)
    {
        this.nickname = nickname;
    }

    public String getAvatar()
    {
        return avatar;
    }

    public void setAvatar(String avatar)
    {
        this.avatar = avatar;
    }

    public Integer getCreditBalance()
    {
        return creditBalance;
    }

    public void setCreditBalance(Integer creditBalance)
    {
        this.creditBalance = creditBalance;
    }

    public Boolean getNewUserGiftGranted()
    {
        return newUserGiftGranted;
    }

    public void setNewUserGiftGranted(Boolean newUserGiftGranted)
    {
        this.newUserGiftGranted = newUserGiftGranted;
    }

    public Date getNewUserGiftExpireTime()
    {
        return newUserGiftExpireTime;
    }

    public void setNewUserGiftExpireTime(Date newUserGiftExpireTime)
    {
        this.newUserGiftExpireTime = newUserGiftExpireTime;
    }

    public String getMemberTier()
    {
        return memberTier;
    }

    public void setMemberTier(String memberTier)
    {
        this.memberTier = memberTier;
    }

    public Integer getMemberAddonBonus()
    {
        return memberAddonBonus;
    }

    public void setMemberAddonBonus(Integer memberAddonBonus)
    {
        this.memberAddonBonus = memberAddonBonus;
    }

    public Date getMemberExpireTime()
    {
        return memberExpireTime;
    }

    public void setMemberExpireTime(Date memberExpireTime)
    {
        this.memberExpireTime = memberExpireTime;
    }
}
