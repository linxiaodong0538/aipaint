package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.AiTemplateCategory;

public interface IAiTemplateCategoryService
{
    public List<AiTemplateCategory> selectCategoryList(AiTemplateCategory category);

    public List<AiTemplateCategory> selectCategoryAll();

    public List<AiTemplateCategory> selectEnabledCategoryList();

    public AiTemplateCategory selectCategoryById(Long categoryId);

    public AiTemplateCategory selectCategoryByCode(String categoryCode);

    public int insertCategory(AiTemplateCategory category);

    public int updateCategory(AiTemplateCategory category);

    public int deleteCategoryByIds(Long[] categoryIds);
}
