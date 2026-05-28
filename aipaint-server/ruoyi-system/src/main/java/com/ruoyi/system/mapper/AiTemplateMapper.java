package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.domain.AiTemplateTag;

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

    public int deleteTemplateTagByTemplateIds(Long[] templateIds);

    public int deleteTemplateTagByTagIds(Long[] tagIds);

    public int deleteTemplateTagByTemplateId(Long templateId);

    public int batchTemplateTag(@Param("templateId") Long templateId, @Param("tagIds") Long[] tagIds);

    public List<AiTemplateTag> selectTagsByTemplateIds(Long[] templateIds);
}
