package com.ruoyi.web.service.image;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiImageModelRouteRecord;
import com.ruoyi.system.domain.AiImageProviderHealthStats;
import com.ruoyi.system.domain.AiImageProviderModelRecord;
import com.ruoyi.system.domain.AiImageProviderRecord;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.mapper.AiImageProviderCallLogMapper;
import com.ruoyi.system.mapper.AiImageRoutingConfigMapper;
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

    public static final String ADAPTER_OPENAI_COMPATIBLE = "openai-compatible";

    public static final String ADAPTER_GRSAI_ASYNC = "grsai-async";

    public static final String RESPONSE_MODE_JSON = "json";

    public static final String RESPONSE_MODE_STREAM = "stream";

    public static final String STRATEGY_FALLBACK = "fallback";

    private static final String DEFAULT_MODEL = "gpt-image-2";

    private static final String MODEL_NANO_BANANA = "nano-banana-2";

    private static final String MODEL_GPT_IMAGE_2_VIP = "gpt-image-2-vip";

    private static final String MODEL_NANO_BANANA_PRO = "nano-banana-pro";

    private static final String MODEL_NANO_BANANA_FAST = "nano-banana";

    private static final String PROVIDER_SUPERAPI = "superapi";

    private static final String PROVIDER_GRSAI = "grsai";

    private static final String KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD = "ai.image.circuitBreaker.failureThreshold";

    private static final String KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES = "ai.image.circuitBreaker.cooldownMinutes";

    private static final String KEY_OUTPUT_FORMAT = "ai.image.outputFormat";

    private static final String KEY_OUTPUT_COMPRESSION = "ai.image.outputCompression";

    @Autowired
    private ISysConfigService sysConfigService;

    @Autowired
    private SysConfigMapper sysConfigMapper;

    @Autowired
    private AiImageProviderCallLogMapper callLogMapper;

    @Autowired
    private AiImageRoutingConfigMapper routingConfigMapper;

    public AiImageAdminConfig getAdminConfig()
    {
        List<AiImageProviderConfig> providers = loadProviderConfigs();
        List<AiImageModelRouteConfig> modelRoutes = loadModelRoutes();

        AiImageAdminConfig config = new AiImageAdminConfig();
        config.setActiveProvider(resolveCompatActiveProvider(modelRoutes));
        config.setFallbackEnabled(Boolean.TRUE);
        config.setFallbackStrategy(STRATEGY_FALLBACK);
        config.setCircuitBreakerFailureThreshold(readInt(KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD, 3, 1, 20));
        config.setCircuitBreakerCooldownMinutes(readInt(KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES, 10, 1, 1440));
        config.setOutputFormat(readOutputFormat());
        config.setOutputCompression(Integer.valueOf(readInt(KEY_OUTPUT_COMPRESSION, 90, 0, 100)));
        config.setProviders(providers);
        config.setModelRoutes(modelRoutes);
        config.setPrimaryProvider(findProvider(providers, config.getActiveProvider()));
        config.setBackupProvider(resolveCompatBackupProvider(providers, modelRoutes));
        config.setHealthStats(buildHealthStats(providers));
        return config;
    }

    public AiImageProviderConfig resolveActiveProvider()
    {
        AiImageModelRouteConfig route = resolveModelRoute(DEFAULT_MODEL);
        return resolveProviderByCode(route.getPrimaryProviderCode(), route.getModel());
    }

    public AiImageProviderConfig resolveProviderByCode(String providerCode)
    {
        return resolveProviderByCode(providerCode, null);
    }

    public AiImageProviderConfig resolveProviderByCode(String providerCode, String model)
    {
        AiImageProviderConfig config = findProvider(loadProviderConfigs(), normalizeProviderCode(providerCode));
        if (config == null)
        {
            throw new ServiceException("未找到生图通道：" + providerCode);
        }
        validateRuntimeConfig(config);
        if (StringUtils.isNotBlank(model) && !supportsModel(config, model))
        {
            throw new ServiceException("生图通道 " + config.getProviderCode() + " 不支持模型：" + model);
        }
        return config;
    }

    public AiImageModelRouteConfig resolveModelRoute(String model)
    {
        String normalizedModel = normalizeModel(model);
        for (AiImageModelRouteConfig route : loadModelRoutes())
        {
            if (normalizedModel.equals(route.getModel()))
            {
                if (!Boolean.TRUE.equals(route.getEnabled()))
                {
                    throw new ServiceException("模型路由未启用：" + normalizedModel);
                }
                if (StringUtils.isBlank(route.getPrimaryProviderCode()))
                {
                    throw new ServiceException("模型路由未配置主通道：" + normalizedModel);
                }
                return route;
            }
        }
        throw new ServiceException("模型未配置生图路由：" + normalizedModel);
    }

    @Transactional
    public void saveAdminConfig(AiImageAdminConfig config, String operator)
    {
        AiImageAdminConfig normalized = normalizeForSave(config);

        upsert(KEY_CIRCUIT_BREAKER_FAILURE_THRESHOLD, "AI生图-熔断失败阈值", String.valueOf(normalized.getCircuitBreakerFailureThreshold()), "连续失败达到该次数后临时熔断主通道", operator);
        upsert(KEY_CIRCUIT_BREAKER_COOLDOWN_MINUTES, "AI生图-熔断冷却分钟", String.valueOf(normalized.getCircuitBreakerCooldownMinutes()), "只统计冷却窗口内的连续失败", operator);
        upsert(KEY_OUTPUT_FORMAT, "AI生图-输出格式", normalized.getOutputFormat(), "支持 jpeg、png", operator);
        upsert(KEY_OUTPUT_COMPRESSION, "AI生图-JPEG压缩强度", String.valueOf(normalized.getOutputCompression()), "范围 0-100，仅对 jpeg 有效", operator);

        routingConfigMapper.deleteModelRoutes();
        routingConfigMapper.deleteProviderModels();
        routingConfigMapper.deleteProviders();

        for (AiImageProviderConfig provider : normalized.getProviders())
        {
            routingConfigMapper.insertProvider(toProviderRecord(provider));
            for (String model : provider.getSupportedModels())
            {
                routingConfigMapper.insertProviderModel(toProviderModelRecord(provider.getProviderCode(), model));
            }
        }
        for (AiImageModelRouteConfig route : normalized.getModelRoutes())
        {
            routingConfigMapper.insertModelRoute(toModelRouteRecord(route));
        }

        sysConfigService.resetConfigCache();
    }

    private AiImageAdminConfig normalizeForSave(AiImageAdminConfig input)
    {
        AiImageAdminConfig config = input == null ? new AiImageAdminConfig() : input;
        config.setCircuitBreakerFailureThreshold(normalizeInt(config.getCircuitBreakerFailureThreshold(), 3, 1, 20));
        config.setCircuitBreakerCooldownMinutes(normalizeInt(config.getCircuitBreakerCooldownMinutes(), 10, 1, 1440));
        config.setOutputFormat(normalizeOutputFormat(config.getOutputFormat()));
        config.setOutputCompression(Integer.valueOf(normalizeInt(config.getOutputCompression(), 90, 0, 100)));

        List<AiImageProviderConfig> providers = normalizeProviders(config.getProviders());
        List<AiImageModelRouteConfig> routes = normalizeRoutes(config.getModelRoutes(), providers);
        config.setProviders(providers);
        config.setModelRoutes(routes);
        return config;
    }

    private List<AiImageProviderConfig> normalizeProviders(List<AiImageProviderConfig> input)
    {
        List<AiImageProviderConfig> source = input == null || input.isEmpty() ? buildDefaultProviders() : input;
        List<AiImageProviderConfig> providers = new ArrayList<>();
        Set<String> providerCodes = new LinkedHashSet<>();
        int index = 0;
        for (AiImageProviderConfig provider : source)
        {
            AiImageProviderConfig normalized = normalizeProvider(provider, index++);
            if (!providerCodes.add(normalized.getProviderCode()))
            {
                throw new ServiceException("通道编码重复：" + normalized.getProviderCode());
            }
            providers.add(normalized);
        }
        return providers;
    }

    private AiImageProviderConfig normalizeProvider(AiImageProviderConfig provider, int index)
    {
        AiImageProviderConfig normalized = provider == null ? new AiImageProviderConfig() : provider;
        normalized.setProviderCode(normalizeProviderCode(normalized.getProviderCode()));
        if (StringUtils.isBlank(normalized.getProviderCode()))
        {
            throw new ServiceException("通道编码不能为空");
        }
        if (!normalized.getProviderCode().matches("[a-zA-Z0-9][a-zA-Z0-9_-]{0,31}"))
        {
            throw new ServiceException("通道编码只能使用 1-32 位字母、数字、下划线或中划线");
        }
        normalized.setProviderName(StringUtils.defaultIfBlank(normalized.getProviderName(), normalized.getProviderCode()));
        normalized.setEnabled(Boolean.valueOf(Boolean.TRUE.equals(normalized.getEnabled())));
        normalized.setAdapterType(normalizeAdapterType(normalized.getAdapterType()));
        normalized.setResponseMode(normalizeResponseMode(normalized.getResponseMode(), normalized));
        normalized.setSupportsBatch(Boolean.valueOf(!Boolean.FALSE.equals(normalized.getSupportsBatch())));
        normalized.setBaseUrl(blankToEmpty(normalized.getBaseUrl()));
        normalized.setApiKey(blankToEmpty(normalized.getApiKey()));
        if (!isSupportedAdapterType(normalized.getAdapterType()))
        {
            throw new ServiceException("当前仅支持 openai-compatible、grsai-async 接口协议");
        }
        normalized.setSupportedModels(normalizeSupportedModels(normalized));
        normalized.setModel(normalized.getSupportedModels().get(0));
        normalized.setSortOrder(Integer.valueOf(normalizeInt(normalized.getSortOrder(), index + 1, 0, 9999)));
        normalized.setRemark(blankToEmpty(normalized.getRemark()));
        return normalized;
    }

    private List<String> normalizeSupportedModels(AiImageProviderConfig provider)
    {
        LinkedHashSet<String> models = new LinkedHashSet<>();
        if (provider.getSupportedModels() != null)
        {
            for (String model : provider.getSupportedModels())
            {
                if (StringUtils.isNotBlank(model))
                {
                    models.add(normalizeModel(model));
                }
            }
        }
        if (models.isEmpty() && StringUtils.isNotBlank(provider.getModel()))
        {
            models.add(normalizeModel(provider.getModel()));
        }
        if (models.isEmpty())
        {
            if (ADAPTER_GRSAI_ASYNC.equals(provider.getAdapterType()))
            {
                addDefaultGrsaiModels(models);
            }
            else
            {
                models.add(DEFAULT_MODEL);
            }
        }
        return new ArrayList<>(models);
    }

    private List<AiImageModelRouteConfig> normalizeRoutes(List<AiImageModelRouteConfig> input, List<AiImageProviderConfig> providers)
    {
        List<AiImageModelRouteConfig> source = input == null || input.isEmpty() ? buildDefaultRoutes() : input;
        Map<String, AiImageProviderConfig> providerMap = providers.stream()
                .collect(Collectors.toMap(AiImageProviderConfig::getProviderCode, provider -> provider, (left, right) -> left, LinkedHashMap::new));
        List<AiImageModelRouteConfig> routes = new ArrayList<>();
        Set<String> models = new LinkedHashSet<>();
        int index = 0;
        for (AiImageModelRouteConfig route : source)
        {
            AiImageModelRouteConfig normalized = normalizeRoute(route, providerMap, index++);
            if (!models.add(normalized.getModel()))
            {
                throw new ServiceException("模型路由重复：" + normalized.getModel());
            }
            routes.add(normalized);
        }
        return routes;
    }

    private AiImageModelRouteConfig normalizeRoute(AiImageModelRouteConfig route, Map<String, AiImageProviderConfig> providerMap, int index)
    {
        AiImageModelRouteConfig normalized = route == null ? new AiImageModelRouteConfig() : route;
        normalized.setModel(normalizeModel(normalized.getModel()));
        normalized.setEnabled(Boolean.valueOf(Boolean.TRUE.equals(normalized.getEnabled())));
        normalized.setPrimaryProviderCode(normalizeProviderCode(normalized.getPrimaryProviderCode()));
        normalized.setBackupProviderCode(blankToNull(normalizeProviderCode(normalized.getBackupProviderCode())));
        normalized.setFallbackEnabled(Boolean.valueOf(Boolean.TRUE.equals(normalized.getFallbackEnabled()) && StringUtils.isNotBlank(normalized.getBackupProviderCode())));
        normalized.setSortOrder(Integer.valueOf(normalizeInt(normalized.getSortOrder(), index + 1, 0, 9999)));
        normalized.setRemark(blankToEmpty(normalized.getRemark()));

        AiImageProviderConfig primaryProvider = providerMap.get(normalized.getPrimaryProviderCode());
        if (primaryProvider == null)
        {
            throw new ServiceException("模型 " + normalized.getModel() + " 的主通道不存在：" + normalized.getPrimaryProviderCode());
        }
        if (!supportsModel(primaryProvider, normalized.getModel()))
        {
            throw new ServiceException("主通道 " + primaryProvider.getProviderCode() + " 不支持模型：" + normalized.getModel());
        }
        if (StringUtils.isNotBlank(normalized.getBackupProviderCode()))
        {
            if (normalized.getBackupProviderCode().equals(normalized.getPrimaryProviderCode()))
            {
                throw new ServiceException("模型 " + normalized.getModel() + " 的主通道和备用通道不能相同");
            }
            AiImageProviderConfig backupProvider = providerMap.get(normalized.getBackupProviderCode());
            if (backupProvider == null)
            {
                throw new ServiceException("模型 " + normalized.getModel() + " 的备用通道不存在：" + normalized.getBackupProviderCode());
            }
            if (!supportsModel(backupProvider, normalized.getModel()))
            {
                throw new ServiceException("备用通道 " + backupProvider.getProviderCode() + " 不支持模型：" + normalized.getModel());
            }
        }
        return normalized;
    }

    private void validateRuntimeConfig(AiImageProviderConfig config)
    {
        if (!Boolean.TRUE.equals(config.getEnabled()))
        {
            throw new ServiceException("当前生图通道未启用，请先在后台开启");
        }
        if (!isSupportedAdapterType(config.getAdapterType()))
        {
            throw new ServiceException("当前生图接口协议暂不支持：" + config.getAdapterType());
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

    private List<AiImageProviderConfig> loadProviderConfigs()
    {
        List<AiImageProviderRecord> providerRecords = routingConfigMapper.selectProviders();
        if (providerRecords == null || providerRecords.isEmpty())
        {
            return buildDefaultProviders();
        }

        Map<String, List<String>> modelMap = new LinkedHashMap<>();
        List<AiImageProviderModelRecord> providerModels = routingConfigMapper.selectProviderModels();
        if (providerModels != null)
        {
            for (AiImageProviderModelRecord providerModel : providerModels)
            {
                if (Boolean.TRUE.equals(providerModel.getEnabled()) && StringUtils.isNotBlank(providerModel.getModel()))
                {
                    modelMap.computeIfAbsent(providerModel.getProviderCode(), key -> new ArrayList<>())
                            .add(providerModel.getModel());
                }
            }
        }

        List<AiImageProviderConfig> providers = new ArrayList<>();
        for (AiImageProviderRecord record : providerRecords)
        {
            AiImageProviderConfig config = fromProviderRecord(record, modelMap.get(record.getProviderCode()));
            providers.add(config);
        }
        return providers;
    }

    private List<AiImageModelRouteConfig> loadModelRoutes()
    {
        List<AiImageModelRouteRecord> records = routingConfigMapper.selectModelRoutes();
        if (records == null || records.isEmpty())
        {
            return buildDefaultRoutes();
        }
        List<AiImageModelRouteConfig> routes = new ArrayList<>();
        for (AiImageModelRouteRecord record : records)
        {
            routes.add(fromModelRouteRecord(record));
        }
        return routes;
    }

    private List<AiImageProviderConfig> buildDefaultProviders()
    {
        List<AiImageProviderConfig> providers = new ArrayList<>();
        AiImageProviderConfig superapi = buildCompatProviderConfig(SLOT_PRIMARY, PROVIDER_SUPERAPI, "SuperAPI 中转站", ADAPTER_OPENAI_COMPATIBLE);
        superapi.setSupportedModels(Collections.singletonList(DEFAULT_MODEL));
        superapi.setModel(DEFAULT_MODEL);
        superapi.setSupportsBatch(Boolean.TRUE);
        superapi.setSortOrder(Integer.valueOf(1));
        superapi.setRemark("默认 GPT 主通道");
        superapi.setResponseMode(RESPONSE_MODE_STREAM);
        providers.add(superapi);

        AiImageProviderConfig grsai = new AiImageProviderConfig();
        grsai.setProviderCode(PROVIDER_GRSAI);
        grsai.setProviderName("Grsai 中转站");
        grsai.setAdapterType(ADAPTER_GRSAI_ASYNC);
        grsai.setResponseMode(RESPONSE_MODE_JSON);
        grsai.setSupportsBatch(Boolean.TRUE);
        grsai.setBaseUrl("");
        grsai.setApiKey("");
        grsai.setEnabled(Boolean.FALSE);
        List<String> grsaiModels = new ArrayList<>();
        addDefaultGrsaiModels(grsaiModels);
        grsai.setSupportedModels(grsaiModels);
        grsai.setModel(DEFAULT_MODEL);
        grsai.setSortOrder(Integer.valueOf(2));
        grsai.setRemark("支持 GPT 与 nano-banana 的中转站");
        providers.add(grsai);
        return providers;
    }

    private AiImageProviderConfig buildCompatProviderConfig(String legacySlot, String providerCode, String defaultName, String defaultAdapterType)
    {
        String prefix = "ai.image." + legacySlot;
        AiImageProviderConfig config = new AiImageProviderConfig();
        config.setProviderCode(providerCode);
        config.setProviderName(readString(prefix + ".name", defaultName));
        config.setEnabled(Boolean.valueOf(readBoolean(prefix + ".enabled", false)));
        config.setAdapterType(defaultAdapterType);
        config.setBaseUrl(readString(prefix + ".baseUrl", ""));
        config.setApiKey(readString(prefix + ".apiKey", ""));
        config.setModel(readString(prefix + ".model", DEFAULT_MODEL));
        config.setSupportsBatch(Boolean.TRUE);
        return config;
    }

    private String normalizeProviderCode(String providerCode)
    {
        return StringUtils.trimToEmpty(providerCode).toLowerCase();
    }

    private String normalizeAdapterType(String adapterType)
    {
        String normalized = StringUtils.defaultIfBlank(adapterType, ADAPTER_OPENAI_COMPATIBLE).trim();
        if ("grsai".equals(normalized))
        {
            return ADAPTER_GRSAI_ASYNC;
        }
        return normalized;
    }

    private String normalizeResponseMode(String responseMode, AiImageProviderConfig provider)
    {
        String normalized = StringUtils.defaultIfBlank(responseMode, "").trim().toLowerCase();
        if (RESPONSE_MODE_STREAM.equals(normalized))
        {
            return RESPONSE_MODE_STREAM;
        }
        if (RESPONSE_MODE_JSON.equals(normalized))
        {
            return RESPONSE_MODE_JSON;
        }
        if (provider != null && ADAPTER_OPENAI_COMPATIBLE.equals(provider.getAdapterType())
                && StringUtils.containsIgnoreCase(StringUtils.defaultString(provider.getBaseUrl()), "gpt2image.superapi.buzz"))
        {
            return RESPONSE_MODE_STREAM;
        }
        return RESPONSE_MODE_JSON;
    }

    private boolean isSupportedAdapterType(String adapterType)
    {
        return ADAPTER_OPENAI_COMPATIBLE.equals(adapterType) || ADAPTER_GRSAI_ASYNC.equals(adapterType);
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

    private String readOutputFormat()
    {
        return normalizeOutputFormat(readString(KEY_OUTPUT_FORMAT, "jpeg"));
    }

    private String normalizeOutputFormat(String outputFormat)
    {
        return "png".equalsIgnoreCase(outputFormat) ? "png" : "jpeg";
    }

    private List<AiImageModelRouteConfig> buildDefaultRoutes()
    {
        List<AiImageModelRouteConfig> routes = new ArrayList<>();
        AiImageModelRouteConfig gptRoute = new AiImageModelRouteConfig();
        gptRoute.setModel(DEFAULT_MODEL);
        gptRoute.setEnabled(Boolean.TRUE);
        gptRoute.setPrimaryProviderCode(PROVIDER_SUPERAPI);
        gptRoute.setBackupProviderCode(PROVIDER_GRSAI);
        gptRoute.setFallbackEnabled(Boolean.TRUE);
        gptRoute.setSortOrder(Integer.valueOf(1));
        gptRoute.setRemark("GPT 主用 SuperAPI，失败切 Grsai");
        routes.add(gptRoute);

        AiImageModelRouteConfig gptVipRoute = new AiImageModelRouteConfig();
        gptVipRoute.setModel(MODEL_GPT_IMAGE_2_VIP);
        gptVipRoute.setEnabled(Boolean.TRUE);
        gptVipRoute.setPrimaryProviderCode(PROVIDER_GRSAI);
        gptVipRoute.setBackupProviderCode("");
        gptVipRoute.setFallbackEnabled(Boolean.FALSE);
        gptVipRoute.setSortOrder(Integer.valueOf(2));
        gptVipRoute.setRemark("GPT VIP 固定走 Grsai");
        routes.add(gptVipRoute);

        AiImageModelRouteConfig nanoRoute = new AiImageModelRouteConfig();
        nanoRoute.setModel(MODEL_NANO_BANANA);
        nanoRoute.setEnabled(Boolean.TRUE);
        nanoRoute.setPrimaryProviderCode(PROVIDER_GRSAI);
        nanoRoute.setBackupProviderCode("");
        nanoRoute.setFallbackEnabled(Boolean.FALSE);
        nanoRoute.setSortOrder(Integer.valueOf(3));
        nanoRoute.setRemark("nano-banana-2 固定走 Grsai");
        routes.add(nanoRoute);

        AiImageModelRouteConfig nanoProRoute = new AiImageModelRouteConfig();
        nanoProRoute.setModel(MODEL_NANO_BANANA_PRO);
        nanoProRoute.setEnabled(Boolean.TRUE);
        nanoProRoute.setPrimaryProviderCode(PROVIDER_GRSAI);
        nanoProRoute.setBackupProviderCode("");
        nanoProRoute.setFallbackEnabled(Boolean.FALSE);
        nanoProRoute.setSortOrder(Integer.valueOf(4));
        nanoProRoute.setRemark("nano-banana-pro 固定走 Grsai");
        routes.add(nanoProRoute);

        AiImageModelRouteConfig nanoFastRoute = new AiImageModelRouteConfig();
        nanoFastRoute.setModel(MODEL_NANO_BANANA_FAST);
        nanoFastRoute.setEnabled(Boolean.TRUE);
        nanoFastRoute.setPrimaryProviderCode(PROVIDER_GRSAI);
        nanoFastRoute.setBackupProviderCode("");
        nanoFastRoute.setFallbackEnabled(Boolean.FALSE);
        nanoFastRoute.setSortOrder(Integer.valueOf(5));
        nanoFastRoute.setRemark("nano-banana 固定走 Grsai");
        routes.add(nanoFastRoute);
        return routes;
    }

    private void addDefaultGrsaiModels(Collection<String> models)
    {
        models.add(DEFAULT_MODEL);
        models.add(MODEL_GPT_IMAGE_2_VIP);
        models.add(MODEL_NANO_BANANA);
        models.add(MODEL_NANO_BANANA_PRO);
        models.add(MODEL_NANO_BANANA_FAST);
    }

    private AiImageProviderConfig fromProviderRecord(AiImageProviderRecord record, List<String> supportedModels)
    {
        AiImageProviderConfig config = new AiImageProviderConfig();
        config.setProviderCode(record.getProviderCode());
        config.setProviderName(record.getProviderName());
        config.setAdapterType(record.getAdapterType());
        config.setResponseMode(record.getResponseMode());
        config.setSupportsBatch(Boolean.valueOf(!Boolean.FALSE.equals(record.getSupportsBatch())));
        config.setBaseUrl(record.getBaseUrl());
        config.setApiKey(record.getApiKey());
        config.setEnabled(record.getEnabled());
        config.setSupportedModels(supportedModels == null ? Collections.emptyList() : supportedModels);
        config.setModel(config.getSupportedModels().isEmpty() ? "" : config.getSupportedModels().get(0));
        config.setSortOrder(record.getSortOrder());
        config.setRemark(record.getRemark());
        return config;
    }

    private AiImageModelRouteConfig fromModelRouteRecord(AiImageModelRouteRecord record)
    {
        AiImageModelRouteConfig route = new AiImageModelRouteConfig();
        route.setModel(record.getModel());
        route.setEnabled(record.getEnabled());
        route.setPrimaryProviderCode(record.getPrimaryProviderCode());
        route.setBackupProviderCode(record.getBackupProviderCode());
        route.setFallbackEnabled(record.getFallbackEnabled());
        route.setSortOrder(record.getSortOrder());
        route.setRemark(record.getRemark());
        return route;
    }

    private AiImageProviderRecord toProviderRecord(AiImageProviderConfig config)
    {
        AiImageProviderRecord record = new AiImageProviderRecord();
        record.setProviderCode(config.getProviderCode());
        record.setProviderName(config.getProviderName());
        record.setAdapterType(config.getAdapterType());
        record.setResponseMode(config.getResponseMode());
        record.setSupportsBatch(Boolean.valueOf(!Boolean.FALSE.equals(config.getSupportsBatch())));
        record.setBaseUrl(config.getBaseUrl());
        record.setApiKey(config.getApiKey());
        record.setEnabled(config.getEnabled());
        record.setSortOrder(config.getSortOrder());
        record.setRemark(config.getRemark());
        return record;
    }

    private AiImageProviderModelRecord toProviderModelRecord(String providerCode, String model)
    {
        AiImageProviderModelRecord record = new AiImageProviderModelRecord();
        record.setProviderCode(providerCode);
        record.setModel(model);
        record.setEnabled(Boolean.TRUE);
        return record;
    }

    private AiImageModelRouteRecord toModelRouteRecord(AiImageModelRouteConfig config)
    {
        AiImageModelRouteRecord record = new AiImageModelRouteRecord();
        record.setModel(config.getModel());
        record.setEnabled(config.getEnabled());
        record.setPrimaryProviderCode(config.getPrimaryProviderCode());
        record.setBackupProviderCode(blankToNull(config.getBackupProviderCode()));
        record.setFallbackEnabled(config.getFallbackEnabled());
        record.setSortOrder(config.getSortOrder());
        record.setRemark(config.getRemark());
        return record;
    }

    private List<AiImageProviderHealthStats> buildHealthStats(List<AiImageProviderConfig> providers)
    {
        List<AiImageProviderHealthStats> stats = new ArrayList<>();
        for (AiImageProviderConfig provider : providers)
        {
            stats.add(callLogMapper.selectProviderHealthStats(provider.getProviderCode(), 50));
        }
        return stats;
    }

    private AiImageProviderConfig findProvider(List<AiImageProviderConfig> providers, String providerCode)
    {
        if (providers == null || StringUtils.isBlank(providerCode))
        {
            return null;
        }
        for (AiImageProviderConfig provider : providers)
        {
            if (providerCode.equals(provider.getProviderCode()))
            {
                return provider;
            }
        }
        return null;
    }

    private AiImageProviderConfig resolveCompatBackupProvider(List<AiImageProviderConfig> providers, List<AiImageModelRouteConfig> routes)
    {
        for (AiImageModelRouteConfig route : routes)
        {
            if (DEFAULT_MODEL.equals(route.getModel()) && StringUtils.isNotBlank(route.getBackupProviderCode()))
            {
                return findProvider(providers, route.getBackupProviderCode());
            }
        }
        return null;
    }

    private String resolveCompatActiveProvider(List<AiImageModelRouteConfig> routes)
    {
        for (AiImageModelRouteConfig route : routes)
        {
            if (DEFAULT_MODEL.equals(route.getModel()))
            {
                return route.getPrimaryProviderCode();
            }
        }
        return PROVIDER_SUPERAPI;
    }

    private boolean supportsModel(AiImageProviderConfig provider, String model)
    {
        return provider != null
                && provider.getSupportedModels() != null
                && provider.getSupportedModels().contains(normalizeModel(model));
    }

    private String normalizeModel(String model)
    {
        String normalized = StringUtils.trimToEmpty(model);
        if (StringUtils.isBlank(normalized))
        {
            throw new ServiceException("模型不能为空");
        }
        return normalized;
    }

    private String blankToNull(String value)
    {
        return StringUtils.isBlank(value) ? null : value.trim();
    }

    private String blankToEmpty(String value)
    {
        return value == null ? "" : value.trim();
    }
}
