# AGENTS.md

这份说明给以后在本仓库中工作的 Codex/自动化代理使用。项目目前是一个个人网站和 Linux 运维学习仓库，既要能稳定部署，也要方便逐步扩展。

## 项目定位

- 这是一个静态个人网站骨架，当前入口是 `src/index.html`。
- 部署目标是一台云服务器，Nginx 对外提供静态文件。
- GitHub 保存源码、部署说明和 GitHub Actions；不要把服务器私钥、证书私钥、真实环境变量或日志提交进仓库。
- 这个仓库也会作为个人学习 Linux 运维、Nginx、GitHub Actions、服务器发布流程的练习场。修改时优先保持流程清楚、可解释、容易回滚。

## 当前结构

```text
.
├── AGENTS.md
├── README.md
├── .github/workflows/deploy.yml
├── deploy/
│   ├── nginx.personal-site.conf.template
│   ├── server-check.sh
│   └── server-setup.md
└── src/
    └── index.html
```

主要职责：

- `src/`：网站页面、样式、图片和前端代码。GitHub Actions 只发布这个目录。
- `.github/workflows/deploy.yml`：push 到 `main` 后通过 SSH/rsync 部署到服务器。
- `deploy/server-setup.md`：首次配置服务器、部署用户、Nginx 和 GitHub Secrets 的步骤。
- `deploy/server-check.sh`：检查本机或远程服务器基础环境。
- `deploy/nginx.personal-site.conf.template`：Nginx 站点配置模板。
- `README.md`：给人看的项目说明和日常流程。

## 常用命令

本地预览静态网站：

```bash
python3 -m http.server 5173 -d src
```

检查远程服务器：

```bash
./deploy/server-check.sh <user>@<server-ip> -p 22
```

只检查脚本在本机的输出逻辑：

```bash
./deploy/server-check.sh --local
```

目前没有 `package.json`、构建步骤或自动测试框架。除非新增前端工具链，否则不要假设需要 `npm install`、`npm run build` 或 Node 依赖。

## 开发约定

- 优先保持静态站简单可靠。没有明确需求时，不要引入复杂框架、打包器、数据库或后端服务。
- 修改网站内容时，优先编辑 `src/index.html` 或在 `src/` 下新增清晰命名的静态资源。
- 如果未来加入 CSS/JS/图片目录，建议使用 `src/assets/`、`src/styles/`、`src/scripts/` 这类直观结构。
- 页面默认面向中文读者，文案以简洁自然的中文为主；技术名词可以保留英文。
- 个人网站应该逐步体现站长特色：作品、博客、简历、项目记录、学习笔记、服务器运维日志都可以成为内容方向。
- 修改 UI 时注意移动端可读性，不要让文字溢出按钮或窄屏容器。
- 不要把真实邮箱、手机号、服务器 IP、密钥路径等敏感信息硬编码到页面或文档里；需要示例时使用占位符。

## 部署约定

- 发布源目录是 `src/`，目标目录默认是 `/var/www/personal-site/releases/<release-id>`。
- 服务器上的 `/var/www/personal-site/current` 是指向当前 release 的符号链接。
- GitHub Actions 依赖这些 Secrets：
  - `SERVER_HOST`
  - `SERVER_USER`
  - `SERVER_PORT`
  - `SERVER_PATH`
  - `SERVER_SSH_KEY`
- 部署用户建议是 `deploy`，不要默认使用 `root` 做长期自动部署。
- Nginx 配置模板中的 `server_name` 在域名备案和 DNS 完成前可以临时使用 `_`，上线后再替换成真实域名。
- 修改 `.github/workflows/deploy.yml`、Nginx 模板或服务器说明时，要同步检查 `README.md` 和 `deploy/server-setup.md` 是否需要更新。

## 安全边界

绝对不要提交：

- SSH 私钥，例如 `id_rsa`、`id_ed25519`、`personal_site_deploy`。
- `.env`、API key、数据库密码、云厂商密钥。
- 证书私钥、真实生产 Nginx 配置中的敏感字段。
- 服务器日志、备份包、压缩后的站点发布目录。

如果任务涉及真实服务器操作：

- 先说明将要执行的命令和目的。
- 优先使用只读检查命令确认状态。
- 避免直接删除服务器文件；需要清理 release、日志或配置时先给出明确风险。
- 不要修改防火墙、SSH 端口、sudoers、Nginx 站点启停等高风险设置，除非用户明确要求。

## 验证清单

修改网站页面后：

```bash
python3 -m http.server 5173 -d src
```

然后在浏览器检查：

- 首页能打开。
- 中文文案显示正常。
- 移动端宽度下没有明显遮挡或溢出。
- 链接地址不是错误占位符，或已明确保留为示例。

修改部署脚本或说明后：

```bash
bash -n deploy/server-check.sh
./deploy/server-check.sh --local
```

修改 GitHub Actions 后：

- 检查 YAML 缩进。
- 确认仍然只上传 `src/`。
- 确认不会输出私钥或 Secrets。
- 确认 release 创建、rsync 上传、`current` 切换、Nginx reload 的顺序没有被破坏。

## Git 协作

- 当前目标分支是 `main`。
- 新功能或较大改动可以使用 `codex/<short-topic>` 分支。
- 提交前查看 `git status --short`，不要误提交本机临时文件或秘密文件。
- 不要回滚用户已有改动；如果看到与任务无关的未提交内容，保留它们。

## 近期路线图

用户当前进度：

- 已开通云服务器。
- 已完成本项目的基础文件。
- 正在申请域名、申请备案，并准备连接 GitHub。

后续方向：

- 通过这个网站和服务器学习 Linux 运维。
- 完善个人网站主题、视觉风格和内容结构。
- 加入更有个人特色的内容，例如项目记录、学习笔记、作品集、博客、服务器运维日志。
