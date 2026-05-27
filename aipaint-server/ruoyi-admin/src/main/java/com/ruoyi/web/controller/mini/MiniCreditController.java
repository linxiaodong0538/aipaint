package com.ruoyi.web.controller.mini;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.IAiCreditService;

/**
 * 小程序积分接口
 */
@RestController
@RequestMapping("/mini/credits")
public class MiniCreditController extends BaseController
{
    @Autowired
    private IAiCreditService creditService;

    @GetMapping("/balance")
    public AjaxResult getBalance()
    {
        return success(creditService.getAvailableBalance(SecurityUtils.getUserId()));
    }

    @PostMapping("/signin")
    public AjaxResult signin()
    {
        Long userId = SecurityUtils.getUserId();
        boolean granted = creditService.grantDailySigninIfNeeded(userId);
        AjaxResult ajax = success(granted ? "签到成功，+10 PTS" : "今天已签到");
        ajax.put("granted", granted);
        ajax.put("creditBalance", creditService.getAvailableBalance(userId));
        return ajax;
    }

    @GetMapping("/records")
    public AjaxResult listRecords(Integer limit)
    {
        return success(creditService.listUserRecords(SecurityUtils.getUserId(), limit));
    }
}
