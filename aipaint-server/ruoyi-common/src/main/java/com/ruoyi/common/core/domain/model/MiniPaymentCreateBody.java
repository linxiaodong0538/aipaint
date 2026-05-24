package com.ruoyi.common.core.domain.model;

/**
 * 小程序创建支付订单请求
 */
public class MiniPaymentCreateBody
{
    private String productId;

    public String getProductId()
    {
        return productId;
    }

    public void setProductId(String productId)
    {
        this.productId = productId;
    }
}
