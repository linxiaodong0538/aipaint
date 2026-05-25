package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI 图片模型路由 ai_image_model_route
 */
public class AiImageModelRouteRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String model;

    private Boolean enabled;

    private String primaryProviderCode;

    private String backupProviderCode;

    private Boolean fallbackEnabled;

    private Integer sortOrder;

    private String remark;

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public Boolean getEnabled()
    {
        return enabled;
    }

    public void setEnabled(Boolean enabled)
    {
        this.enabled = enabled;
    }

    public String getPrimaryProviderCode()
    {
        return primaryProviderCode;
    }

    public void setPrimaryProviderCode(String primaryProviderCode)
    {
        this.primaryProviderCode = primaryProviderCode;
    }

    public String getBackupProviderCode()
    {
        return backupProviderCode;
    }

    public void setBackupProviderCode(String backupProviderCode)
    {
        this.backupProviderCode = backupProviderCode;
    }

    public Boolean getFallbackEnabled()
    {
        return fallbackEnabled;
    }

    public void setFallbackEnabled(Boolean fallbackEnabled)
    {
        this.fallbackEnabled = fallbackEnabled;
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
