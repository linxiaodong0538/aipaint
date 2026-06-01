package com.ruoyi.system.service.impl;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.domain.AiTemplateTag;
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
        List<AiTemplate> list = templateMapper.selectTemplateList(template);
        fillTemplateTags(list);
        return list;
    }

    @Override
    public List<AiTemplate> selectEnabledTemplateList(AiTemplate template)
    {
        List<AiTemplate> list = templateMapper.selectEnabledTemplateList(template);
        fillTemplateTags(list);
        return list;
    }

    @Override
    public List<AiTemplate> selectFavoriteTemplateList(Long userId)
    {
        List<AiTemplate> list = templateMapper.selectFavoriteTemplateList(userId);
        fillTemplateTags(list);
        return list;
    }

    @Override
    public List<AiTemplateCategory> selectEnabledCategories()
    {
        return templateMapper.selectEnabledCategories();
    }

    @Override
    public AiTemplate selectTemplateById(Long templateId)
    {
        AiTemplate template = templateMapper.selectTemplateById(templateId);
        fillTemplateTags(template);
        return template;
    }

    @Override
    public AiTemplate selectEnabledTemplateById(Long templateId)
    {
        AiTemplate template = templateMapper.selectEnabledTemplateById(templateId);
        fillTemplateTags(template);
        return template;
    }

    @Override
    @Transactional
    public int insertTemplate(AiTemplate template)
    {
        int rows = templateMapper.insertTemplate(template);
        insertTemplateTags(template);
        return rows;
    }

    @Override
    @Transactional
    public int updateTemplate(AiTemplate template)
    {
        int rows = templateMapper.updateTemplate(template);
        if (template.getTagIds() != null)
        {
            templateMapper.deleteTemplateTagByTemplateId(template.getTemplateId());
            insertTemplateTags(template);
        }
        return rows;
    }

    @Override
    @Transactional
    public int deleteTemplateByIds(Long[] templateIds)
    {
        templateMapper.deleteTemplateTagByTemplateIds(templateIds);
        return templateMapper.deleteTemplateByIds(templateIds);
    }

    private void insertTemplateTags(AiTemplate template)
    {
        Long[] tagIds = template.getTagIds();
        if (template.getTemplateId() == null || tagIds == null || tagIds.length == 0)
        {
            return;
        }

        Long[] distinctTagIds = Arrays.stream(tagIds)
            .filter(Objects::nonNull)
            .distinct()
            .toArray(Long[]::new);
        if (distinctTagIds.length > 0)
        {
            templateMapper.batchTemplateTag(template.getTemplateId(), distinctTagIds);
        }
    }

    private void fillTemplateTags(AiTemplate template)
    {
        if (template != null)
        {
            fillTemplateTags(Collections.singletonList(template));
        }
    }

    private void fillTemplateTags(List<AiTemplate> templates)
    {
        if (templates == null || templates.isEmpty())
        {
            return;
        }

        Long[] templateIds = templates.stream()
            .map(AiTemplate::getTemplateId)
            .filter(Objects::nonNull)
            .toArray(Long[]::new);
        if (templateIds.length == 0)
        {
            return;
        }

        List<AiTemplateTag> tags = templateMapper.selectTagsByTemplateIds(templateIds);
        Map<Long, List<AiTemplateTag>> tagsByTemplateId = tags.stream()
            .collect(Collectors.groupingBy(AiTemplateTag::getTemplateId));

        for (AiTemplate template : templates)
        {
            List<AiTemplateTag> templateTags = tagsByTemplateId.getOrDefault(template.getTemplateId(), Collections.emptyList());
            template.setTags(templateTags);
            template.setTagIds(templateTags.stream().map(AiTemplateTag::getTagId).toArray(Long[]::new));
        }
    }
}
