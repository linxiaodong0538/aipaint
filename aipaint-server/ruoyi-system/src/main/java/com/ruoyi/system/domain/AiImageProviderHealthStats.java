package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI图片通道健康统计
 */
public class AiImageProviderHealthStats extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String providerCode;

    private Long totalCount;

    private Long successCount;

    private Long failedCount;

    private Double successRate;

    private Long avgDurationMs;

    private String lastStatus;

    private String lastErrorMessage;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date lastCallTime;

    private Long consecutiveFailures;

    public String getProviderCode()
    {
        return providerCode;
    }

    public void setProviderCode(String providerCode)
    {
        this.providerCode = providerCode;
    }

    public Long getTotalCount()
    {
        return totalCount;
    }

    public void setTotalCount(Long totalCount)
    {
        this.totalCount = totalCount;
    }

    public Long getSuccessCount()
    {
        return successCount;
    }

    public void setSuccessCount(Long successCount)
    {
        this.successCount = successCount;
    }

    public Long getFailedCount()
    {
        return failedCount;
    }

    public void setFailedCount(Long failedCount)
    {
        this.failedCount = failedCount;
    }

    public Double getSuccessRate()
    {
        return successRate;
    }

    public void setSuccessRate(Double successRate)
    {
        this.successRate = successRate;
    }

    public Long getAvgDurationMs()
    {
        return avgDurationMs;
    }

    public void setAvgDurationMs(Long avgDurationMs)
    {
        this.avgDurationMs = avgDurationMs;
    }

    public String getLastStatus()
    {
        return lastStatus;
    }

    public void setLastStatus(String lastStatus)
    {
        this.lastStatus = lastStatus;
    }

    public String getLastErrorMessage()
    {
        return lastErrorMessage;
    }

    public void setLastErrorMessage(String lastErrorMessage)
    {
        this.lastErrorMessage = lastErrorMessage;
    }

    public Date getLastCallTime()
    {
        return lastCallTime;
    }

    public void setLastCallTime(Date lastCallTime)
    {
        this.lastCallTime = lastCallTime;
    }

    public Long getConsecutiveFailures()
    {
        return consecutiveFailures;
    }

    public void setConsecutiveFailures(Long consecutiveFailures)
    {
        this.consecutiveFailures = consecutiveFailures;
    }
}
