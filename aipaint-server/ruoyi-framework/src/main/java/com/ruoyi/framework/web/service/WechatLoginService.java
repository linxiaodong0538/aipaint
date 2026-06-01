package com.ruoyi.framework.web.service;

import java.util.Collections;
import java.util.Date;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.http.HttpUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.IAiCreditService;
import com.ruoyi.system.service.IAiInviteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * 微信小程序登录服务
 */
@Component
public class WechatLoginService
{
    private static final String CODE_TO_SESSION_URL = "https://api.weixin.qq.com/sns/jscode2session";

    private static final String[] NICKNAMES = { "灵感画师", "像素玩家", "云朵画家", "霓虹画手", "奇想造梦", "画境行者" };

    @Value("${wechat.miniapp.appid:}")
    private String appid;

    @Value("${wechat.miniapp.secret:}")
    private String secret;

    @Value("${wechat.miniapp.tokenExpireTime:43200}")
    private int miniTokenExpireTime;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private IAiCreditService creditService;

    @Autowired
    private IAiInviteService inviteService;

    @Autowired
    private TokenService tokenService;

    /**
     * 微信 code 换取系统 token
     */
    public LoginResult login(String code, String inviteCode, String devOpenid)
    {
        if (StringUtils.isBlank(code))
        {
            throw new ServiceException("微信登录凭证不能为空");
        }
        String openid = hasWechatConfig() ? getOpenid(code) : getDevOpenid(devOpenid);
        SysUser user = userService.selectUserByOpenid(openid);
        boolean created = false;
        if (StringUtils.isNull(user))
        {
            user = createMiniUser(openid);
            created = true;
        }
        if (UserConstants.USER_DISABLE.equals(user.getStatus()))
        {
            throw new ServiceException("用户已停用，请联系管理员");
        }

        userService.updateLoginInfo(user.getUserId(), IpUtils.getIpAddr(), new Date());
        if (created)
        {
            creditService.grantNewUserGiftIfNeeded(user.getUserId());
            inviteService.handleNewUserInvite(user.getUserId(), inviteCode);
        }
        LoginUser loginUser = new LoginUser(user.getUserId(), user.getDeptId(), user, Collections.emptySet());
        loginUser.setTokenExpireMinutes(miniTokenExpireTime);
        String token = tokenService.createToken(loginUser);
        return new LoginResult(token, user);
    }

    private boolean hasWechatConfig()
    {
        return StringUtils.isNotBlank(appid) && StringUtils.isNotBlank(secret);
    }

    private String getDevOpenid(String devOpenid)
    {
        if (StringUtils.isNotBlank(devOpenid))
        {
            return devOpenid.trim();
        }
        return "dev_openid";
    }

    private String getOpenid(String code)
    {
        String url = UriComponentsBuilder.fromHttpUrl(CODE_TO_SESSION_URL)
                .queryParam("appid", appid)
                .queryParam("secret", secret)
                .queryParam("js_code", code)
                .queryParam("grant_type", "authorization_code")
                .build()
                .encode()
                .toUriString();
        String response = HttpUtils.sendGet(url);
        JSONObject json = JSON.parseObject(response);
        String openid = json.getString("openid");
        if (StringUtils.isBlank(openid))
        {
            String message = json.getString("errmsg");
            throw new ServiceException(StringUtils.isNotEmpty(message) ? message : "微信登录失败");
        }
        return openid;
    }

    private SysUser createMiniUser(String openid)
    {
        SysUser user = new SysUser();
        user.setOpenid(openid);
        user.setUserName("wx_" + buildOpenidSuffix(openid));
        user.setNickName(generateNickname());
        user.setStatus(UserConstants.NORMAL);
        user.setSex("2");
        user.setPassword(SecurityUtils.encryptPassword(openid));
        userService.registerUser(user);
        return userService.selectUserByOpenid(openid);
    }

    private String generateNickname()
    {
        int index = Math.abs((int) (System.nanoTime() % NICKNAMES.length));
        return NICKNAMES[index];
    }

    private String buildOpenidSuffix(String openid)
    {
        String cleaned = openid.replaceAll("[^A-Za-z0-9]", "");
        if (cleaned.length() > 20)
        {
            return cleaned.substring(0, 20);
        }
        return cleaned;
    }

    public static class LoginResult
    {
        private final String token;

        private final SysUser user;

        public LoginResult(String token, SysUser user)
        {
            this.token = token;
            this.user = user;
        }

        public String getToken()
        {
            return token;
        }

        public SysUser getUser()
        {
            return user;
        }
    }
}
