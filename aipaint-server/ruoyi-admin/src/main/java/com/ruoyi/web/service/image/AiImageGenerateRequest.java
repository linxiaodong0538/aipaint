package com.ruoyi.web.service.image;

import java.util.List;

/**
 * AI 生图请求
 */
public class AiImageGenerateRequest
{
    private String prompt;

    private String model;

    private String providerModel;

    private String size;

    private String ratio;

    private String resolution;

    private Integer imageCount;

    private String outputFormat;

    private Integer outputCompression;

    private List<String> imageUrls;

    public String getPrompt()
    {
        return prompt;
    }

    public void setPrompt(String prompt)
    {
        this.prompt = prompt;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public String getProviderModel()
    {
        return providerModel;
    }

    public void setProviderModel(String providerModel)
    {
        this.providerModel = providerModel;
    }

    public String getSize()
    {
        return size;
    }

    public void setSize(String size)
    {
        this.size = size;
    }

    public String getRatio()
    {
        return ratio;
    }

    public void setRatio(String ratio)
    {
        this.ratio = ratio;
    }

    public String getResolution()
    {
        return resolution;
    }

    public void setResolution(String resolution)
    {
        this.resolution = resolution;
    }

    public Integer getImageCount()
    {
        return imageCount;
    }

    public void setImageCount(Integer imageCount)
    {
        this.imageCount = imageCount;
    }

    public String getOutputFormat()
    {
        return outputFormat;
    }

    public void setOutputFormat(String outputFormat)
    {
        this.outputFormat = outputFormat;
    }

    public Integer getOutputCompression()
    {
        return outputCompression;
    }

    public void setOutputCompression(Integer outputCompression)
    {
        this.outputCompression = outputCompression;
    }

    public List<String> getImageUrls()
    {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls)
    {
        this.imageUrls = imageUrls;
    }
}
