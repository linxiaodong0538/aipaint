package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI 图片通道支持模型 ai_image_provider_model
 */
public class AiImageProviderModelRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String providerCode;

    private String model;

    private String providerModel;

    private Boolean enabled;

    public String getProviderCode()
    {
        return providerCode;
    }

    public void setProviderCode(String providerCode)
    {
        this.providerCode = providerCode;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public String getProviderModel()
    {
        return providerModel;
    }

    public void setProviderModel(String providerModel)
    {
        this.providerModel = providerModel;
    }

    public Boolean getEnabled()
    {
        return enabled;
    }

    public void setEnabled(Boolean enabled)
    {
        this.enabled = enabled;
    }
}
