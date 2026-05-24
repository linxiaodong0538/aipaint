package com.ruoyi.web.controller.mini;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.MiniPaymentCreateBody;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.AiPaymentOrder;
import com.ruoyi.system.service.IAiPaymentService;

/**
 * 小程序支付
 */
@RestController
@RequestMapping("/mini/payment")
public class MiniPaymentController extends BaseController
{
    @Autowired
    private IAiPaymentService paymentService;

    @PostMapping("/orders")
    public AjaxResult createOrder(@RequestBody MiniPaymentCreateBody body)
    {
        IAiPaymentService.PaymentPrepayResult result = paymentService.createWechatPayment(SecurityUtils.getUserId(), body.getProductId());
        AjaxResult ajax = success();
        ajax.put("order", result.getOrder());
        ajax.put("paymentParams", result.getPaymentParams());
        return ajax;
    }

    @GetMapping("/orders/{outTradeNo}")
    public AjaxResult getOrder(@PathVariable String outTradeNo)
    {
        AiPaymentOrder order = paymentService.getUserOrder(SecurityUtils.getUserId(), outTradeNo);
        return success(order);
    }

    /**
     * 微信支付回调通知接收接口（小程序支付 v3）
     * 
     * 该接口接收微信支付平台的支付结果通知。
     * 微信会以 POST 请求方式，将支付结果（加密报文）以 JSON 格式推送到该接口。
     * 回调请求头用于验签、解密，必须完整收集所有 HTTP 头信息，忽略大小写。
     * 
     * @param body           微信推送通知的原始 JSON 字符串（密文）
     * @param requestHeaders Spring 自动注入的部分请求头集合
     * @param request        Servlet 请求对象，可获取全部请求头
     * @return               标准响应体，code 为 SUCCESS 表示已成功处理
     */
    @Anonymous
    @PostMapping(value = "/wechat/notify", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> wechatNotify(@RequestBody String body, @RequestHeader Map<String, String> requestHeaders,
                                               HttpServletRequest request)
    {
        // 由于有些 Header 可能大小写不同，这里统一转为小写 key
        Map<String, String> headers = new HashMap<>();
        for (Map.Entry<String, String> entry : requestHeaders.entrySet())
        {
            headers.put(entry.getKey().toLowerCase(), entry.getValue());
        }
        // 补充所有请求头，确保完整收集所有头信息
        Enumeration<String> names = request.getHeaderNames();
        while (names.hasMoreElements())
        {
            String name = names.nextElement();
            headers.put(name.toLowerCase(), request.getHeader(name));
        }

        // 核心业务：处理回调通知并做验签与幂等到账等逻辑，异常内部吞掉并保证状态码 200
        paymentService.handleWechatNotify(headers, body);

        // 按微信官方要求返回固定格式，表示通知已成功处理（即使已处理过也需如此返回）
        return ResponseEntity.ok("{\"code\":\"SUCCESS\",\"message\":\"成功\"}");
    }
}
