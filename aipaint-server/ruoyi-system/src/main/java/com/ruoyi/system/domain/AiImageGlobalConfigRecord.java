package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI 图片全局配置 ai_image_global_config
 */
public class AiImageGlobalConfigRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long configId;

    private Integer circuitBreakerFailureThreshold;

    private Integer circuitBreakerCooldownMinutes;

    private String outputFormat;

    private Integer outputCompression;

    private String modelPricings;

    private String resolutionMultipliers;

    public Long getConfigId()
    {
        return configId;
    }

    public void setConfigId(Long configId)
    {
        this.configId = configId;
    }

    public Integer getCircuitBreakerFailureThreshold()
    {
        return circuitBreakerFailureThreshold;
    }

    public void setCircuitBreakerFailureThreshold(Integer circuitBreakerFailureThreshold)
    {
        this.circuitBreakerFailureThreshold = circuitBreakerFailureThreshold;
    }

    public Integer getCircuitBreakerCooldownMinutes()
    {
        return circuitBreakerCooldownMinutes;
    }

    public void setCircuitBreakerCooldownMinutes(Integer circuitBreakerCooldownMinutes)
    {
        this.circuitBreakerCooldownMinutes = circuitBreakerCooldownMinutes;
    }

    public String getOutputFormat()
    {
        return outputFormat;
    }

    public void setOutputFormat(String outputFormat)
    {
        this.outputFormat = outputFormat;
    }

    public Integer getOutputCompression()
    {
        return outputCompression;
    }

    public void setOutputCompression(Integer outputCompression)
    {
        this.outputCompression = outputCompression;
    }

    public String getModelPricings()
    {
        return modelPricings;
    }

    public void setModelPricings(String modelPricings)
    {
        this.modelPricings = modelPricings;
    }

    public String getResolutionMultipliers()
    {
        return resolutionMultipliers;
    }

    public void setResolutionMultipliers(String resolutionMultipliers)
    {
        this.resolutionMultipliers = resolutionMultipliers;
    }
}
