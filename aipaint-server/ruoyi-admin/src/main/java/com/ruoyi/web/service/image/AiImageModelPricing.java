package com.ruoyi.web.service.image;

/**
 * AI 生图模型价格配置
 */
public class AiImageModelPricing
{
    private String model;

    private Integer baseCredits;

    private Boolean enabled;

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

    public Integer getBaseCredits()
    {
        return baseCredits;
    }

    public void setBaseCredits(Integer baseCredits)
    {
        this.baseCredits = baseCredits;
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
