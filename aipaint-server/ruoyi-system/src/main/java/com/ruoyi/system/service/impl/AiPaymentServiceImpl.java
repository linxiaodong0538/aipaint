package com.ruoyi.system.service.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import com.ruoyi.system.domain.AiPaymentOrder;
import com.ruoyi.system.domain.AiUserMembership;
import com.ruoyi.system.mapper.AiPaymentMapper;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.IAiPaymentService;
import com.ruoyi.system.service.ISysUserService;

/**
 * 小程序微信支付 服务层处理
 */
@Service
public class AiPaymentServiceImpl implements IAiPaymentService
{
    private static final String PRODUCT_TYPE_MEMBERSHIP = "MEMBERSHIP";

    private static final String PRODUCT_TYPE_ADDON = "ADDON";

    private static final String STATUS_CREATED = "CREATED";

    private static final String STATUS_PAID = "PAID";

    private static final String SOURCE_PAYMENT_MEMBERSHIP = "PAYMENT_MEMBERSHIP";

    private static final String SOURCE_PAYMENT_ADDON = "PAYMENT_ADDON";

    private static final String WECHAT_JSAPI_URL = "https://api.mch.weixin.qq.com/v3/pay/transactions/jsapi";

    private static final String WECHAT_ORDER_QUERY_URL = "https://api.mch.weixin.qq.com/v3/pay/transactions/out-trade-no/";

    private static final Map<String, Product> PRODUCTS = buildProducts();

    @Value("${wechat.miniapp.appid:}")
    private String appid;

    @Value("${wechat.pay.enabled:false}")
    private boolean payEnabled;

    @Value("${wechat.pay.mch-id:}")
    private String mchId;

    @Value("${wechat.pay.mch-serial-no:}")
    private String mchSerialNo;

    @Value("${wechat.pay.api-v3-key:}")
    private String apiV3Key;

    @Value("${wechat.pay.private-key-path:}")
    private String privateKeyPath;

    @Value("${wechat.pay.private-key:}")
    private String privateKeyText;

    @Value("${wechat.pay.platform-certificate-path:}")
    private String platformCertificatePath;

    @Value("${wechat.pay.notify-url:}")
    private String notifyUrl;

    @Value("${wechat.pay.debug-amount-cent:0}")
    private int debugAmountCent;

    @Autowired
    private AiPaymentMapper paymentMapper;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private IAiCreditService creditService;

    private final HttpClient httpClient = HttpClient.newHttpClient();

    private volatile PrivateKey cachedPrivateKey;

