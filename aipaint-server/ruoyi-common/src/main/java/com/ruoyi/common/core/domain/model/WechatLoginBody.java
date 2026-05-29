package com.ruoyi.common.core.domain.model;

/**
 * 微信小程序登录参数
 */
public class WechatLoginBody
{
    /** 微信登录临时凭证 */
    private String code;

    /** 邀请人用户ID */
    private String inviteCode;

    /** 本地开发模拟 openid，仅在后端未配置微信 appid/secret 时生效 */
    private String devOpenid;

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public String getInviteCode()
    {
        return inviteCode;
    }

    public void setInviteCode(String inviteCode)
    {
        this.inviteCode = inviteCode;
    }

    public String getDevOpenid()
    {
        return devOpenid;
    }

    public void setDevOpenid(String devOpenid)
    {
        this.devOpenid = devOpenid;
    }
}
