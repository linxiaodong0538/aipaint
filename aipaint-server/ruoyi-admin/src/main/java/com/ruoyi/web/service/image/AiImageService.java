package com.ruoyi.web.service.image;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiGenerationTask;
import com.ruoyi.system.domain.AiImageProviderCallLog;
import com.ruoyi.system.mapper.AiImageProviderCallLogMapper;

/**
 * AI 生图服务
 */
@Service
public class AiImageService
{
    private static final Logger log = LoggerFactory.getLogger(AiImageService.class);

    private final Map<String, AiImageProvider> providers = new HashMap<>();

    private final AiImageConfigService aiImageConfigService;

    private final AiImageProviderCallLogMapper callLogMapper;

    public AiImageService(List<AiImageProvider> providers, AiImageConfigService aiImageConfigService, AiImageProviderCallLogMapper callLogMapper)
    {
        for (AiImageProvider provider : providers)
        {
            this.providers.put(provider.getProviderType(), provider);
        }
        this.aiImageConfigService = aiImageConfigService;
        this.callLogMapper = callLogMapper;
    }

    public AiImageProviderConfig resolveActiveProvider()
    {
        return aiImageConfigService.resolveActiveProvider();
    }

    public String resolveImageSize(String ratio)
    {
        return aiImageConfigService.resolveImageSize(ratio);
    }

    public AiImageGenerateResult generateAndSave(AiGenerationTask task)
    {
        AiImageAdminConfig adminConfig = aiImageConfigService.getAdminConfig();
        AiImageProviderConfig providerConfig = aiImageConfigService.resolveProviderByCode(task.getProviderCode());
        if (shouldBypassPrimary(adminConfig, providerConfig))
        {
            AiImageProviderConfig backupConfig = aiImageConfigService.resolveProviderByCode(AiImageConfigService.SLOT_BACKUP);
            String resultImageUrl = generateAndSaveWithProvider(task, backupConfig, true);
            return new AiImageGenerateResult(resultImageUrl, backupConfig.getProviderCode(), true);
        }
        try
        {
            String resultImageUrl = generateAndSaveWithProvider(task, providerConfig, false);
            return new AiImageGenerateResult(resultImageUrl, providerConfig.getProviderCode(), false);
        }
        catch (Exception e)
        {
            if (!shouldFallback(adminConfig, providerConfig, e))
            {
                throw e;
            }

            try
            {
                AiImageProviderConfig backupConfig = aiImageConfigService.resolveProviderByCode(AiImageConfigService.SLOT_BACKUP);
                String resultImageUrl = generateAndSaveWithProvider(task, backupConfig, true);
                return new AiImageGenerateResult(resultImageUrl, backupConfig.getProviderCode(), true);
            }
            catch (Exception fallbackException)
            {
                throw new ServiceException("主通道失败：" + normalizeErrorMessage(e)
                        + "；备用通道失败：" + normalizeErrorMessage(fallbackException));
            }
        }
    }

    private String generateAndSaveWithProvider(AiGenerationTask task, AiImageProviderConfig providerConfig, boolean fallbackUsed)
    {
        AiImageProvider provider = providers.get(providerConfig.getProviderType());
        if (provider == null)
        {
            throw new ServiceException("暂不支持的生图通道类型：" + providerConfig.getProviderType());
        }

        AiImageGenerateRequest request = new AiImageGenerateRequest();
        request.setPrompt(task.getPrompt());
        request.setSize(task.getSize());
        request.setQuality(task.getQuality());

        long startTime = System.currentTimeMillis();
        try
        {
            String resultImageUrl = provider.generateAndSave(request, providerConfig);
            recordCallLog(task, providerConfig, "success", fallbackUsed, System.currentTimeMillis() - startTime, null);
            return resultImageUrl;
        }
        catch (Exception e)
        {
            recordCallLog(task, providerConfig, "failed", fallbackUsed, System.currentTimeMillis() - startTime, normalizeErrorMessage(e));
            throw e;
        }
    }

