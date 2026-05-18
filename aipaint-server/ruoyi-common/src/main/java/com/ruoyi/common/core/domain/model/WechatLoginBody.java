package com.ruoyi.common.core.domain.model;

/**
 * 微信小程序登录参数
 */
public class WechatLoginBody
{
    /** 微信登录临时凭证 */
    private String code;

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }
}
