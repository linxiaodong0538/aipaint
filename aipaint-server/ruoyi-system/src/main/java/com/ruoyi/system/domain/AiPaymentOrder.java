package com.ruoyi.system.domain;

import java.util.Date;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 支付订单 ai_payment_order
 */
public class AiPaymentOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long orderId;

    @Excel(name = "商户订单号")
    private String outTradeNo;

    @Excel(name = "用户ID", cellType = ColumnType.NUMERIC)
    private Long userId;

    @Excel(name = "商品ID")
    private String productId;

    @Excel(name = "商品类型")
    private String productType;

    @Excel(name = "商品名称")
    private String productName;

    @Excel(name = "支付金额(分)")
    private Integer amountCent;

    @Excel(name = "到账积分")
    private Integer credits;

    @Excel(name = "会员等级")
    private String memberTier;

    private Integer memberDays;

    @Excel(name = "订单状态")
    private String status;

    @Excel(name = "微信交易号")
    private String transactionId;

    private String prepayId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "支付时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date paidTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date notifyTime;

    private String rawNotify;

    @Excel(name = "用户昵称")
    private String userNickName;

    @Excel(name = "用户账号")
    private String userName;

    private String userOpenid;

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

    public String getUserNickName()
    {
        return userNickName;
    }

    public void setUserNickName(String userNickName)
    {
        this.userNickName = userNickName;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getUserOpenid()
    {
        return userOpenid;
    }

    public void setUserOpenid(String userOpenid)
    {
        this.userOpenid = userOpenid;
    }
}