    private boolean shouldFallback(AiImageAdminConfig adminConfig, AiImageProviderConfig failedProvider, Exception e)
    {
        if (AiImageConfigService.STRATEGY_MANUAL.equals(adminConfig.getFallbackStrategy()))
        {
            return false;
        }
        if (!AiImageConfigService.SLOT_PRIMARY.equals(failedProvider.getProviderCode()))
        {
            return false;
        }
        if (adminConfig.getBackupProvider() == null || !Boolean.TRUE.equals(adminConfig.getBackupProvider().getEnabled()))
        {
            return false;
        }
        return isFallbackEligibleError(normalizeErrorMessage(e));
    }

    private boolean shouldBypassPrimary(AiImageAdminConfig adminConfig, AiImageProviderConfig providerConfig)
    {
        if (!AiImageConfigService.STRATEGY_CIRCUIT_BREAKER.equals(adminConfig.getFallbackStrategy()))
        {
            return false;
        }
        if (!AiImageConfigService.SLOT_PRIMARY.equals(providerConfig.getProviderCode()))
        {
            return false;
        }
        if (adminConfig.getBackupProvider() == null || !Boolean.TRUE.equals(adminConfig.getBackupProvider().getEnabled()))
        {
            return false;
        }

        Long failures = callLogMapper.countRecentConsecutiveFailures(
                AiImageConfigService.SLOT_PRIMARY,
                adminConfig.getCircuitBreakerCooldownMinutes());
        return failures != null && failures.longValue() >= adminConfig.getCircuitBreakerFailureThreshold().longValue();
    }

    private boolean isFallbackEligibleError(String message)
    {
        if (StringUtils.isBlank(message))
        {
            return false;
        }
        String lower = message.toLowerCase();
        if (lower.contains("400") || lower.contains("401") || lower.contains("403")
                || message.contains("参数") || message.contains("未配置") || message.contains("套餐")
                || message.contains("余额") || message.contains("积分") || message.contains("审核")
                || message.contains("违规") || message.contains("敏感"))
        {
            return false;
        }
        return lower.contains("eof") || lower.contains("timeout") || lower.contains("timed out")
                || lower.contains("reset") || lower.contains("closed") || lower.contains("connection")
                || lower.contains("502") || lower.contains("503") || lower.contains("504")
                || lower.contains("429") || message.contains("限流") || message.contains("繁忙");
    }

    private void recordCallLog(AiGenerationTask task, AiImageProviderConfig providerConfig, String status,
            boolean fallbackUsed, long durationMs, String errorMessage)
    {
        AiImageProviderCallLog callLog = new AiImageProviderCallLog();
        callLog.setTaskId(task.getTaskId());
        callLog.setProviderCode(providerConfig.getProviderCode());
        callLog.setProviderName(providerConfig.getProviderName());
        callLog.setModel(providerConfig.getModel());
        callLog.setQuality(task.getQuality());
        callLog.setSize(task.getSize());
        callLog.setStatus(status);
        callLog.setFallbackUsed(Boolean.valueOf(fallbackUsed));
        callLog.setDurationMs(durationMs);
        callLog.setErrorMessage(trimMessage(errorMessage));
        try
        {
            callLogMapper.insertCallLog(callLog);
        }
        catch (Exception e)
        {
            log.warn("AI图片通道调用日志写入失败，taskId={}, providerCode={}", task.getTaskId(), providerConfig.getProviderCode(), e);
        }
    }

    private String normalizeErrorMessage(Exception e)
    {
        return e == null || StringUtils.isBlank(e.getMessage()) ? "未知错误" : e.getMessage();
    }

    private String trimMessage(String message)
    {
        if (message == null || message.length() <= 1000)
        {
            return message;
        }
        return message.substring(0, 1000);
    }
}
