package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * AI图片生成任务 ai_generation_task
 */
public class AiGenerationTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    @Excel(name = "任务ID")
    private Long taskId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 提示词 */
    @Excel(name = "提示词")
    private String prompt;

    /** 模型 */
    @Excel(name = "模型")
    private String model;

    /** 质量 */
    @Excel(name = "质量")
    private String quality;

    /** 画幅比例 */
    @Excel(name = "画幅比例")
    private String ratio;

    /** 图片尺寸 */
    @Excel(name = "图片尺寸")
    private String size;

    /** 任务状态 */
    @Excel(name = "任务状态")
    private String status;

    /** 结果图片地址 */
    @Excel(name = "结果图片地址")
    private String resultImageUrl;

    /** 预览图片地址 */
    @Excel(name = "预览图片地址")
    private String previewImageUrl;

    /** 错误信息 */
    @Excel(name = "错误信息")
    private String errorMessage;

    /** 消耗积分 */
    @Excel(name = "消耗积分")
    private Integer creditCost;

    /** 完成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date finishTime;

    public Long getTaskId()
    {
        return taskId;
    }

    public void setTaskId(Long taskId)
    {
        this.taskId = taskId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getPrompt()
    {
        return prompt;
    }

    public void setPrompt(String prompt)
    {
        this.prompt = prompt;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public String getQuality()
    {
        return quality;
    }

    public void setQuality(String quality)
    {
        this.quality = quality;
    }

    public String getRatio()
    {
        return ratio;
    }

    public void setRatio(String ratio)
    {
        this.ratio = ratio;
    }

    public String getSize()
    {
        return size;
    }

    public void setSize(String size)
    {
        this.size = size;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getResultImageUrl()
    {
        return resultImageUrl;
    }

    public void setResultImageUrl(String resultImageUrl)
    {
        this.resultImageUrl = resultImageUrl;
    }

    public String getPreviewImageUrl()
    {
        return previewImageUrl;
    }

    public void setPreviewImageUrl(String previewImageUrl)
    {
        this.previewImageUrl = previewImageUrl;
    }

    public String getErrorMessage()
    {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage)
    {
        this.errorMessage = errorMessage;
    }

    public Integer getCreditCost()
    {
        return creditCost;
    }

    public void setCreditCost(Integer creditCost)
    {
        this.creditCost = creditCost;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }
}
