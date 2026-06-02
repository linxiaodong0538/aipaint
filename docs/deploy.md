# 自动发布配置

这个流程只发布后台管理端和后端服务，不处理小程序。

后端会在服务器本地拉取源码并用 Maven 打包，避免从 GitHub Actions 跨境上传大 jar。前端后台仍在 GitHub Actions 构建，然后上传较小的压缩包到服务器。

## GitHub Secrets

在 GitHub 仓库的 `Settings -> Secrets and variables -> Actions -> Repository secrets` 添加：

| Secret | 说明 | 示例 |
| --- | --- | --- |
| `DEPLOY_HOST` | 服务器 IP 或域名 | `1.2.3.4` |
| `DEPLOY_PORT` | SSH 端口 | `22` |
| `DEPLOY_USER` | SSH 用户 | `deploy` |
| `DEPLOY_SSH_PRIVATE_KEY` | SSH 私钥内容 | `-----BEGIN OPENSSH PRIVATE KEY-----...` |
| `SERVER_RELEASE_PATH` | 上传临时目录 | `/opt/aipaint/releases` |
| `SERVER_DEPLOY_PATH` | 后端 jar 部署目录 | `/opt/aipaint/server` |
| `ADMIN_DEPLOY_PATH` | 管理端静态资源目录 | `/var/www/aipaint-admin` |
| `SERVER_SERVICE_NAME` | systemd 服务名 | `aipaint-server` |
| `DEPLOY_REPO_URL` | 服务器拉源码的 Git 地址，推荐填 Gitee 地址 | `https://gitee.com/xxx/aipaint.git` |

## 服务器目录

```bash
sudo mkdir -p /opt/aipaint/releases /opt/aipaint/server /var/www/aipaint-admin /www/wwwroot/aipaint-source
sudo chown -R deploy:deploy /opt/aipaint /var/www/aipaint-admin /www/wwwroot/aipaint-source
```

服务器需要安装 Git、JDK 17 和 Maven。当前 workflow 不要求服务器安装 Node.js 或 pnpm。

## 后端 systemd 服务

创建 `/etc/systemd/system/aipaint-server.service`：

```ini
[Unit]
Description=AIPaint Server
After=network.target

[Service]
User=deploy
WorkingDirectory=/opt/aipaint/server
ExecStart=/usr/bin/java -jar /opt/aipaint/server/aipaint-server.jar
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

启用服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable aipaint-server
```

## 部署用户

当前 workflow 按 `root` 用户部署，直接执行 `systemctl` 和 `nginx` 命令。

如果后续改成普通用户部署，需要给该用户配置免密 sudo 权限，或把 workflow 中的服务重启命令调整为服务器允许的命令。

## 触发发布

推送到 `main` 分支会自动发布：

```bash
git push origin main
```

也可以在 GitHub Actions 页面手动点 `Run workflow`。

## 备注

`aipaint-admin` 当前仓库里的 `pnpm-lock.yaml` 是旧版 lockfile，workflow 里固定使用 `pnpm@8` 来保持兼容。
