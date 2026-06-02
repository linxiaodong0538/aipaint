# 自动发布配置

这个流程只发布后台管理端和后端服务，不处理小程序。

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

## 服务器目录

```bash
sudo mkdir -p /opt/aipaint/releases /opt/aipaint/server /var/www/aipaint-admin
sudo chown -R deploy:deploy /opt/aipaint /var/www/aipaint-admin
```

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
