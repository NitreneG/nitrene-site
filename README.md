# NitreneGlog

[NitreneGlog](https://nitrene.fun) 是 NitreneG 的个人博客网站，用于记录文章、项目、学习笔记和日常想法。

网站基于 [Firefly](https://github.com/CuteLeaf/Firefly) 主题开发，由 Astro 构建为静态页面，并通过 GitHub Actions 自动发布到腾讯云服务器。

## 技术信息

| 项目 | 当前配置 |
| --- | --- |
| 网站域名 | [nitrene.fun](https://nitrene.fun) |
| 主题 | Firefly 6.14.4 |
| Web 框架 | Astro 7.0.7 |
| UI 框架 | Svelte 5.56.4 |
| CSS | Tailwind CSS 4.3.2 |
| 语言与类型检查 | TypeScript 6.0.3 |
| CI 构建环境 | Node.js 22 |
| 包管理器 | pnpm 9.14.4 |
| 站内搜索 | Pagefind 1.5.2 |
| 评论系统 | 自托管 Twikoo |
| 本地开发系统 | macOS（Apple Silicon） |
| 生产环境 | 腾讯云 Ubuntu + Nginx |

生产网站不依赖常驻 Node.js 进程。Astro 在 GitHub Actions 中生成静态 `dist/`，服务器上的 Nginx 负责提供页面和静态资源。

## 本地开发

```bash
pnpm install --frozen-lockfile
pnpm dev
```

提交前可执行生产构建检查：

```bash
pnpm run build
```

推送到 `main` 后，GitHub Actions 会自动构建并发布网站。
