package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 支付订单 ai_payment_order
 */
public class AiPaymentOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long orderId;

    private String outTradeNo;

    private Long userId;

    private String productId;

    private String productType;

    private String productName;

    private Integer amountCent;

    private Integer credits;

    private String memberTier;

    private Integer memberDays;

    private String status;

    private String transactionId;

    private String prepayId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date paidTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date notifyTime;

    private String rawNotify;

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public String getOutTradeNo()
    {
        return outTradeNo;
    }

    public void setOutTradeNo(String outTradeNo)
    {
        this.outTradeNo = outTradeNo;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getProductId()
    {
        return productId;
    }

    public void setProductId(String productId)
    {
        this.productId = productId;
    }

    public String getProductType()
    {
        return productType;
    }

    public void setProductType(String productType)
    {
        this.productType = productType;
    }

    public String getProductName()
    {
        return productName;
    }

    public void setProductName(String productName)
    {
        this.productName = productName;
    }

    public Integer getAmountCent()
    {
        return amountCent;
    }

    public void setAmountCent(Integer amountCent)
    {
        this.amountCent = amountCent;
    }

    public Integer getCredits()
    {
        return credits;
    }

    public void setCredits(Integer credits)
    {
        this.credits = credits;
    }

    public String getMemberTier()
    {
        return memberTier;
    }

    public void setMemberTier(String memberTier)
    {
        this.memberTier = memberTier;
    }

    public Integer getMemberDays()
    {
        return memberDays;
    }

    public void setMemberDays(Integer memberDays)
    {
        this.memberDays = memberDays;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getTransactionId()
    {
        return transactionId;
    }

    public void setTransactionId(String transactionId)
    {
        this.transactionId = transactionId;
    }

    public String getPrepayId()
    {
        return prepayId;
    }

    public void setPrepayId(String prepayId)
    {
        this.prepayId = prepayId;
    }

    public Date getPaidTime()
    {
        return paidTime;
    }

    public void setPaidTime(Date paidTime)
    {
        this.paidTime = paidTime;
    }

    public Date getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Date expireTime)
    {
        this.expireTime = expireTime;
    }

    public Date getNotifyTime()
    {
        return notifyTime;
    }

    public void setNotifyTime(Date notifyTime)
    {
        this.notifyTime = notifyTime;
    }

    public String getRawNotify()
    {
        return rawNotify;
    }

    public void setRawNotify(String rawNotify)
    {
        this.rawNotify = rawNotify;
    }
}
