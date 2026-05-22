package com.ruoyi.web.controller.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.web.service.image.AiImageAdminConfig;
import com.ruoyi.web.service.image.AiImageConfigService;

/**
 * AI 生图配置管理
 */
@RestController
@RequestMapping("/system/ai-image-config")
public class AiImageConfigController extends BaseController
{
    @Autowired
    private AiImageConfigService aiImageConfigService;

    @PreAuthorize("@ss.hasPermi('system:aiImageConfig:query')")
    @GetMapping
    public AjaxResult getConfig()
    {
        return success(aiImageConfigService.getAdminConfig());
    }

    @PreAuthorize("@ss.hasPermi('system:aiImageConfig:edit')")
    @Log(title = "AI生图配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult updateConfig(@RequestBody AiImageAdminConfig config)
    {
        aiImageConfigService.saveAdminConfig(config, getUsername());
        return success();
    }
}
