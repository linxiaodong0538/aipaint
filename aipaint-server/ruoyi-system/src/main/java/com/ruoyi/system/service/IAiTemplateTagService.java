package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiTemplateTag;

public interface IAiTemplateTagService
{
    public List<AiTemplateTag> selectTagList(AiTemplateTag tag);

    public List<AiTemplateTag> selectTagAll();

    public List<AiTemplateTag> selectEnabledTagList();

    public AiTemplateTag selectTagById(Long tagId);

    public int insertTag(AiTemplateTag tag);

    public int updateTag(AiTemplateTag tag);

    public int deleteTagByIds(Long[] tagIds);
}
