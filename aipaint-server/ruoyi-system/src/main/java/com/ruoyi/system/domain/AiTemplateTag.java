package com.ruoyi.system.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 生图模板标签 ai_template_tag
 */
public class AiTemplateTag extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 标签ID */
    @Excel(name = "标签ID", cellType = ColumnType.NUMERIC)
    private Long tagId;

    /** 标签名称 */
    @Excel(name = "标签名称")
    private String tagName;

    /** 分组编码 */
    @Excel(name = "分组")
    private String groupCode;

    /** 排序 */
    @Excel(name = "排序")
    private Integer sort;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 关联模板ID，仅用于批量组装模板标签 */
    private Long templateId;

    public Long getTagId()
    {
        return tagId;
    }

    public void setTagId(Long tagId)
    {
        this.tagId = tagId;
    }

    @NotBlank(message = "标签名称不能为空")
    @Size(min = 0, max = 50, message = "标签名称长度不能超过50个字符")
    public String getTagName()
    {
        return tagName;
    }

    public void setTagName(String tagName)
    {
        this.tagName = tagName;
    }

    @NotBlank(message = "分组不能为空")
    @Pattern(regexp = "^(style|use|subject|element|scene|medium|composition|color|technique)$", message = "分组只能为style、use、subject、element、scene、medium、composition、color、technique")
    public String getGroupCode()
    {
        return groupCode;
    }

    public void setGroupCode(String groupCode)
    {
        this.groupCode = groupCode;
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

    public Long getTemplateId()
    {
        return templateId;
    }

    public void setTemplateId(Long templateId)
    {
        this.templateId = templateId;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("tagId", getTagId())
            .append("tagName", getTagName())
            .append("groupCode", getGroupCode())
            .append("sort", getSort())
            .append("status", getStatus())
            .append("templateId", getTemplateId())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
