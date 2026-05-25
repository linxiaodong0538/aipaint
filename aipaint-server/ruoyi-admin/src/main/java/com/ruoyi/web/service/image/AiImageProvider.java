package com.ruoyi.web.service.image;

/**
 * AI 生图 Provider
 */
public interface AiImageProvider
{
    String getAdapterType();

    String generateAndSave(AiImageGenerateRequest request, AiImageProviderConfig providerConfig);
}
