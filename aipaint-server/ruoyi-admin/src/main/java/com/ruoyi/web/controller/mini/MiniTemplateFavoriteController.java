package com.ruoyi.web.controller.mini;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.AiTemplate;
import com.ruoyi.system.service.IAiTemplateFavoriteService;
import com.ruoyi.system.service.IAiTemplateService;

/**
 * 小程序模板收藏接口
 */
@RestController
@RequestMapping("/mini/template-favorites")
public class MiniTemplateFavoriteController extends BaseController
{
    @Autowired
    private IAiTemplateFavoriteService favoriteService;

    @Autowired
    private IAiTemplateService templateService;

    @GetMapping("/status/{templateId}")
    public AjaxResult status(@PathVariable Long templateId)
    {
        return success(favoriteResult(favoriteService.isFavorited(SecurityUtils.getUserId(), templateId)));
    }

    @PostMapping("/{templateId}")
    public AjaxResult favorite(@PathVariable Long templateId)
    {
        return success(favoriteResult(favoriteService.favorite(SecurityUtils.getUserId(), templateId)));
    }

    @DeleteMapping("/{templateId}")
    public AjaxResult unfavorite(@PathVariable Long templateId)
    {
        return success(favoriteResult(favoriteService.unfavorite(SecurityUtils.getUserId(), templateId)));
    }

    @GetMapping("/list")
    public TableDataInfo list()
    {
        startPage();
        List<AiTemplate> list = templateService.selectFavoriteTemplateList(SecurityUtils.getUserId());
        return getDataTable(list);
    }

    private Map<String, Boolean> favoriteResult(boolean favorited)
    {
        Map<String, Boolean> result = new HashMap<>();
        result.put("favorited", favorited);
        return result;
    }
}
