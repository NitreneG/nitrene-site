# Server Setup

这份文档只做服务器的一次性配置。完成以后，日常更新网站只需要在本地修改 Astro 源码并 push 到 GitHub。

下面示例默认服务器是 Ubuntu/Debian 系，部署目录是 `/var/www/nitrene-site`。如果只是个人服务器，也可以直接使用已有的 `nitrene` 用户发布；更规范的长期方案是创建专门的 `deploy` 用户。

## 1. 本地先检查服务器

```bash
chmod +x deploy/server-check.sh
./deploy/server-check.sh <user>@<server-ip> -p 22
```

如果你的 SSH 端口不是 22，把 `-p 22` 改成真实端口。

## 2. 安装基础包

SSH 登录服务器后执行：

```bash
sudo apt update
sudo apt install -y nginx git rsync curl ca-certificates ufw
sudo systemctl enable --now nginx
```

如果你已经装好 Docker，可以先不动 Docker。这个 Astro 方案会在 GitHub Actions 里构建成静态 `dist/`，服务器不需要安装 Node、pnpm 或 Astro；Nginx 只负责托管构建产物。

## 3. 准备部署用户和目录

如果你先用已有的 `nitrene` 用户发布，可以直接创建目录并授权给 `nitrene`：

```bash
sudo mkdir -p /var/www/nitrene-site/releases
sudo mkdir -p /var/www/nitrene-site/shared

sudo chown -R nitrene:www-data /var/www/nitrene-site
sudo chmod -R 755 /var/www/nitrene-site
```

如果你想使用更独立的发布用户，再创建 `deploy`：

```bash
sudo adduser deploy
sudo usermod -aG www-data deploy

sudo mkdir -p /var/www/nitrene-site/releases
sudo mkdir -p /var/www/nitrene-site/shared

sudo chown -R deploy:www-data /var/www/nitrene-site
sudo chmod -R 755 /var/www/nitrene-site
```

`current` 不需要手动创建成目录。GitHub Actions 第一次发布时会把它创建成指向某个 release 的符号链接。

不要长期用 root 做自动部署。

## 4. 配置 GitHub Actions 的 SSH key

在你的 Mac 上生成一把专门给 GitHub Actions 用的部署 key：

```bash
ssh-keygen -t ed25519 -C "github-actions-personal-site" -f ~/.ssh/personal_site_deploy
```

把公钥放到服务器。下面以 `deploy` 为例；如果你使用 `nitrene` 发布，就把命令里的 `deploy` 换成 `nitrene`：

```bash
ssh-copy-id -i ~/.ssh/personal_site_deploy.pub deploy@<server-ip>
```

如果没有 `ssh-copy-id`，就在服务器上手动追加：

```bash
sudo mkdir -p /home/deploy/.ssh
sudo nano /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
sudo chmod 600 /home/deploy/.ssh/authorized_keys
```

然后在 GitHub 仓库中添加 Secrets：

```text
SERVER_HOST       你的服务器公网 IP 或域名
SERVER_USER       nitrene 或 deploy
SERVER_PORT       22
SERVER_PATH       /var/www/nitrene-site
SERVER_SSH_KEY    ~/.ssh/personal_site_deploy 的私钥内容
```

`SERVER_SSH_KEY` 应该是私钥全文，不要提交到 GitHub 仓库文件里。

## 5. 配置 Nginx 站点

在服务器创建站点配置：

```bash
sudo nano /etc/nginx/sites-available/personal-site
```

复制 `deploy/nginx.personal-site.conf.template` 的内容进去，并替换：

```text
server_name example.com www.example.com;
```

如果域名还没解析好，可以先用：

```text
server_name _;
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/personal-site /etc/nginx/sites-enabled/personal-site
sudo nginx -t
sudo systemctl reload nginx
```

如果默认站点占用了同一个域名或 `_`，可以禁用默认站点：

```bash
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

## 6. 防火墙和腾讯云安全组

服务器内的 UFW 可以这样设置：

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw status
```

腾讯云控制台的安全组也需要放行：

```text
SSH: 你的 SSH 端口
HTTP: 80
HTTPS: 443
```

## 7. 第一次发布

本地初始化 git，并推到 GitHub：

```bash
git init
git add .
git commit -m "Initial personal site deploy setup"
git branch -M main
git remote add origin git@github.com:<your-name>/<your-repo>.git
git push -u origin main
```

GitHub Actions 跑完后，再检查服务器：

```bash
./deploy/server-check.sh deploy@<server-ip> -p 22
```

## 8. 以后经常改哪里

经常改：

- `src/content/`：文章、动态、页面正文
- `src/config/`：站点配置、导航、友链、相册、评论等
- `src/assets/`：需要 Astro 处理和优化的图片
- `public/`：直接原样发布的静态资源
- `package.json`：只在需要调整构建脚本或依赖时修改

偶尔改：

- `.github/workflows/deploy.yml`
- `deploy/nginx.personal-site.conf.template`
- `deploy/server-setup.md`

基本不改，只留在服务器：

- `/etc/nginx/sites-available/personal-site`
- `/var/log/nginx/*.log`
- `/etc/letsencrypt/`
- `/home/deploy/.ssh/authorized_keys`
- `/var/www/nitrene-site/releases`
