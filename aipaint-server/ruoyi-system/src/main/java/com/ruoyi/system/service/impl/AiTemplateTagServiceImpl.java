package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.AiTemplateTag;
import com.ruoyi.system.mapper.AiTemplateMapper;
import com.ruoyi.system.mapper.AiTemplateTagMapper;
import com.ruoyi.system.service.IAiTemplateTagService;

@Service
public class AiTemplateTagServiceImpl implements IAiTemplateTagService
{
    @Autowired
    private AiTemplateTagMapper tagMapper;

    @Autowired
    private AiTemplateMapper templateMapper;

    @Override
    public List<AiTemplateTag> selectTagList(AiTemplateTag tag)
    {
        return tagMapper.selectTagList(tag);
    }

    @Override
    public List<AiTemplateTag> selectTagAll()
    {
        return tagMapper.selectTagAll();
    }

    @Override
    public List<AiTemplateTag> selectEnabledTagList()
    {
        return tagMapper.selectEnabledTagList();
    }

    @Override
    public AiTemplateTag selectTagById(Long tagId)
    {
        return tagMapper.selectTagById(tagId);
    }

    @Override
    public int insertTag(AiTemplateTag tag)
    {
        return tagMapper.insertTag(tag);
    }

    @Override
    public int updateTag(AiTemplateTag tag)
    {
        return tagMapper.updateTag(tag);
    }

    @Override
    public int deleteTagByIds(Long[] tagIds)
    {
        templateMapper.deleteTemplateTagByTagIds(tagIds);
        return tagMapper.deleteTagByIds(tagIds);
    }
}
