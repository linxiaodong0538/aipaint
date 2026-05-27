package com.ruoyi.web.service.image;

import java.util.List;

/**
 * AI 生图 Provider 配置
 */
public class AiImageProviderConfig
{
    private String providerCode;

    private String providerName;

    private Boolean enabled;

    private String adapterType;

    private String responseMode;

    private Boolean supportsBatch;

    private String baseUrl;

    private String apiKey;

    private String model;

    private List<String> supportedModels;

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

    public Boolean getEnabled()
    {
        return enabled;
    }

    public void setEnabled(Boolean enabled)
    {
        this.enabled = enabled;
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

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public List<String> getSupportedModels()
    {
        return supportedModels;
    }

    public void setSupportedModels(List<String> supportedModels)
    {
        this.supportedModels = supportedModels;
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
