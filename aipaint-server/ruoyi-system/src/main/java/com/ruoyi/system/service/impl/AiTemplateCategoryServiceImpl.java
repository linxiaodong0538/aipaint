package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.AiTemplateCategory;
import com.ruoyi.system.mapper.AiTemplateCategoryMapper;
import com.ruoyi.system.service.IAiTemplateCategoryService;

@Service
public class AiTemplateCategoryServiceImpl implements IAiTemplateCategoryService
{
    @Autowired
    private AiTemplateCategoryMapper categoryMapper;

    @Override
    public List<AiTemplateCategory> selectCategoryList(AiTemplateCategory category)
    {
        return categoryMapper.selectCategoryList(category);
    }

    @Override
    public List<AiTemplateCategory> selectCategoryAll()
    {
        return categoryMapper.selectCategoryAll();
    }

    @Override
    public List<AiTemplateCategory> selectEnabledCategoryList()
    {
        return categoryMapper.selectEnabledCategoryList();
    }

    @Override
    public AiTemplateCategory selectCategoryById(Long categoryId)
    {
        return categoryMapper.selectCategoryById(categoryId);
    }

    @Override
    public AiTemplateCategory selectCategoryByCode(String categoryCode)
    {
        return categoryMapper.selectCategoryByCode(categoryCode);
    }

    @Override
    public int insertCategory(AiTemplateCategory category)
    {
        return categoryMapper.insertCategory(category);
    }

    @Override
    public int updateCategory(AiTemplateCategory category)
    {
        return categoryMapper.updateCategory(category);
    }

    @Override
    public int deleteCategoryByIds(Long[] categoryIds)
    {
        return categoryMapper.deleteCategoryByIds(categoryIds);
    }
}
