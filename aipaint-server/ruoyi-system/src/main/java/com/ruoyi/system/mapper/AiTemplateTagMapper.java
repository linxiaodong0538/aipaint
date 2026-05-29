package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.AiTemplateTag;

public interface AiTemplateTagMapper
{
    public List<AiTemplateTag> selectTagList(AiTemplateTag tag);

    public List<AiTemplateTag> selectTagAll();

    public List<AiTemplateTag> selectEnabledTagList();

    public AiTemplateTag selectTagById(Long tagId);

    public int insertTag(AiTemplateTag tag);

    public int updateTag(AiTemplateTag tag);

    public int deleteTagByIds(Long[] tagIds);
}
