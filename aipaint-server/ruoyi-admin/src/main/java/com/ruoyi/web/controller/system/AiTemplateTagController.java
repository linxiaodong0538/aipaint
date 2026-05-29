package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.AiTemplateTag;
import com.ruoyi.system.service.IAiTemplateTagService;

/**
 * 生图模板标签管理
 */
@RestController
@RequestMapping("/system/template/tag")
public class AiTemplateTagController extends BaseController
{
    @Autowired
    private IAiTemplateTagService tagService;

    @PreAuthorize("@ss.hasPermi('system:template:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiTemplateTag tag)
    {
        startPage();
        List<AiTemplateTag> list = tagService.selectTagList(tag);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:template:export')")
    @Log(title = "模板标签", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiTemplateTag tag)
    {
        List<AiTemplateTag> list = tagService.selectTagList(tag);
        ExcelUtil<AiTemplateTag> util = new ExcelUtil<AiTemplateTag>(AiTemplateTag.class);
        util.exportExcel(response, list, "模板标签数据");
    }

    @PreAuthorize("@ss.hasPermi('system:template:query')")
    @GetMapping(value = "/{tagId}")
    public AjaxResult getInfo(@PathVariable Long tagId)
    {
        return success(tagService.selectTagById(tagId));
    }

    @PreAuthorize("@ss.hasPermi('system:template:add')")
    @Log(title = "模板标签", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody AiTemplateTag tag)
    {
        tag.setCreateBy(getUsername());
        return toAjax(tagService.insertTag(tag));
    }

    @PreAuthorize("@ss.hasPermi('system:template:edit')")
    @Log(title = "模板标签", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody AiTemplateTag tag)
    {
        tag.setUpdateBy(getUsername());
        return toAjax(tagService.updateTag(tag));
    }

    @PreAuthorize("@ss.hasPermi('system:template:edit')")
    @Log(title = "模板标签状态", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody AiTemplateTag tag)
    {
        tag.setUpdateBy(getUsername());
        return toAjax(tagService.updateTag(tag));
    }

    @PreAuthorize("@ss.hasPermi('system:template:remove')")
    @Log(title = "模板标签", businessType = BusinessType.DELETE)
    @DeleteMapping("/{tagIds}")
    public AjaxResult remove(@PathVariable Long[] tagIds)
    {
        return toAjax(tagService.deleteTagByIds(tagIds));
    }

    @GetMapping("/optionselect")
    public AjaxResult optionselect()
    {
        return success(tagService.selectEnabledTagList());
    }
}
