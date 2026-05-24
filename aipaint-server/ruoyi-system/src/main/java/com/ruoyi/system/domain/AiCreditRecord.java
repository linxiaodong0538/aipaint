package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 用户积分流水 ai_credit_record
 */
public class AiCreditRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;

    private Long userId;

    private String changeType;

    private Integer amount;

    private Integer balanceAfter;

    private String relatedType;

    private String relatedId;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getChangeType()
    {
        return changeType;
    }

    public void setChangeType(String changeType)
    {
        this.changeType = changeType;
    }

    public Integer getAmount()
    {
        return amount;
    }

    public void setAmount(Integer amount)
    {
        this.amount = amount;
    }

    public Integer getBalanceAfter()
    {
        return balanceAfter;
    }

    public void setBalanceAfter(Integer balanceAfter)
    {
        this.balanceAfter = balanceAfter;
    }

    public String getRelatedType()
    {
        return relatedType;
    }

    public void setRelatedType(String relatedType)
    {
        this.relatedType = relatedType;
    }

    public String getRelatedId()
    {
        return relatedId;
    }

    public void setRelatedId(String relatedId)
    {
        this.relatedId = relatedId;
    }
}
