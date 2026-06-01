package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.AiPaymentOrder;
import com.ruoyi.system.domain.AiUserMembership;

/**
 * 小程序支付 服务层
 */
public interface IAiPaymentService
{
    public List<AiPaymentOrder> selectPaymentOrderList(AiPaymentOrder order);

    public PaymentPrepayResult createWechatPayment(Long userId, String productId);

    public AiPaymentOrder getUserOrder(Long userId, String outTradeNo);

    public AiUserMembership getActiveMembership(Long userId);

    public void handleWechatNotify(Map<String, String> headers, String body);

    public AiPaymentOrder syncWechatPayment(String outTradeNo);

    public static class PaymentPrepayResult
    {
        private AiPaymentOrder order;

        private Map<String, String> paymentParams;

        public AiPaymentOrder getOrder()
        {
            return order;
        }

        public void setOrder(AiPaymentOrder order)
        {
            this.order = order;
        }

        public Map<String, String> getPaymentParams()
        {
            return paymentParams;
        }

        public void setPaymentParams(Map<String, String> paymentParams)
        {
            this.paymentParams = paymentParams;
        }
    }
}
