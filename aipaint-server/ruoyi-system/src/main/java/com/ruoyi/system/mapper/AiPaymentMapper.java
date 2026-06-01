package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiPaymentOrder;
import com.ruoyi.system.domain.AiUserMembership;

/**
 * 支付订单 数据层
 */
public interface AiPaymentMapper
{
    public List<AiPaymentOrder> selectPaymentOrderList(AiPaymentOrder order);

    public int insertPaymentOrder(AiPaymentOrder order);

    public AiPaymentOrder selectPaymentOrderByOutTradeNo(@Param("outTradeNo") String outTradeNo);

    public AiPaymentOrder selectPaymentOrderByOutTradeNoForUpdate(@Param("outTradeNo") String outTradeNo);

    public int updatePaymentOrderPrepay(@Param("outTradeNo") String outTradeNo, @Param("prepayId") String prepayId);

    public int markPaymentOrderPaid(AiPaymentOrder order);

    public AiUserMembership selectMembershipByUserId(@Param("userId") Long userId);

    public int insertMembership(AiUserMembership membership);

    public int updateMembership(AiUserMembership membership);
}
