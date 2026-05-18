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
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.service.IAiTemplateService;
import com.ruoyi.system.service.IAiTemplateCategoryService;

/**
 * 生图模板后台管理
 */
@RestController
@RequestMapping("/system/template")
public class AiTemplateController extends BaseController
{
    @Autowired
    private IAiTemplateService templateService;

    @Autowired
    private IAiTemplateCategoryService categoryService;

    @PreAuthorize("@ss.hasPermi('system:template:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiTemplate template)
    {
        startPage();
        List<AiTemplate> list = templateService.selectTemplateList(template);
        return getDataTable(list);
    }

    @Log(title = "模板管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:template:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiTemplate template)
    {
        List<AiTemplate> list = templateService.selectTemplateList(template);
        ExcelUtil<AiTemplate> util = new ExcelUtil<AiTemplate>(AiTemplate.class);
        util.exportExcel(response, list, "模板数据");
    }

    @PreAuthorize("@ss.hasPermi('system:template:query')")
    @GetMapping(value = "/{templateId}")
    public AjaxResult getInfo(@PathVariable Long templateId)
    {
        return success(templateService.selectTemplateById(templateId));
    }

    @PreAuthorize("@ss.hasPermi('system:template:add')")
    @Log(title = "模板管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody AiTemplate template)
    {
        template.setCreateBy(getUsername());
        return toAjax(templateService.insertTemplate(template));
    }

    @PreAuthorize("@ss.hasPermi('system:template:edit')")
    @Log(title = "模板管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody AiTemplate template)
    {
        template.setUpdateBy(getUsername());
        return toAjax(templateService.updateTemplate(template));
    }

    @GetMapping("/optionselect")
    public AjaxResult optionselect()
    {
        List<AiTemplateCategory> categories = categoryService.selectCategoryAll();
        return success(categories);
    }

    @PreAuthorize("@ss.hasPermi('system:template:edit')")
    @Log(title = "模板状态", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody AiTemplate template)
    {
        template.setUpdateBy(getUsername());
        return toAjax(templateService.updateTemplate(template));
    }

    @PreAuthorize("@ss.hasPermi('system:template:remove')")
    @Log(title = "模板管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{templateIds}")
    public AjaxResult remove(@PathVariable Long[] templateIds)
    {
        return toAjax(templateService.deleteTemplateByIds(templateIds));
    }
}
