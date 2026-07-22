# Nitrene Site

这是 NitreneGlog 的 Astro 个人网站源码仓库。默认方案是：

1. 本地 Mac + Codex 开发网站内容。
2. GitHub 保存 Astro 源码、内容、配置和部署流程。
3. GitHub Actions 在 `main` 分支更新后安装依赖并运行 `pnpm run build`。
4. Actions 把生成的 `dist/` 通过 SSH/rsync 发布到腾讯云服务器。
5. 服务器上的 Nginx 只负责稳定地对外提供静态文件。

## 项目结构

```text
.
├── README.md
├── package.json
├── pnpm-lock.yaml
├── astro.config.mjs
├── .github/workflows/deploy.yml
├── deploy/server-check.sh
├── deploy/server-setup.md
├── deploy/nginx.personal-site.conf.template
├── public/
├── scripts/
└── src/
```

## 哪些放进 GitHub

应该提交：

- `src/`：Astro 页面、组件、配置、文章、样式和前端代码。
- `public/`：不需要 Astro 处理的静态资源。
- `scripts/`：构建辅助脚本。
- `package.json` / `pnpm-lock.yaml`：前端依赖和构建脚本。
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
# 第一次拉取后安装依赖
pnpm install --frozen-lockfile

# 本地开发预览
pnpm dev

# 生产构建验证
pnpm run build

# 修改网站内容后
git add .
git commit -m "Update personal site"
git push origin main
```

push 到 `main` 后，GitHub Actions 会构建 Astro 站点，并把 `dist/` 发布到服务器的：

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
