package com.ruoyi.system.domain;

import java.util.List;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 生图模板 ai_template
 */
public class AiTemplate extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 模板ID */
    @Excel(name = "模板ID", cellType = ColumnType.NUMERIC)
    private Long templateId;

    /** 模板标题 */
    @Excel(name = "模板标题")
    private String title;

    /** 分类ID */
    @Excel(name = "分类ID", cellType = ColumnType.NUMERIC)
    private Long categoryId;

    /** 分类名称 */
    @Excel(name = "分类")
    private String categoryName;

    /** 描述 */
    @Excel(name = "描述")
    private String description;

    /** 封面图URL */
    @Excel(name = "封面图")
    private String coverUrl;

    /** 提示词 */
    @Excel(name = "提示词")
    private String prompt;

    /** AI引擎 */
    @Excel(name = "AI引擎")
    private String aiEngine;

    /** 画幅比例 */
    @Excel(name = "画幅比例")
    private String ratio;

    /** 排序 */
    @Excel(name = "排序")
    private Integer sort;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 标签ID集合 */
    private Long[] tagIds;

    /** 标签列表 */
    private List<AiTemplateTag> tags;

    /** 标签ID，仅用于查询筛选 */
    private Long tagId;

    public Long getTemplateId()
    {
        return templateId;
    }

    public void setTemplateId(Long templateId)
    {
        this.templateId = templateId;
    }

    @NotBlank(message = "模板标题不能为空")
    @Size(min = 0, max = 80, message = "模板标题长度不能超过80个字符")
    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    @NotNull(message = "分类不能为空")
    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    @Size(min = 0, max = 200, message = "描述长度不能超过200个字符")
    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    @NotBlank(message = "封面图不能为空")
    @Size(min = 0, max = 1000, message = "封面图地址长度不能超过1000个字符")
    public String getCoverUrl()
    {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl)
    {
        this.coverUrl = coverUrl;
    }

    @NotBlank(message = "提示词不能为空")
    public String getPrompt()
    {
        return prompt;
    }

    public void setPrompt(String prompt)
    {
        this.prompt = prompt;
    }

    @Size(min = 0, max = 50, message = "AI引擎长度不能超过50个字符")
    public String getAiEngine()
    {
        return aiEngine;
    }

    public void setAiEngine(String aiEngine)
    {
        this.aiEngine = aiEngine;
    }

    @Size(min = 0, max = 20, message = "画幅比例长度不能超过20个字符")
    public String getRatio()
    {
        return ratio;
    }

    public void setRatio(String ratio)
    {
        this.ratio = ratio;
    }

    @NotNull(message = "排序不能为空")
    public Integer getSort()
    {
        return sort;
    }

    public void setSort(Integer sort)
    {
        this.sort = sort;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public Long[] getTagIds()
    {
        return tagIds;
    }

    public void setTagIds(Long[] tagIds)
    {
        this.tagIds = tagIds;
    }

    public List<AiTemplateTag> getTags()
    {
        return tags;
    }

    public void setTags(List<AiTemplateTag> tags)
    {
        this.tags = tags;
    }

    public Long getTagId()
    {
        return tagId;
    }

    public void setTagId(Long tagId)
    {
        this.tagId = tagId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("templateId", getTemplateId())
            .append("title", getTitle())
            .append("categoryId", getCategoryId())
            .append("categoryName", getCategoryName())
            .append("description", getDescription())
            .append("coverUrl", getCoverUrl())
            .append("prompt", getPrompt())
            .append("aiEngine", getAiEngine())
            .append("ratio", getRatio())
            .append("sort", getSort())
            .append("status", getStatus())
            .append("tagIds", getTagIds())
            .append("tags", getTags())
            .append("tagId", getTagId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
