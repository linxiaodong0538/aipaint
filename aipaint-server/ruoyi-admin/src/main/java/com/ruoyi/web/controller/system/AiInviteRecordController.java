package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.AiInviteRecord;
import com.ruoyi.system.service.IAiInviteService;

/**
 * 邀请记录后台管理
 */
@RestController
@RequestMapping("/system/invite")
public class AiInviteRecordController extends BaseController
{
    @Autowired
    private IAiInviteService inviteService;

    @PreAuthorize("@ss.hasPermi('system:invite:list')")
    @GetMapping("/list")
    public TableDataInfo list(AiInviteRecord record)
    {
        startPage();
        List<AiInviteRecord> list = inviteService.selectInviteRecordList(record);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:invite:export')")
    @Log(title = "邀请记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AiInviteRecord record)
    {
        List<AiInviteRecord> list = inviteService.selectInviteRecordList(record);
        ExcelUtil<AiInviteRecord> util = new ExcelUtil<AiInviteRecord>(AiInviteRecord.class);
        util.exportExcel(response, list, "邀请记录数据");
    }
}
