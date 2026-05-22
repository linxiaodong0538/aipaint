package com.ruoyi.web.service.image;

import java.util.Arrays;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.AiImageProviderCallLogMapper;
import com.ruoyi.system.mapper.SysConfigMapper;
import com.ruoyi.system.service.ISysConfigService;

/**
 * AI 生图配置服务
 */
@Service
public class AiImageConfigService
{
    public static final String SLOT_PRIMARY = "primary";

    public static final String SLOT_BACKUP = "backup";

    public static final String TYPE_OPENAI_COMPATIBLE = "openai-compatible";

    public static final String STRATEGY_MANUAL = "manual";

    public static final String STRATEGY_FALLBACK = "fallback";

    public static final String STRATEGY_CIRCUIT_BREAKER = "circuit-breaker";

    private static final String DEFAULT_BACKUP_BASE_URL = "https://dm-fox.rjj.cc/codex/v1";

    private static final String DEFAULT_MODEL = "gpt-image-2";

    private static final String KEY_ACTIVE_PROVIDER = "ai.image.activeProvider";

    private static final String KEY_FALLBACK_ENABLED = "ai.image.fallbackEnabled";

    private static final String KEY_FALLBACK_STRATEGY = "ai.image.fallbackStrategy";

    private static final String KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD = "ai.image.circuitBreaker.failureThreshold";

    private static final String KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES = "ai.image.circuitBreaker.cooldownMinutes";

    private static final String KEY_FORCE_SIZE_ENABLED = "ai.image.forceSizeEnabled";

    private static final String KEY_FORCE_SIZE = "ai.image.forceSize";

    @Autowired
    private ISysConfigService sysConfigService;

    @Autowired
    private SysConfigMapper sysConfigMapper;

    @Autowired
    private AiImageProviderCallLogMapper callLogMapper;

    public AiImageAdminConfig getAdminConfig()
    {
        AiImageAdminConfig config = new AiImageAdminConfig();
        config.setActiveProvider(normalizeProviderCode(readString(KEY_ACTIVE_PROVIDER, SLOT_BACKUP)));
        config.setFallbackEnabled(Boolean.valueOf(readBoolean(KEY_FALLBACK_ENABLED, true)));
        config.setFallbackStrategy(readFallbackStrategy(config.getFallbackEnabled()));
        config.setCircuitBreakerFailureThreshold(readInt(KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD, 3, 1, 20));
        config.setCircuitBreakerCooldownMinutes(readInt(KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES, 10, 1, 1440));
        config.setForceSizeEnabled(Boolean.valueOf(readBoolean(KEY_FORCE_SIZE_ENABLED, false)));
        config.setForceSize(readString(KEY_FORCE_SIZE, "1024x1024"));
        config.setPrimaryProvider(buildProviderConfig(SLOT_PRIMARY, "主通道"));
        config.setBackupProvider(buildProviderConfig(SLOT_BACKUP, "备用通道"));
        config.setHealthStats(Arrays.asList(
                callLogMapper.selectProviderHealthStats(SLOT_PRIMARY, 50),
                callLogMapper.selectProviderHealthStats(SLOT_BACKUP, 50)));
        return config;
    }

    public AiImageProviderConfig resolveActiveProvider()
    {
        return resolveProviderByCode(getAdminConfig().getActiveProvider());
    }

    public AiImageProviderConfig resolveProviderByCode(String providerCode)
    {
        String normalizedCode = normalizeProviderCode(providerCode);
        AiImageProviderConfig config = SLOT_BACKUP.equals(normalizedCode)
                ? buildProviderConfig(SLOT_BACKUP, "备用通道")
                : buildProviderConfig(SLOT_PRIMARY, "主通道");
        validateRuntimeConfig(config);
        return config;
    }

    public String resolveImageSize(String ratio)
    {
        AiImageAdminConfig config = getAdminConfig();
        if (Boolean.TRUE.equals(config.getForceSizeEnabled()) && isValidImageSize(config.getForceSize()))
        {
            return config.getForceSize();
        }
        if ("3:4".equals(ratio))
        {
            return "1024x1536";
        }
        if ("4:3".equals(ratio) || "16:9".equals(ratio))
        {
            return "1536x1024";
        }
        return "1024x1024";
    }

