package com.ruoyi.web.service.image;

import java.util.List;
import java.util.Map;

/**
 * AI 生图小程序价格配置响应
 */
public class AiImagePricingConfig
{
    private List<AiImageModelPricing> modelPricings;

    private Map<String, Double> resolutionMultipliers;

    private Map<String, Map<String, Integer>> singleCreditCosts;

    public List<AiImageModelPricing> getModelPricings()
    {
        return modelPricings;
    }

    public void setModelPricings(List<AiImageModelPricing> modelPricings)
    {
        this.modelPricings = modelPricings;
    }

    public Map<String, Double> getResolutionMultipliers()
    {
        return resolutionMultipliers;
    }

    public void setResolutionMultipliers(Map<String, Double> resolutionMultipliers)
    {
        this.resolutionMultipliers = resolutionMultipliers;
    }

    public Map<String, Map<String, Integer>> getSingleCreditCosts()
    {
        return singleCreditCosts;
    }

    public void setSingleCreditCosts(Map<String, Map<String, Integer>> singleCreditCosts)
    {
        this.singleCreditCosts = singleCreditCosts;
    }
}
