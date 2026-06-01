package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 模板收藏 ai_template_favorite
 */
public class AiTemplateFavorite extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 收藏ID */
    private Long favoriteId;

    /** 用户ID */
    private Long userId;

    /** 模板ID */
    private Long templateId;

    public Long getFavoriteId()
    {
        return favoriteId;
    }

    public void setFavoriteId(Long favoriteId)
    {
        this.favoriteId = favoriteId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getTemplateId()
    {
        return templateId;
    }

    public void setTemplateId(Long templateId)
    {
        this.templateId = templateId;
    }
}