    public void saveAdminConfig(AiImageAdminConfig config, String operator)
    {
        AiImageAdminConfig normalized = normalizeForSave(config);

        upsert(KEY_ACTIVE_PROVIDER, "AI生图-当前生效通道", normalized.getActiveProvider(), "primary=主通道，backup=备用通道", operator);
        upsert(KEY_FALLBACK_ENABLED, "AI生图-失败自动切备用", String.valueOf(Boolean.TRUE.equals(normalized.getFallbackEnabled())), "true 开启主通道失败自动尝试备用通道，false 关闭", operator);
        upsert(KEY_FALLBACK_STRATEGY, "AI生图-切换策略", normalized.getFallbackStrategy(), "manual=仅手动切换，fallback=失败自动切备用，circuit-breaker=连续失败熔断主通道", operator);
        upsert(KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD, "AI生图-熔断失败阈值", String.valueOf(normalized.getCircuitBreakerFailureThreshold()), "连续失败达到该次数后临时熔断主通道", operator);
        upsert(KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES, "AI生图-熔断冷却分钟", String.valueOf(normalized.getCircuitBreakerCooldownMinutes()), "只统计冷却窗口内的连续失败", operator);
        upsert(KEY_FORCE_SIZE_ENABLED, "AI生图-强制尺寸开关", String.valueOf(Boolean.TRUE.equals(normalized.getForceSizeEnabled())), "true 开启固定尺寸，false 按比例自动推导", operator);
        upsert(KEY_FORCE_SIZE, "AI生图-强制尺寸", blankToEmpty(normalized.getForceSize()), "可选值：1024x1024、1536x1024、1024x1536", operator);

        saveProvider(normalized.getPrimaryProvider(), operator);
        saveProvider(normalized.getBackupProvider(), operator);

        sysConfigService.resetConfigCache();
    }

    private AiImageAdminConfig normalizeForSave(AiImageAdminConfig input)
    {
        AiImageAdminConfig config = input == null ? new AiImageAdminConfig() : input;
        config.setActiveProvider(normalizeProviderCode(config.getActiveProvider()));
        config.setFallbackStrategy(normalizeFallbackStrategy(config.getFallbackStrategy(), config.getFallbackEnabled()));
        config.setFallbackEnabled(Boolean.valueOf(!STRATEGY_MANUAL.equals(config.getFallbackStrategy())));
        config.setCircuitBreakerFailureThreshold(normalizeInt(config.getCircuitBreakerFailureThreshold(), 3, 1, 20));
        config.setCircuitBreakerCooldownMinutes(normalizeInt(config.getCircuitBreakerCooldownMinutes(), 10, 1, 1440));
        config.setForceSizeEnabled(Boolean.valueOf(Boolean.TRUE.equals(config.getForceSizeEnabled())));
        config.setForceSize(blankToEmpty(config.getForceSize()));

        if (Boolean.TRUE.equals(config.getForceSizeEnabled()) && !isValidImageSize(config.getForceSize()))
        {
            throw new ServiceException("强制尺寸仅支持 1024x1024、1536x1024、1024x1536");
        }

        config.setPrimaryProvider(normalizeProvider(config.getPrimaryProvider(), SLOT_PRIMARY, "主通道"));
        config.setBackupProvider(normalizeProvider(config.getBackupProvider(), SLOT_BACKUP, "备用通道"));
        return config;
    }

    private AiImageProviderConfig normalizeProvider(AiImageProviderConfig provider, String providerCode, String defaultName)
    {
        AiImageProviderConfig normalized = provider == null ? new AiImageProviderConfig() : provider;
        normalized.setProviderCode(providerCode);
        normalized.setProviderName(StringUtils.defaultIfBlank(normalized.getProviderName(), defaultName));
        normalized.setEnabled(Boolean.valueOf(Boolean.TRUE.equals(normalized.getEnabled())));
        normalized.setProviderType(StringUtils.defaultIfBlank(normalized.getProviderType(), TYPE_OPENAI_COMPATIBLE));
        normalized.setBaseUrl(blankToEmpty(normalized.getBaseUrl()));
        normalized.setApiKey(blankToEmpty(normalized.getApiKey()));
        normalized.setModel(StringUtils.defaultIfBlank(normalized.getModel(), DEFAULT_MODEL));

        if (!TYPE_OPENAI_COMPATIBLE.equals(normalized.getProviderType()))
        {
            throw new ServiceException("当前仅支持 openai-compatible 类型的图片通道");
        }
        return normalized;
    }

    private void validateRuntimeConfig(AiImageProviderConfig config)
    {
        if (!Boolean.TRUE.equals(config.getEnabled()))
        {
            throw new ServiceException("当前生图通道未启用，请先在后台开启");
        }
        if (!TYPE_OPENAI_COMPATIBLE.equals(config.getProviderType()))
        {
            throw new ServiceException("当前生图通道类型暂不支持：" + config.getProviderType());
        }
        if (StringUtils.isBlank(config.getBaseUrl()))
        {
            throw new ServiceException("当前生图通道未配置 Base URL");
        }
        if (StringUtils.isBlank(config.getApiKey()))
        {
            throw new ServiceException("当前生图通道未配置 API Key");
        }
        if (StringUtils.isBlank(config.getModel()))
        {
            throw new ServiceException("当前生图通道未配置模型");
        }
    }

