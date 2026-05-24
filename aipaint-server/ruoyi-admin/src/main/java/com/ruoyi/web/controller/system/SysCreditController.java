package com.ruoyi.web.controller.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.ISysUserService;

/**
 * 后台积分管理
 */
@RestController
@RequestMapping("/system/credits")
public class SysCreditController extends BaseController
{
    @Autowired
    private IAiCreditService creditService;

    @Autowired
    private ISysUserService userService;

    @PreAuthorize("@ss.hasPermi('system:user:edit')")
    @PostMapping("/new-user-gift/{userId}")
    public AjaxResult grantNewUserGift(@PathVariable Long userId)
    {
        SysUser user = userService.selectUserById(userId);
        if (StringUtils.isNull(user))
        {
            return error("用户不存在");
        }

        boolean granted = creditService.grantNewUserGiftIfNeeded(userId);
        AjaxResult ajax = success(granted ? "新人礼包已发放" : "新人礼包已发放过");
        ajax.put("granted", granted);
        ajax.put("creditBalance", creditService.getAvailableBalance(userId));
        return ajax;
    }
}