    private volatile PublicKey cachedWechatPayPublicKey;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PaymentPrepayResult createWechatPayment(Long userId, String productId)
    {
        ensureWechatPayConfig();
        Product product = resolveProduct(productId);
        SysUser user = userService.selectUserById(userId);
        if (user == null || StringUtils.isBlank(user.getOpenid()))
        {
            throw new ServiceException("用户微信身份缺失，请重新登录后再支付");
        }

        int credits = product.credits;
        if (PRODUCT_TYPE_ADDON.equals(product.type))
        {
            AiUserMembership membership = getActiveMembership(userId);
            if (membership == null)
            {
                throw new ServiceException("请先开通会员套餐");
            }
            int addonBonus = membership.getAddonBonus() == null ? 0 : membership.getAddonBonus().intValue();
            credits = product.credits + BigDecimal.valueOf(product.credits)
                    .multiply(BigDecimal.valueOf(addonBonus))
                    .divide(BigDecimal.valueOf(100))
                    .intValue();
        }

        AiPaymentOrder order = new AiPaymentOrder();
        order.setOutTradeNo(buildOutTradeNo());
        order.setUserId(userId);
        order.setProductId(product.id);
        order.setProductType(product.type);
        order.setProductName(product.name);
        order.setAmountCent(resolvePayAmountCent(product));
        order.setCredits(credits);
        order.setMemberTier(product.memberTier);
        order.setMemberDays(product.memberDays);
        order.setStatus(STATUS_CREATED);
        order.setExpireTime(DateUtils.addMinutes(DateUtils.getNowDate(), 30));
        paymentMapper.insertPaymentOrder(order);

        String prepayId = requestWechatPrepay(order, user.getOpenid());
        paymentMapper.updatePaymentOrderPrepay(order.getOutTradeNo(), prepayId);
        order.setPrepayId(prepayId);

        PaymentPrepayResult result = new PaymentPrepayResult();
        result.setOrder(order);
        result.setPaymentParams(buildMiniProgramPaymentParams(prepayId));
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public AiPaymentOrder getUserOrder(Long userId, String outTradeNo)
    {
        AiPaymentOrder order = paymentMapper.selectPaymentOrderByOutTradeNo(outTradeNo);
        if (order == null || !userId.equals(order.getUserId()))
        {
            throw new ServiceException("订单不存在");
        }
        if (!STATUS_PAID.equals(order.getStatus()))
        {
            syncPaidOrderFromWechat(order);
            order = paymentMapper.selectPaymentOrderByOutTradeNo(outTradeNo);
        }
        return order;
    }

    @Override
    public AiUserMembership getActiveMembership(Long userId)
    {
        AiUserMembership membership = paymentMapper.selectMembershipByUserId(userId);
        if (membership == null || membership.getExpireTime() == null || !membership.getExpireTime().after(DateUtils.getNowDate()))
        {
            return null;
        }
        return membership;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void handleWechatNotify(Map<String, String> headers, String body)
    {
        verifyWechatNotifySignature(headers, body);
        JSONObject payload = JSON.parseObject(body);
        String eventType = payload.getString("event_type");
        if (!"TRANSACTION.SUCCESS".equals(eventType))
        {
            return;
        }

        JSONObject resource = payload.getJSONObject("resource");
        String plainText = decryptResource(resource);
        JSONObject transaction = JSON.parseObject(plainText);
        String outTradeNo = transaction.getString("out_trade_no");
        String tradeState = transaction.getString("trade_state");
        if (!"SUCCESS".equals(tradeState))
        {
            return;
        }

        applySuccessfulTransaction(outTradeNo, transaction, plainText);
    }

    private void applySuccessfulTransaction(String outTradeNo, JSONObject transaction, String rawNotify)
    {
        AiPaymentOrder order = paymentMapper.selectPaymentOrderByOutTradeNoForUpdate(outTradeNo);
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        if (STATUS_PAID.equals(order.getStatus()))
        {
            return;
        }

        Integer paidAmount = transaction.getJSONObject("amount").getInteger("total");
        if (paidAmount == null || !paidAmount.equals(order.getAmountCent()))
        {
            throw new ServiceException("支付金额校验失败");
        }

        order.setTransactionId(transaction.getString("transaction_id"));
        order.setPaidTime(parseWechatTime(transaction.getString("success_time")));
        order.setRawNotify(rawNotify);
        int updated = paymentMapper.markPaymentOrderPaid(order);
        if (updated <= 0)
        {
            return;
        }

        applyPaidOrderBenefits(order);
    }

    private void syncPaidOrderFromWechat(AiPaymentOrder order)
    {
        JSONObject transaction = queryWechatOrder(order.getOutTradeNo());
        if (transaction == null || !"SUCCESS".equals(transaction.getString("trade_state")))
        {
            return;
        }
        applySuccessfulTransaction(order.getOutTradeNo(), transaction, transaction.toJSONString());
    }

    private void applyPaidOrderBenefits(AiPaymentOrder order)
    {
        Date creditExpireTime = null;
        String sourceType = SOURCE_PAYMENT_ADDON;
        String remark = order.getProductName() + "到账积分，长期有效";
        if (PRODUCT_TYPE_MEMBERSHIP.equals(order.getProductType()))
        {
            Date memberExpireTime = upsertMembership(order);
            creditExpireTime = memberExpireTime;
            sourceType = SOURCE_PAYMENT_MEMBERSHIP;
            remark = order.getProductName() + "赠送积分，会员有效期内可用";
        }
        creditService.grantPaymentCredits(order.getUserId(), sourceType, order.getOutTradeNo(), order.getCredits(),
                creditExpireTime, remark);
    }

    private Date upsertMembership(AiPaymentOrder order)
    {
        Product product = resolveProduct(order.getProductId());
        Date paidTime = order.getPaidTime() == null ? DateUtils.getNowDate() : order.getPaidTime();
        AiUserMembership current = paymentMapper.selectMembershipByUserId(order.getUserId());
        Date startTime = current != null && current.getExpireTime() != null && current.getExpireTime().after(paidTime)
                ? current.getExpireTime() : paidTime;
        Date expireTime = DateUtils.addDays(startTime, order.getMemberDays() == null ? 30 : order.getMemberDays().intValue());

        AiUserMembership membership = new AiUserMembership();
        membership.setUserId(order.getUserId());
        membership.setMemberTier(order.getMemberTier());
        membership.setAddonBonus(product.addonBonus);
        membership.setExpireTime(expireTime);
        if (current == null)
        {
            paymentMapper.insertMembership(membership);
        }
        else
        {
            paymentMapper.updateMembership(membership);
        }
        return expireTime;
    }

    private String requestWechatPrepay(AiPaymentOrder order, String openid)
    {
        JSONObject body = new JSONObject();
        body.put("appid", appid);
        body.put("mchid", mchId);
        body.put("description", order.getProductName());
        body.put("out_trade_no", order.getOutTradeNo());
        body.put("notify_url", notifyUrl);

        JSONObject amount = new JSONObject();
        amount.put("total", order.getAmountCent());
        amount.put("currency", "CNY");
        body.put("amount", amount);

        JSONObject payer = new JSONObject();
        payer.put("openid", openid);
        body.put("payer", payer);

        String bodyText = body.toJSONString();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(WECHAT_JSAPI_URL))
                .header("Accept", "application/json")
                .header("Content-Type", "application/json")
                .header("Authorization", buildWechatAuthorization("POST", "/v3/pay/transactions/jsapi", bodyText))
                .POST(HttpRequest.BodyPublishers.ofString(bodyText, StandardCharsets.UTF_8))
                .build();
        try
        {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            JSONObject responseJson = JSON.parseObject(response.body());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                String message = responseJson.getString("message");
                throw new ServiceException(StringUtils.defaultIfBlank(message, "微信支付下单失败"));
            }
            String prepayId = responseJson.getString("prepay_id");
            if (StringUtils.isBlank(prepayId))
            {
                throw new ServiceException("微信支付下单未返回 prepay_id");
            }
            return prepayId;
        }
        catch (IOException e)
        {
            throw new ServiceException("微信支付网络异常，请稍后重试");
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            throw new ServiceException("微信支付下单被中断，请稍后重试");
        }
    }