    private void saveProvider(AiImageProviderConfig provider, String operator)
    {
        String prefix = "ai.image." + provider.getProviderCode();
        upsert(prefix + ".name", "AI生图-" + provider.getProviderName() + "-名称", provider.getProviderName(), "通道展示名称", operator);
        upsert(prefix + ".enabled", "AI生图-" + provider.getProviderName() + "-启用", String.valueOf(Boolean.TRUE.equals(provider.getEnabled())), "true 启用，false 停用", operator);
        upsert(prefix + ".type", "AI生图-" + provider.getProviderName() + "-类型", provider.getProviderType(), "当前支持 openai-compatible", operator);
        upsert(prefix + ".baseUrl", "AI生图-" + provider.getProviderName() + "-BaseURL", provider.getBaseUrl(), "图片生成接口基础地址", operator);
        upsert(prefix + ".apiKey", "AI生图-" + provider.getProviderName() + "-APIKey", provider.getApiKey(), "图片生成接口密钥", operator);
        upsert(prefix + ".model", "AI生图-" + provider.getProviderName() + "-模型", provider.getModel(), "例如 gpt-image-2", operator);
    }

    private void upsert(String configKey, String configName, String configValue, String remark, String operator)
    {
        SysConfig existing = sysConfigMapper.checkConfigKeyUnique(configKey);
        if (existing == null)
        {
            SysConfig config = new SysConfig();
            config.setConfigName(configName);
            config.setConfigKey(configKey);
            config.setConfigValue(blankToEmpty(configValue));
            config.setConfigType("Y");
            config.setRemark(remark);
            config.setCreateBy(operator);
            sysConfigMapper.insertConfig(config);
            return;
        }

        existing.setConfigName(configName);
        existing.setConfigValue(blankToEmpty(configValue));
        existing.setConfigType("Y");
        existing.setRemark(remark);
        existing.setUpdateBy(operator);
        sysConfigMapper.updateConfig(existing);
    }

    private AiImageProviderConfig buildProviderConfig(String providerCode, String defaultName)
    {
        String prefix = "ai.image." + providerCode;
        AiImageProviderConfig config = new AiImageProviderConfig();
        config.setProviderCode(providerCode);
        config.setProviderName(readString(prefix + ".name", defaultName));
        config.setEnabled(Boolean.valueOf(readBoolean(prefix + ".enabled", SLOT_BACKUP.equals(providerCode))));
        config.setProviderType(readString(prefix + ".type", TYPE_OPENAI_COMPATIBLE));
        config.setBaseUrl(readString(prefix + ".baseUrl", defaultBaseUrl(providerCode)));
        config.setApiKey(readString(prefix + ".apiKey", ""));
        config.setModel(readString(prefix + ".model", DEFAULT_MODEL));
        return config;
    }

    private String normalizeProviderCode(String providerCode)
    {
        return SLOT_BACKUP.equalsIgnoreCase(providerCode) ? SLOT_BACKUP : SLOT_PRIMARY;
    }

    private String readString(String key, String defaultValue)
    {
        String value = sysConfigService.selectConfigByKey(key);
        return StringUtils.isBlank(value) ? defaultValue : value.trim();
    }

    private boolean readBoolean(String key, boolean defaultValue)
    {
        String value = sysConfigService.selectConfigByKey(key);
        if (StringUtils.isBlank(value))
        {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }

    private int readInt(String key, int defaultValue, int min, int max)
    {
        String value = sysConfigService.selectConfigByKey(key);
        if (StringUtils.isBlank(value))
        {
            return defaultValue;
        }
        try
        {
            return normalizeInt(Integer.valueOf(value.trim()), defaultValue, min, max);
        }
        catch (NumberFormatException e)
        {
            return defaultValue;
        }
    }

    private int normalizeInt(Integer value, int defaultValue, int min, int max)
    {
        if (value == null)
        {
            return defaultValue;
        }
        return Math.max(min, Math.min(max, value.intValue()));
    }

    private String readFallbackStrategy(Boolean fallbackEnabled)
    {
        return normalizeFallbackStrategy(readString(KEY_FALLBACK_STRATEGY, ""), fallbackEnabled);
    }

    private String normalizeFallbackStrategy(String strategy, Boolean fallbackEnabled)
    {
        if (STRATEGY_MANUAL.equals(strategy) || STRATEGY_FALLBACK.equals(strategy) || STRATEGY_CIRCUIT_BREAKER.equals(strategy))
        {
            return strategy;
        }
        return Boolean.FALSE.equals(fallbackEnabled) ? STRATEGY_MANUAL : STRATEGY_FALLBACK;
    }

    private boolean isValidImageSize(String size)
    {
        return "1024x1024".equals(size) || "1536x1024".equals(size) || "1024x1536".equals(size);
    }

    private String defaultBaseUrl(String providerCode)
    {
        return SLOT_BACKUP.equals(providerCode) ? DEFAULT_BACKUP_BASE_URL : "";
    }

    private String blankToEmpty(String value)
    {
        return value == null ? "" : value.trim();
    }
}
