package com.ruoyi.system.mapper;

import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiImageProviderCallLog;
import com.ruoyi.system.domain.AiImageProviderHealthStats;

/**
 * AI图片通道调用日志 数据层
 */
public interface AiImageProviderCallLogMapper
{
    public int insertCallLog(AiImageProviderCallLog callLog);

    public AiImageProviderHealthStats selectProviderHealthStats(@Param("providerCode") String providerCode, @Param("limit") Integer limit);

    public Long countRecentConsecutiveFailures(@Param("providerCode") String providerCode, @Param("minutes") Integer minutes);
}
