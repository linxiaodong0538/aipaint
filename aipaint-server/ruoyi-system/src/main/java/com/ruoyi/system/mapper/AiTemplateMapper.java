package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.domain.AiTemplateCategory;

/**
 * 生图模板 数据层
 */
public interface AiTemplateMapper
{
    public List<AiTemplate> selectTemplateList(AiTemplate template);

    public List<AiTemplate> selectEnabledTemplateList(AiTemplate template);

    public List<AiTemplateCategory> selectEnabledCategories();

    public AiTemplate selectTemplateById(Long templateId);

    public AiTemplate selectEnabledTemplateById(Long templateId);

    public int insertTemplate(AiTemplate template);

    public int updateTemplate(AiTemplate template);

    public int deleteTemplateByIds(Long[] templateIds);
}
