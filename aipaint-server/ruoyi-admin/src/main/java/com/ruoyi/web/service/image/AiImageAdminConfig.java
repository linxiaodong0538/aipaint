package com.ruoyi.web.service.image;

/**
 * AI 生图后台配置
 */
public class AiImageAdminConfig
{
    private String activeProvider;

    private Boolean forceSizeEnabled;

    private String forceSize;

    private AiImageProviderConfig primaryProvider;

    private AiImageProviderConfig backupProvider;

    public String getActiveProvider()
    {
        return activeProvider;
    }

    public void setActiveProvider(String activeProvider)
    {
        this.activeProvider = activeProvider;
    }

    public Boolean getForceSizeEnabled()
    {
        return forceSizeEnabled;
    }

    public void setForceSizeEnabled(Boolean forceSizeEnabled)
    {
        this.forceSizeEnabled = forceSizeEnabled;
    }

    public String getForceSize()
    {
        return forceSize;
    }

    public void setForceSize(String forceSize)
    {
        this.forceSize = forceSize;
    }

    public AiImageProviderConfig getPrimaryProvider()
    {
        return primaryProvider;
    }

    public void setPrimaryProvider(AiImageProviderConfig primaryProvider)
    {
        this.primaryProvider = primaryProvider;
    }

    public AiImageProviderConfig getBackupProvider()
    {
        return backupProvider;
    }

    public void setBackupProvider(AiImageProviderConfig backupProvider)
    {
        this.backupProvider = backupProvider;
    }
}
