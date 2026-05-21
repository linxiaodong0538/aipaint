package com.ruoyi.web.service.image;

/**
 * AI 生图请求
 */
public class AiImageGenerateRequest
{
    private String prompt;

    private String size;

    private String quality;

    public String getPrompt()
    {
        return prompt;
    }

    public void setPrompt(String prompt)
    {
        this.prompt = prompt;
    }

    public String getSize()
    {
        return size;
    }

    public void setSize(String size)
    {
        this.size = size;
    }

    public String getQuality()
    {
        return quality;
    }

    public void setQuality(String quality)
    {
        this.quality = quality;
    }
}
