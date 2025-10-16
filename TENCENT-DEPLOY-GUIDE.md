# 🚀 ADHDER 腾讯云部署完整指南

## 📋 您的服务器信息

```
✅ 服务器IP: 122.51.20.50
✅ 服务器类型: 腾讯云Lighthouse
✅ 配置: 2核4GB
✅ 域名: adhder.app
✅ API域名: api.adhder.app
```

---

## ⚡ 快速部署（推荐）

### 第一步：准备本地配置

在执行部署脚本之前，先确保本地有完整的 `.env` 文件：

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final/website

# 检查 .env 是否存在
ls -la | grep ".env"

# 如果没有，从模板创建
cp .env.template .env
nano .env  # 或用VS Code编辑
```

**`.env` 文件应该包含：**

```env
NODE_ENV=production
PORT=3000

# MongoDB
MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/dbname

# Redis
REDIS_HOST=your-redis-host
REDIS_PORT=6379
REDIS_PASSWORD=your-redis-password

# 腾讯云 COS
TENCENT_SECRET_ID=your-tencent-secret-id
TENCENT_SECRET_KEY=your-tencent-secret-key
TENCENT_COS_BUCKET=your-bucket-name
TENCENT_COS_REGION=ap-shanghai

# 阿里云短信
ALIYUN_ACCESS_KEY_ID=your-aliyun-access-key-id
ALIYUN_ACCESS_KEY_SECRET=your-aliyun-access-key-secret
ALIYUN_SMS_TEMPLATE_CODE=SMS_XXXXXX
ALIYUN_SMS_SIGN_NAME=your-sign-name

# 安全密钥
SESSION_SECRET=your-random-session-secret
JWT_SECRET=your-random-jwt-secret
```

✅ 确认 `.env` 文件已正确配置后再继续！

---

### 第二步：运行部署脚本

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final

# 执行部署脚本
./deploy-to-tencent.sh
```

**脚本会自动完成：**
- ✅ 检查服务器连接
- ✅ 安装Node.js、PM2、Nginx、Certbot
- ✅ 克隆GitHub代码
- ✅ 上传 `.env` 配置文件
- ✅ 安装npm依赖
- ✅ 启动应用（使用PM2）
- ✅ 配置Nginx反向代理
- ✅ 申请SSL证书（可选）

---

## 🔧 手动部署步骤（备选）

如果脚本出现问题，可以手动执行以下步骤。

### 步骤1：SSH连接到服务器

```bash
ssh root@122.51.20.50
```

### 步骤2：安装环境

```bash
# 更新系统
apt-get update
apt-get upgrade -y

# 安装Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt-get install -y nodejs

# 安装PM2
npm install -g pm2

# 安装Nginx
apt-get install -y nginx

# 安装Git
apt-get install -y git

# 安装Certbot
apt-get install -y certbot python3-certbot-nginx
```

### 步骤3：克隆代码

```bash
cd /root
git clone https://github.com/YALING0327/ADHDer.git
cd ADHDer/website
```

### 步骤4：上传配置文件

**在本地执行：**

```bash
scp /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final/website/.env \
    root@122.51.20.50:/root/ADHDer/website/.env
```

### 步骤5：安装依赖

```bash
cd /root/ADHDer/website
npm install --production
```

### 步骤6：启动应用

```bash
pm2 start server.js --name adhder-api
pm2 save
pm2 startup systemd -u root --hp /root
pm2 status
pm2 logs adhder-api
```

### 步骤7：配置Nginx

```bash
sudo nano /etc/nginx/sites-available/adhder
```

### 步骤8：申请SSL证书

```bash
sudo certbot --nginx -d api.adhder.app
```

---

## 📝 域名配置

访问 https://console.dnspod.cn/ 添加以下DNS记录：

| 主机记录 | 记录类型 | 记录值 | TTL |
|---------|---------|-------|-----|
| api | A | 122.51.20.50 | 600 |
| @ | A | 122.51.20.50 | 600 |

---

## 🧪 测试部署

```bash
# 测试API
curl https://api.adhder.app/api/v3/status

# 查看日志
pm2 logs adhder-api

# 检查状态
pm2 status
```

---

## 📊 管理应用

```bash
# 重启应用
ssh root@122.51.20.50 "pm2 restart adhder-api"

# 查看日志
ssh root@122.51.20.50 "pm2 logs adhder-api"

# 停止应用
ssh root@122.51.20.50 "pm2 stop adhder-api"
```

---

## ✅ 部署完成！

您的ADHDER应用现已在腾讯云服务器上运行！

**下一步：**
1. 更新Flutter应用中的API地址为 `https://api.adhder.app`
2. 测试所有功能
3. 准备App Store上架
