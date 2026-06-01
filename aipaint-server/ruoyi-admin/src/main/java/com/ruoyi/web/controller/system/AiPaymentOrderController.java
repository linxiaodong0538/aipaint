package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.AiPaymentOrder;
import com.ruoyi.system.service.IAiPaymentService;

/**
 * 充值订单后台管理
 */
@RestController
@RequestMapping("/system/payment")
public class AiPaymentOrderController extends BaseController
{
    @Autowired
    private IAiPaymentService paymentService;

    @PreAuthorize("@ss.hasPermi('system:payment:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiPaymentOrder order)
    {
        startPage();
        List<AiPaymentOrder> list = paymentService.selectPaymentOrderList(order);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:payment:export')")
    @Log(title = "充值订单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiPaymentOrder order)
    {
        List<AiPaymentOrder> list = paymentService.selectPaymentOrderList(order);
        ExcelUtil<AiPaymentOrder> util = new ExcelUtil<AiPaymentOrder>(AiPaymentOrder.class);
        util.exportExcel(response, list, "充值订单数据");
    }

    @PreAuthorize("@ss.hasPermi('system:payment:sync')")
    @Log(title = "充值订单", businessType = BusinessType.UPDATE)
    @PostMapping("/sync/{outTradeNo}")
    public AjaxResult sync(@PathVariable String outTradeNo)
    {
        AiPaymentOrder order = paymentService.syncWechatPayment(outTradeNo);
        return success(order);
    }
}
