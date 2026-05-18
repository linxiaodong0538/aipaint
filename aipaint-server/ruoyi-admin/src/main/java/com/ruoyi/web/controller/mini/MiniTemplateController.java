package com.ruoyi.web.controller.mini;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.service.IAiTemplateService;

/**
 * 小程序模板公开接口
 */
@RestController
@RequestMapping("/mini/templates")
public class MiniTemplateController extends BaseController
{
    @Autowired
    private IAiTemplateService templateService;

    @GetMapping("/categories")
    public AjaxResult categories()
    {
        return success(templateService.selectEnabledCategories());
    }

    @GetMapping("/list")
    public AjaxResult list(AiTemplate template)
    {
        List<AiTemplate> list = templateService.selectEnabledTemplateList(template);
        return success(list);
    }

    @GetMapping("/{templateId}")
    public AjaxResult getInfo(@PathVariable Long templateId)
    {
        AiTemplate template = templateService.selectEnabledTemplateById(templateId);
        return template == null ? error("模板不存在或已下架") : success(template);
    }
}
