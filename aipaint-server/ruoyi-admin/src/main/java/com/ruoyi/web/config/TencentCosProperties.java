package com.ruoyi.web.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import com.ruoyi.common.utils.StringUtils;

/**
 * 腾讯云 COS 配置。
 */
@Component
@ConfigurationProperties(prefix = "tencent.cos")
public class TencentCosProperties
{
    private String secretId;

    private String secretKey;

    private String region;

    private String bucketName;

    private String baseUrl;

    public boolean isConfigured()
    {
        return StringUtils.isNotBlank(secretId) && StringUtils.isNotBlank(secretKey)
                && StringUtils.isNotBlank(region) && StringUtils.isNotBlank(bucketName)
                && StringUtils.isNotBlank(baseUrl);
    }

    public String getSecretId()
    {
        return secretId;
    }

    public void setSecretId(String secretId)
    {
        this.secretId = secretId;
    }

    public String getSecretKey()
    {
        return secretKey;
    }

    public void setSecretKey(String secretKey)
    {
        this.secretKey = secretKey;
    }

    public String getRegion()
    {
        return region;
    }

    public void setRegion(String region)
    {
        this.region = region;
    }

    public String getBucketName()
    {
        return bucketName;
    }

    public void setBucketName(String bucketName)
    {
        this.bucketName = bucketName;
    }

    public String getBaseUrl()
    {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl)
    {
        this.baseUrl = baseUrl;
    }
}
