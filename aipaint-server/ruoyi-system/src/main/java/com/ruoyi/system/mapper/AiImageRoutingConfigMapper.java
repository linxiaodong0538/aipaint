package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.AiImageModelRouteRecord;
import com.ruoyi.system.domain.AiImageProviderModelRecord;
import com.ruoyi.system.domain.AiImageProviderRecord;

/**
 * AI 图片通道与模型路由配置 Mapper
 */
public interface AiImageRoutingConfigMapper
{
    public List<AiImageProviderRecord> selectProviders();

    public List<AiImageProviderModelRecord> selectProviderModels();

    public List<AiImageModelRouteRecord> selectModelRoutes();

    public int deleteModelRoutes();

    public int deleteProviderModels();

    public int deleteProviders();

    public int insertProvider(AiImageProviderRecord provider);

    public int insertProviderModel(AiImageProviderModelRecord providerModel);

    public int insertModelRoute(AiImageModelRouteRecord route);
}
