package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI 图片通道配置 ai_image_provider
 */
public class AiImageProviderRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String providerCode;

    private String providerName;

    private String adapterType;

    private String responseMode;

    private Boolean supportsBatch;

    private String baseUrl;

    private String apiKey;

    private Boolean enabled;

    private Integer sortOrder;

    private String remark;

    public String getProviderCode()
    {
        return providerCode;
    }

    public void setProviderCode(String providerCode)
    {
        this.providerCode = providerCode;
    }

    public String getProviderName()
    {
        return providerName;
    }

    public void setProviderName(String providerName)
    {
        this.providerName = providerName;
    }

    public String getAdapterType()
    {
        return adapterType;
    }

    public void setAdapterType(String adapterType)
    {
        this.adapterType = adapterType;
    }

    public String getResponseMode()
    {
        return responseMode;
    }

    public void setResponseMode(String responseMode)
    {
        this.responseMode = responseMode;
    }

    public Boolean getSupportsBatch()
    {
        return supportsBatch;
    }

    public void setSupportsBatch(Boolean supportsBatch)
    {
        this.supportsBatch = supportsBatch;
    }

    public String getBaseUrl()
    {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl)
    {
        this.baseUrl = baseUrl;
    }

    public String getApiKey()
    {
        return apiKey;
    }

    public void setApiKey(String apiKey)
    {
        this.apiKey = apiKey;
    }

    public Boolean getEnabled()
    {
        return enabled;
    }

    public void setEnabled(Boolean enabled)
    {
        this.enabled = enabled;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }
}
