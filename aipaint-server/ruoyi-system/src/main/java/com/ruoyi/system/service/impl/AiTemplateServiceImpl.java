package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.mapper.AiTemplateMapper;
import com.ruoyi.system.service.IAiTemplateService;

/**
 * 生图模板 服务层处理
 */
@Service
public class AiTemplateServiceImpl implements IAiTemplateService
{
    @Autowired
    private AiTemplateMapper templateMapper;

    @Override
    public List<AiTemplate> selectTemplateList(AiTemplate template)
    {
        return templateMapper.selectTemplateList(template);
    }

    @Override
    public List<AiTemplate> selectEnabledTemplateList(AiTemplate template)
    {
        return templateMapper.selectEnabledTemplateList(template);
    }

    @Override
    public List<AiTemplateCategory> selectEnabledCategories()
    {
        return templateMapper.selectEnabledCategories();
    }

    @Override
    public AiTemplate selectTemplateById(Long templateId)
    {
        return templateMapper.selectTemplateById(templateId);
    }

    @Override
    public AiTemplate selectEnabledTemplateById(Long templateId)
    {
        return templateMapper.selectEnabledTemplateById(templateId);
    }

    @Override
    public int insertTemplate(AiTemplate template)
    {
        return templateMapper.insertTemplate(template);
    }

    @Override
    public int updateTemplate(AiTemplate template)
    {
        return templateMapper.updateTemplate(template);
    }

    @Override
    public int deleteTemplateByIds(Long[] templateIds)
    {
        return templateMapper.deleteTemplateByIds(templateIds);
    }
}