    private JSONObject queryWechatOrder(String outTradeNo)
    {
        ensureWechatPayConfig();
        String canonicalUrl = "/v3/pay/transactions/out-trade-no/" + outTradeNo + "?mchid=" + mchId;
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(WECHAT_ORDER_QUERY_URL + outTradeNo + "?mchid=" + mchId))
                .header("Accept", "application/json")
                .header("Authorization", buildWechatAuthorization("GET", canonicalUrl, ""))
                .GET()
                .build();
        try
        {
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() == 404)
            {
                return null;
            }
            JSONObject responseJson = JSON.parseObject(response.body());
            if (response.statusCode() < 200 || response.statusCode() >= 300)
            {
                String message = responseJson.getString("message");
                throw new ServiceException(StringUtils.defaultIfBlank(message, "微信支付查单失败"));
            }
            return responseJson;
        }
        catch (IOException e)
        {
            throw new ServiceException("微信支付查单网络异常，请稍后重试");
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            throw new ServiceException("微信支付查单被中断，请稍后重试");
        }
    }

    private Map<String, String> buildMiniProgramPaymentParams(String prepayId)
    {
        String timeStamp = String.valueOf(System.currentTimeMillis() / 1000);
        String nonceStr = IdUtils.fastUUID().replace("-", "");
        String packageValue = "prepay_id=" + prepayId;
        String paySign = sign(appid + "\n" + timeStamp + "\n" + nonceStr + "\n" + packageValue + "\n");

        Map<String, String> params = new LinkedHashMap<>();
        params.put("timeStamp", timeStamp);
        params.put("nonceStr", nonceStr);
        params.put("package", packageValue);
        params.put("signType", "RSA");
        params.put("paySign", paySign);
        return params;
    }

    private String buildWechatAuthorization(String method, String canonicalUrl, String body)
    {
        String timestamp = String.valueOf(System.currentTimeMillis() / 1000);
        String nonce = UUID.randomUUID().toString().replace("-", "");
        String message = method + "\n" + canonicalUrl + "\n" + timestamp + "\n" + nonce + "\n" + body + "\n";
        String signature = sign(message);
        return "WECHATPAY2-SHA256-RSA2048 "
                + "mchid=\"" + mchId + "\","
                + "nonce_str=\"" + nonce + "\","
                + "timestamp=\"" + timestamp + "\","
                + "serial_no=\"" + mchSerialNo + "\","
                + "signature=\"" + signature + "\"";
    }

    private String sign(String message)
    {
        try
        {
            Signature signer = Signature.getInstance("SHA256withRSA");
            signer.initSign(loadPrivateKey());
            signer.update(message.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(signer.sign());
        }
        catch (Exception e)
        {
            throw new ServiceException("微信支付签名失败，请检查商户私钥配置");
        }
    }

    private void verifyWechatNotifySignature(Map<String, String> headers, String body)
    {
        if (StringUtils.isBlank(platformCertificatePath))
        {
            throw new ServiceException("微信支付平台证书未配置");
        }
        String timestamp = getHeader(headers, "wechatpay-timestamp");
        String nonce = getHeader(headers, "wechatpay-nonce");
        String signatureText = getHeader(headers, "wechatpay-signature");
        if (StringUtils.isAnyBlank(timestamp, nonce, signatureText))
        {
            throw new ServiceException("微信支付回调签名头缺失");
        }

        try
        {
            Signature verifier = Signature.getInstance("SHA256withRSA");
            verifier.initVerify(loadWechatPayPublicKey());
            verifier.update((timestamp + "\n" + nonce + "\n" + body + "\n").getBytes(StandardCharsets.UTF_8));
            boolean valid = verifier.verify(Base64.getDecoder().decode(signatureText));
            if (!valid)
            {
                throw new ServiceException("微信支付回调签名校验失败");
            }
        }
        catch (ServiceException e)
        {
            throw e;
        }
        catch (Exception e)
        {
            throw new ServiceException("微信支付回调签名校验异常");
        }
    }

    private String decryptResource(JSONObject resource)
    {
        try
        {
            String associatedData = resource.getString("associated_data");
            String nonce = resource.getString("nonce");
            String ciphertext = resource.getString("ciphertext");
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec key = new SecretKeySpec(apiV3Key.getBytes(StandardCharsets.UTF_8), "AES");
            GCMParameterSpec spec = new GCMParameterSpec(128, nonce.getBytes(StandardCharsets.UTF_8));
            cipher.init(Cipher.DECRYPT_MODE, key, spec);
            if (StringUtils.isNotBlank(associatedData))
            {
                cipher.updateAAD(associatedData.getBytes(StandardCharsets.UTF_8));
            }
            return new String(cipher.doFinal(Base64.getDecoder().decode(ciphertext)), StandardCharsets.UTF_8);
        }
        catch (Exception e)
        {
            throw new ServiceException("微信支付回调解密失败");
        }
    }

    private PrivateKey loadPrivateKey() throws Exception
    {
        if (cachedPrivateKey != null)
        {
            return cachedPrivateKey;
        }
        String pem = StringUtils.isNotBlank(privateKeyText)
                ? privateKeyText
                : Files.readString(Paths.get(privateKeyPath), StandardCharsets.UTF_8);
        pem = pem.replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----END PRIVATE KEY-----", "")
                .replaceAll("\\s", "");
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(pem));
        cachedPrivateKey = KeyFactory.getInstance("RSA").generatePrivate(keySpec);
        return cachedPrivateKey;
    }

    private PublicKey loadWechatPayPublicKey() throws Exception
    {
        if (cachedWechatPayPublicKey != null)
        {
            return cachedWechatPayPublicKey;
        }
        String pem = Files.readString(Paths.get(platformCertificatePath), StandardCharsets.UTF_8);
        if (pem.contains("BEGIN PUBLIC KEY"))
        {
            pem = pem.replace("-----BEGIN PUBLIC KEY-----", "")
                    .replace("-----END PUBLIC KEY-----", "")
                    .replaceAll("\\s", "");
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(Base64.getDecoder().decode(pem));
            cachedWechatPayPublicKey = KeyFactory.getInstance("RSA").generatePublic(keySpec);
            return cachedWechatPayPublicKey;
        }

        try (java.io.InputStream inputStream = Files.newInputStream(Paths.get(platformCertificatePath)))
        {
            CertificateFactory factory = CertificateFactory.getInstance("X.509");
            X509Certificate certificate = (X509Certificate) factory.generateCertificate(inputStream);
            cachedWechatPayPublicKey = certificate.getPublicKey();
            return cachedWechatPayPublicKey;
        }
    }

    private void ensureWechatPayConfig()
    {
        if (!payEnabled)
        {
            throw new ServiceException("微信支付未启用");
        }
        if (StringUtils.isAnyBlank(appid, mchId, mchSerialNo, apiV3Key, notifyUrl)
                || (StringUtils.isBlank(privateKeyPath) && StringUtils.isBlank(privateKeyText)))
        {
            throw new ServiceException("微信支付参数未配置完整");
        }
    }

    private Product resolveProduct(String productId)
    {
        Product product = PRODUCTS.get(productId);
        if (product == null)
        {
            throw new ServiceException("商品不存在");
        }
        return product;
    }

    private int resolvePayAmountCent(Product product)
    {
        return debugAmountCent > 0 ? debugAmountCent : product.amountCent;
    }

    private String buildOutTradeNo()
    {
        return "AI" + DateUtils.dateTimeNow("yyyyMMddHHmmss") + IdUtils.fastUUID().replace("-", "").substring(0, 8);
    }

    private Date parseWechatTime(String value)
    {
        if (StringUtils.isBlank(value))
        {
            return DateUtils.getNowDate();
        }
        try
        {
            return Date.from(OffsetDateTime.parse(value, DateTimeFormatter.ISO_OFFSET_DATE_TIME).toInstant());
        }
        catch (Exception e)
        {
            return DateUtils.getNowDate();
        }
    }

    private String getHeader(Map<String, String> headers, String name)
    {
        return headers.get(name.toLowerCase());
    }

    private static Map<String, Product> buildProducts()
    {
        Map<String, Product> map = new HashMap<>();
        put(map, new Product("monthly", PRODUCT_TYPE_MEMBERSHIP, "月卡会员", 2990, 660, "monthly", 10, 30));
        put(map, new Product("pro", PRODUCT_TYPE_MEMBERSHIP, "Pro 会员", 5990, 1500, "pro", 20, 30));
        put(map, new Product("studio", PRODUCT_TYPE_MEMBERSHIP, "Studio 会员", 9900, 2800, "studio", 30, 30));
        put(map, new Product("addon-2990", PRODUCT_TYPE_ADDON, "轻量补充积分包", 2990, 660, null, 0, null));
        put(map, new Product("addon-5990", PRODUCT_TYPE_ADDON, "日常加量积分包", 5990, 1500, null, 0, null));
        put(map, new Product("addon-9900", PRODUCT_TYPE_ADDON, "高频备用积分包", 9900, 2800, null, 0, null));
        put(map, new Product("addon-19900", PRODUCT_TYPE_ADDON, "团队加量积分包", 19900, 6200, null, 0, null));
        return map;
    }

    private static void put(Map<String, Product> map, Product product)
    {
        map.put(product.id, product);
    }

    private static class Product
    {
        private final String id;
        private final String type;
        private final String name;
        private final int amountCent;
        private final int credits;
        private final String memberTier;
        private final int addonBonus;
        private final Integer memberDays;

        private Product(String id, String type, String name, int amountCent, int credits, String memberTier, int addonBonus, Integer memberDays)
        {
            this.id = id;
            this.type = type;
            this.name = name;
            this.amountCent = amountCent;
            this.credits = credits;
            this.memberTier = memberTier;
            this.addonBonus = addonBonus;
            this.memberDays = memberDays;
        }
    }
}
