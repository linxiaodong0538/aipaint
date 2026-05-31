package com.ruoyi.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.mapper.AiTemplateFavoriteMapper;
import com.ruoyi.system.service.IAiTemplateFavoriteService;
import com.ruoyi.system.service.IAiTemplateService;

/**
 * 模板收藏 服务层处理
 */
@Service
public class AiTemplateFavoriteServiceImpl implements IAiTemplateFavoriteService
{
    @Autowired
    private AiTemplateFavoriteMapper favoriteMapper;

    @Autowired
    private IAiTemplateService templateService;

    @Override
    public boolean isFavorited(Long userId, Long templateId)
    {
        if (userId == null || templateId == null)
        {
            return false;
        }
        return favoriteMapper.countFavorite(userId, templateId) > 0;
    }

    @Override
    public boolean favorite(Long userId, Long templateId)
    {
        validateEnabledTemplate(templateId);
        favoriteMapper.insertFavorite(userId, templateId);
        return true;
    }

    @Override
    public boolean unfavorite(Long userId, Long templateId)
    {
        favoriteMapper.deleteFavorite(userId, templateId);
        return false;
    }

    private void validateEnabledTemplate(Long templateId)
    {
        AiTemplate template = templateService.selectEnabledTemplateById(templateId);
        if (template == null)
        {
            throw new ServiceException("模板不存在或已下架");
        }
    }
}
