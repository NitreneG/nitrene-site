# Nitrene Site

这是一个适合部署到 4G2c 云服务器的个人网站骨架。默认方案是：

1. 本地 Mac + Codex 开发网站内容。
2. GitHub 保存源码和部署配置。
3. GitHub Actions 在 `main` 分支更新后通过 SSH 发布到腾讯云服务器。
4. 服务器上的 Nginx 只负责稳定地对外提供静态文件。

## 项目结构

```text
.
├── README.md
├── .github/workflows/deploy.yml
├── deploy/server-check.sh
├── deploy/server-setup.md
├── deploy/nginx.personal-site.conf.template
└── src/index.html
```

## 哪些放进 GitHub

应该提交：

- `src/`：网站页面、样式、图片和前端代码。
- `.github/workflows/deploy.yml`：自动部署流程。
- `deploy/`：服务器检查脚本、Nginx 模板、部署说明。
- `README.md`：项目和运维说明。

不要提交：

- SSH 私钥，例如 `~/.ssh/id_ed25519`。
- `.env`、API key、数据库密码。
- 服务器日志、证书私钥、真实生产配置里的敏感值。
- `node_modules/`、构建缓存、系统临时文件。

## 日常开发流程

```bash
# 本地预览静态网站
python3 -m http.server 5173 -d src

# 修改 src/ 里的网站内容后
git add .
git commit -m "Update personal site"
git push origin main
```

push 到 `main` 后，GitHub Actions 会把 `src/` 发布到服务器的：

```text
/var/www/nitrene-site/current
```

服务器使用 releases 目录做原子切换：

```text
/var/www/nitrene-site/
├── current -> releases/<release-id>
├── releases/
└── shared/
```

## 首次服务器配置

先阅读并执行：

```bash
./deploy/server-check.sh <server-user>@<server-ip> -p 22
```

然后按 [deploy/server-setup.md](deploy/server-setup.md) 完成 Nginx、部署用户和 GitHub Secrets 配置。
