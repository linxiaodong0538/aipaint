package com.ruoyi.web.service.image;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;

/**
 * AI图片生成配置
 */
@Component
@ConfigurationProperties(prefix = "ai.image")
public class AiImageProperties
{
    private String baseUrl = "https://dm-fox.rjj.cc/codex/v1";

    private String apiKey;

    private String model = "gpt-image-2";

    private boolean testMode = false;

    private String testSize = "256x256";

    private Integer partialImages = 1;

    public boolean hasApiKey()
    {
        return StringUtils.isNotBlank(apiKey);
    }

    public String getBaseUrl()
    {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl)
    {
        this.baseUrl = baseUrl;
    }

    public String getApiKey()
    {
        return apiKey;
    }

    public void setApiKey(String apiKey)
    {
        this.apiKey = apiKey;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public boolean isTestMode()
    {
        return testMode;
    }

    public void setTestMode(boolean testMode)
    {
        this.testMode = testMode;
    }

    public String getTestSize()
    {
        return testSize;
    }

    public void setTestSize(String testSize)
    {
        this.testSize = testSize;
    }

    public Integer getPartialImages()
    {
        return partialImages;
    }

    public void setPartialImages(Integer partialImages)
    {
        this.partialImages = partialImages;
    }
}
