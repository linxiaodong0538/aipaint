package com.ruoyi.web.controller.mini;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.IAiInviteService;

/**
 * 小程序邀请奖励接口
 */
@RestController
@RequestMapping("/mini/invite")
public class MiniInviteController extends BaseController
{
    @Autowired
    private IAiInviteService inviteService;

    @GetMapping("/stats")
    public AjaxResult stats()
    {
        return success(inviteService.getInviteStats(SecurityUtils.getUserId()));
    }
}
