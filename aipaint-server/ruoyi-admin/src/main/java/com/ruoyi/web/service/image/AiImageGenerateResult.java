package com.ruoyi.web.service.image;

/**
 * AI 生图执行结果
 */
public class AiImageGenerateResult
{
    private String resultImageUrl;

    private String providerCode;

    private Boolean fallbackUsed;

    public AiImageGenerateResult(String resultImageUrl, String providerCode, Boolean fallbackUsed)
    {
        this.resultImageUrl = resultImageUrl;
        this.providerCode = providerCode;
        this.fallbackUsed = fallbackUsed;
    }

    public String getResultImageUrl()
    {
        return resultImageUrl;
    }

    public void setResultImageUrl(String resultImageUrl)
    {
        this.resultImageUrl = resultImageUrl;
    }

    public String getProviderCode()
    {
        return providerCode;
    }

    public void setProviderCode(String providerCode)
    {
        this.providerCode = providerCode;
    }

    public Boolean getFallbackUsed()
    {
        return fallbackUsed;
    }

    public void setFallbackUsed(Boolean fallbackUsed)
    {
        this.fallbackUsed = fallbackUsed;
    }
}
