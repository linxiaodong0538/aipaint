package com.ruoyi.system.service;

/**
 * 模板收藏 服务层
 */
public interface IAiTemplateFavoriteService
{
    public boolean isFavorited(Long userId, Long templateId);

    public boolean favorite(Long userId, Long templateId);

    public boolean unfavorite(Long userId, Long templateId);
}
