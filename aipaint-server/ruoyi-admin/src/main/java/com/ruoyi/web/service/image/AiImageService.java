package com.ruoyi.web.service.image;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.AiGenerationTask;

/**
 * AI 生图服务
 */
@Service
public class AiImageService
{
    private final Map<String, AiImageProvider> providers = new HashMap<>();

    private final AiImageConfigService aiImageConfigService;

    public AiImageService(List<AiImageProvider> providers, AiImageConfigService aiImageConfigService)
    {
        for (AiImageProvider provider : providers)
        {
            this.providers.put(provider.getProviderType(), provider);
        }
        this.aiImageConfigService = aiImageConfigService;
    }

    public AiImageProviderConfig resolveActiveProvider()
    {
        return aiImageConfigService.resolveActiveProvider();
    }

    public String resolveImageSize(String ratio)
    {
        return aiImageConfigService.resolveImageSize(ratio);
    }

    public String generateAndSave(AiGenerationTask task)
    {
        AiImageProviderConfig providerConfig = aiImageConfigService.resolveProviderByCode(task.getProviderCode());
        AiImageProvider provider = providers.get(providerConfig.getProviderType());
        if (provider == null)
        {
            throw new ServiceException("暂不支持的生图通道类型：" + providerConfig.getProviderType());
        }

        AiImageGenerateRequest request = new AiImageGenerateRequest();
        request.setPrompt(task.getPrompt());
        request.setSize(task.getSize());
        request.setQuality(task.getQuality());
        return provider.generateAndSave(request, providerConfig);
    }
}
