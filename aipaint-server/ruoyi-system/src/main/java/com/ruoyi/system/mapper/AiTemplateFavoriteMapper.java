package com.ruoyi.system.mapper;

import org.apache.ibatis.annotations.Param;

/**
 * 模板收藏 数据层
 */
public interface AiTemplateFavoriteMapper
{
    public int countFavorite(@Param("userId") Long userId, @Param("templateId") Long templateId);

    public int insertFavorite(@Param("userId") Long userId, @Param("templateId") Long templateId);

    public int deleteFavorite(@Param("userId") Long userId, @Param("templateId") Long templateId);
}
