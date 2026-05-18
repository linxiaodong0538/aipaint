package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiTemplate;

/**
 * 生图模板 服务层
 */
public interface IAiTemplateService
{
    public List<AiTemplate> selectTemplateList(AiTemplate template);

    public List<AiTemplate> selectEnabledTemplateList(AiTemplate template);

    public List<String> selectEnabledCategories();

    public AiTemplate selectTemplateById(Long templateId);

    public AiTemplate selectEnabledTemplateById(Long templateId);

    public int insertTemplate(AiTemplate template);

    public int updateTemplate(AiTemplate template);

    public int deleteTemplateByIds(Long[] templateIds);
}
