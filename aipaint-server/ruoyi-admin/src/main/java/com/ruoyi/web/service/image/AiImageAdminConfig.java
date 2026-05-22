package com.ruoyi.web.service.image;

import java.util.List;
import com.ruoyi.system.domain.AiImageProviderHealthStats;

/**
 * AI 生图后台配置
 */
public class AiImageAdminConfig
{
    private String activeProvider;

    private Boolean fallbackEnabled;

    private String fallbackStrategy;

    private Integer circuitBreakerFailureThreshold;

    private Integer circuitBreakerCooldownMinutes;

    private Boolean forceSizeEnabled;

    private String forceSize;

    private AiImageProviderConfig primaryProvider;

    private AiImageProviderConfig backupProvider;

    private List<AiImageProviderHealthStats> healthStats;

    public String getActiveProvider()
    {
        return activeProvider;
    }

    public void setActiveProvider(String activeProvider)
    {
        this.activeProvider = activeProvider;
    }

    public Boolean getFallbackEnabled()
    {
        return fallbackEnabled;
    }

    public void setFallbackEnabled(Boolean fallbackEnabled)
    {
        this.fallbackEnabled = fallbackEnabled;
    }

    public String getFallbackStrategy()
    {
        return fallbackStrategy;
    }

    public void setFallbackStrategy(String fallbackStrategy)
    {
        this.fallbackStrategy = fallbackStrategy;
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

    public Boolean getForceSizeEnabled()
    {
        return forceSizeEnabled;
    }

    public void setForceSizeEnabled(Boolean forceSizeEnabled)
    {
        this.forceSizeEnabled = forceSizeEnabled;
    }

    public String getForceSize()
    {
        return forceSize;
    }

    public void setForceSize(String forceSize)
    {
        this.forceSize = forceSize;
    }

    public AiImageProviderConfig getPrimaryProvider()
    {
        return primaryProvider;
    }

    public void setPrimaryProvider(AiImageProviderConfig primaryProvider)
    {
        this.primaryProvider = primaryProvider;
    }

    public AiImageProviderConfig getBackupProvider()
    {
        return backupProvider;
    }

    public void setBackupProvider(AiImageProviderConfig backupProvider)
    {
        this.backupProvider = backupProvider;
    }

    public List<AiImageProviderHealthStats> getHealthStats()
    {
        return healthStats;
    }

    public void setHealthStats(List<AiImageProviderHealthStats> healthStats)
    {
        this.healthStats = healthStats;
    }
}
