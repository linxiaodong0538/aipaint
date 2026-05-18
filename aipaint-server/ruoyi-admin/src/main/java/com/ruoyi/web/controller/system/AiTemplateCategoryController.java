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
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.service.IAiTemplateCategoryService;

/**
 * 生图模板分类管理
 */
@RestController
@RequestMapping("/system/template/category")
public class AiTemplateCategoryController extends BaseController
{
    @Autowired
    private IAiTemplateCategoryService categoryService;

    @PreAuthorize("@ss.hasPermi('system:template:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiTemplateCategory category)
    {
        startPage();
        List<AiTemplateCategory> list = categoryService.selectCategoryList(category);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:template:export')")
    @Log(title = "模板分类", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiTemplateCategory category)
    {
        List<AiTemplateCategory> list = categoryService.selectCategoryList(category);
        ExcelUtil<AiTemplateCategory> util = new ExcelUtil<AiTemplateCategory>(AiTemplateCategory.class);
        util.exportExcel(response, list, "模板分类数据");
    }

    @PreAuthorize("@ss.hasPermi('system:template:query')")
    @GetMapping(value = "/{categoryId}")
    public AjaxResult getInfo(@PathVariable Long categoryId)
    {
        return success(categoryService.selectCategoryById(categoryId));
    }

    @PreAuthorize("@ss.hasPermi('system:template:add')")
    @Log(title = "模板分类", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody AiTemplateCategory category)
    {
        category.setCreateBy(getUsername());
        return toAjax(categoryService.insertCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('system:template:edit')")
    @Log(title = "模板分类", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody AiTemplateCategory category)
    {
        category.setUpdateBy(getUsername());
        return toAjax(categoryService.updateCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('system:template:remove')")
    @Log(title = "模板分类", businessType = BusinessType.DELETE)
    @DeleteMapping("/{categoryIds}")
    public AjaxResult remove(@PathVariable Long[] categoryIds)
    {
        return toAjax(categoryService.deleteCategoryByIds(categoryIds));
    }

    @GetMapping("/optionselect")
    public AjaxResult optionselect()
    {
        return success(categoryService.selectEnabledCategoryList());
    }
}
