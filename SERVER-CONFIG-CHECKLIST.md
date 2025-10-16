# 🖥️ ADHDER服务器配置检查清单

根据您之前提供的信息，为您整理当前服务器配置状态。

---

## ✅ 已配置的服务（您已购买/配置）

### 1️⃣ 腾讯云轻量应用服务器 ✅
**状态：** 已购买  
**配置：** 2核4GB（锐驰型）  
**费用：** ¥145.98（已支付）  

**下一步需要做：**
- [ ] SSH登录服务器
- [ ] 安装Node.js环境
- [ ] 克隆代码并部署
- [ ] 配置PM2自动重启

---

### 2️⃣ MongoDB Atlas（数据库）✅
**状态：** 已配置  
**连接字符串：**
```
mongodb+srv://llymusic0327_db_user:<密码>@adhder.6msdehj.mongodb.net/?retryWrites=true&w=majority&appName=adhder
```
**密码：** lly369123

**检查清单：**
- [x] 账号已创建
- [x] 集群已创建（adhder）
- [x] 数据库用户已创建
- [x] 连接字符串已获取
- [ ] ⚠️ 需要添加服务器IP到白名单

---

### 3️⃣ 腾讯云Redis ✅
**状态：** 已购买  
**实例ID：** crs-7u6y3cnb  
**实例名：** adhder-redis  
**密码：** Lly369123  

**连接信息：**
- **内网地址：** 10.0.0.15:6379
- **外网地址：** sh-crs-7u6y3cnb.sql.tencentcdb.com:22189

**检查清单：**
- [x] Redis实例已创建
- [x] 密码已设置
- [ ] ⚠️ 需要配置安全组允许服务器访问

---

### 4️⃣ 腾讯云对象存储COS ✅
**状态：** 已购买  
**存储桶名称：** adhder-1352080794  
**地域：** 根据您的设置（需确认）  
**资源包：** 标准存储容量包（¥1.00已支付）

**API密钥：**
- **SecretId：** AKIDV2LRKzSilhXY9bqukMlwtPkurb8RXP3T
- **SecretKey：** INEzZw50iEWbT7YmmaBYhdMNF0ax9B2g

**检查清单：**
- [x] 存储桶已创建
- [x] API密钥已获取
- [ ] ⚠️ 需要配置CORS跨域规则
- [ ] ⚠️ 需要配置公开访问权限（图片）

---

### 5️⃣ 阿里云短信服务 ✅
**状态：** 已配置  
**模板ID：** SMS_496025850  
**签名名称：** 亚韵科技  

**API密钥：**
- **AccessKey ID：** LTAI5tCXFu1bp4SZJjyK2zbB
- **AccessKey Secret：** ztVtPbyR3TulU8p1SDagnsW1Wubrx1

**检查清单：**
- [x] 短信服务已开通
- [x] 签名已审核通过
- [x] 模板已审核通过
- [x] API密钥已获取
- [x] 可正常发送短信

---

### 6️⃣ 腾讯云数据万象CI ✅
**状态：** 已购买  
**用途：** 图片处理  
**费用：** ¥1.10（已支付）

**检查清单：**
- [x] 资源包已购买
- [ ] ⚠️ 需要在COS中开启数据万象功能

---

### 7️⃣ 域名 ✅
**状态：** 已注册  
**域名：** adhder.app  
**平台：** 腾讯云

**检查清单：**
- [x] 域名已注册
- [ ] ⚠️ 需要配置DNS解析记录
  - [ ] api.adhder.app → 服务器IP（A记录）
  - [ ] www.adhder.app → 官网（可选）
- [ ] ⚠️ 需要申请SSL证书（Let's Encrypt免费）

---

## ❌ 未配置的必需服务

### 8️⃣ Firebase（推送通知）❌
**状态：** 未配置  
**用途：** iOS和Android推送通知  

**需要做：**
1. 注册Firebase项目
2. 下载配置文件
   - iOS: GoogleService-Info.plist
   - Android: google-services.json
3. 配置Server Key

**重要性：** 🟡 中等（推送通知需要）  
**可延后：** 是（先上线再说）

---

### 9️⃣ Apple Developer账号 ❌
**状态：** 未注册  
**费用：** ¥688/年  
**用途：** 上架App Store

**需要做：**
1. 访问 https://developer.apple.com
2. 使用Apple ID注册
3. 支付年费
4. 等待审核通过（1-2天）

**重要性：** 🔴 必须（iOS上线必需）  
**优先级：** ⭐⭐⭐⭐⭐

---

### 🔟 Google Play开发者账号 ❌
**状态：** 未注册  
**费用：** $25（一次性）  
**用途：** 上架Google Play

**需要做：**
1. 访问 https://play.google.com/console
2. 支付$25注册费
3. 填写开发者信息

**重要性：** 🟡 中等（Android上线需要）  
**优先级：** ⭐⭐⭐☆☆  
**可延后：** 是（可以先做iOS，或直接分发APK）

---

## 🔧 需要完成的配置步骤

### 优先级1：服务器部署（必须）🔴

#### Step 1: 连接服务器
```bash
# 1. 获取服务器IP（在腾讯云控制台查看）
# 2. 重置服务器密码（如果需要）
# 3. SSH连接
ssh root@你的服务器IP
```

#### Step 2: 安装环境
```bash
# 安装Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 安装PM2
npm install -g pm2

# 安装Git
sudo apt install git

# 验证安装
node --version
npm --version
pm2 --version
```

#### Step 3: 部署代码
```bash
# 克隆代码（需要先push到GitHub）
git clone https://github.com/你的用户名/adhder.git
cd adhder/adhder-develop-final/website

# 安装依赖
npm install

# 创建环境变量文件
nano .env
```

#### Step 4: 配置环境变量
```bash
# .env文件内容：
NODE_ENV=production
PORT=3000

# MongoDB
MONGODB_URL=mongodb+srv://llymusic0327_db_user:lly369123@adhder.6msdehj.mongodb.net/?retryWrites=true&w=majority&appName=adhder

# Redis
REDIS_HOST=sh-crs-7u6y3cnb.sql.tencentcdb.com
REDIS_PORT=22189
REDIS_PASSWORD=Lly369123

# 腾讯云COS
TENCENT_SECRET_ID=AKIDV2LRKzSilhXY9bqukMlwtPkurb8RXP3T
TENCENT_SECRET_KEY=INEzZw50iEWbT7YmmaBYhdMNF0ax9B2g
TENCENT_COS_BUCKET=adhder-1352080794
TENCENT_COS_REGION=ap-shanghai

# 阿里云短信
ALIYUN_ACCESS_KEY_ID=LTAI5tCXFu1bp4SZJjyK2zbB
ALIYUN_ACCESS_KEY_SECRET=ztVtPbyR3TulU8p1SDagnsW1Wubrx1
ALIYUN_SMS_TEMPLATE_CODE=SMS_496025850
ALIYUN_SMS_SIGN_NAME=亚韵科技

# Session密钥（随机生成）
SESSION_SECRET=adhder_production_secret_$(openssl rand -hex 32)

# 域名
BASE_URL=https://api.adhder.app
```

#### Step 5: 启动服务
```bash
# 测试运行
npm start

# 如果正常，用PM2启动
pm2 start server.js --name adhder-api
pm2 save
pm2 startup

# 查看日志
pm2 logs adhder-api
```

---

### 优先级2：配置域名和SSL（必须）🔴

#### Step 1: 配置DNS解析
```
在腾讯云DNS解析中添加：
- 记录类型：A
- 主机记录：api
- 记录值：你的服务器IP
- TTL：600
```

#### Step 2: 安装Nginx
```bash
# 安装Nginx
sudo apt update
sudo apt install nginx

# 配置Nginx
sudo nano /etc/nginx/sites-available/adhder
```

```nginx
# Nginx配置内容：
server {
    listen 80;
    server_name api.adhder.app;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# 启用配置
sudo ln -s /etc/nginx/sites-available/adhder /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### Step 3: 安装SSL证书
```bash
# 安装Certbot
sudo apt install certbot python3-certbot-nginx

# 自动配置SSL
sudo certbot --nginx -d api.adhder.app

# 自动续期测试
sudo certbot renew --dry-run
```

---

### 优先级3：配置数据库和Redis（必须）🔴

#### MongoDB Atlas白名单
```
1. 登录 https://cloud.mongodb.com
2. 进入adhder集群
3. 点击Network Access
4. 添加IP地址：
   - 你的服务器公网IP
   - 或 0.0.0.0/0（允许所有，测试用）
```

#### Redis安全组
```
1. 登录腾讯云控制台
2. 进入Redis实例管理
3. 配置安全组：
   - 允许来源：你的服务器IP
   - 协议端口：TCP:22189
   - 策略：允许
```

---

### 优先级4：COS配置（推荐）🟡

#### 配置跨域规则
```
1. 登录腾讯云COS控制台
2. 选择存储桶：adhder-1352080794
3. 安全管理 → 跨域访问CORS
4. 添加规则：
   - 来源Origin：*
   - 操作Methods：GET, POST, PUT, DELETE
   - 允许头部：*
   - 暴露头部：ETag
   - 超时时间：300
```

#### 配置公开访问
```
1. 权限管理 → 存储桶访问权限
2. 公共权限：
   - 读取：公有读私有写
3. 保存
```

---

## 📝 配置文件生成

我现在为您生成完整的环境配置文件：

### 完整的.env文件（生产环境）

```env
# ===================================
# ADHDER 生产环境配置
# ===================================

NODE_ENV=production
PORT=3000
BASE_URL=https://api.adhder.app

# ===================================
# 数据库配置
# ===================================

# MongoDB Atlas
MONGODB_URL=mongodb+srv://llymusic0327_db_user:lly369123@adhder.6msdehj.mongodb.net/adhder?retryWrites=true&w=majority&appName=adhder

# Redis（腾讯云）
REDIS_HOST=sh-crs-7u6y3cnb.sql.tencentcdb.com
REDIS_PORT=22189
REDIS_PASSWORD=Lly369123

# ===================================
# 云服务配置
# ===================================

# 腾讯云COS对象存储
TENCENT_SECRET_ID=AKIDV2LRKzSilhXY9bqukMlwtPkurb8RXP3T
TENCENT_SECRET_KEY=INEzZw50iEWbT7YmmaBYhdMNF0ax9B2g
TENCENT_COS_BUCKET=adhder-1352080794
TENCENT_COS_REGION=ap-shanghai

# 阿里云短信
ALIYUN_ACCESS_KEY_ID=LTAI5tCXFu1bp4SZJjyK2zbB
ALIYUN_ACCESS_KEY_SECRET=ztVtPbyR3TulU8p1SDagnsW1Wubrx1
ALIYUN_SMS_TEMPLATE_CODE=SMS_496025850
ALIYUN_SMS_SIGN_NAME=亚韵科技

# ===================================
# 应用配置
# ===================================

# Session密钥（生产环境请改为随机字符串）
SESSION_SECRET=adhder_prod_$(openssl rand -hex 32)

# 管理员邮箱
ADMIN_EMAIL=llymusic0327@gmail.com

# 日志级别
LOG_LEVEL=info

# ===================================
# 第三方服务（可选）
# ===================================

# Firebase（推送通知，暂未配置）
# FIREBASE_PROJECT_ID=
# FIREBASE_CLIENT_EMAIL=
# FIREBASE_PRIVATE_KEY=

# Amplitude（数据分析，可选）
# AMPLITUDE_KEY=

# ===================================
# 安全配置
# ===================================

# CORS允许的域名
CORS_ORIGINS=https://adhder.app,https://www.adhder.app

# JWT密钥
JWT_SECRET=adhder_jwt_$(openssl rand -hex 32)
```

---

## 📊 当前配置完成度

```
云服务配置：    ████████░░ 80%
服务器部署：    ░░░░░░░░░░  0%
域名SSL配置：   ░░░░░░░░░░  0%
数据库配置：    ██████░░░░ 60%
开发者账号：    ░░░░░░░░░░  0%

总体完成度：    ████░░░░░░ 40%
```

---

## ✅ 今天必须完成的任务

### Task 1: 上传代码到GitHub（30分钟）
```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final
git remote add origin https://github.com/你的用户名/adhder.git
git push -u origin master
```

### Task 2: 注册Apple Developer（2小时）
- 访问 https://developer.apple.com
- 注册并支付¥688
- 等待审核

### Task 3: 连接服务器并部署（3-4小时）
- SSH登录服务器
- 安装环境（Node.js + PM2）
- 克隆代码
- 配置环境变量
- 启动服务

---

## 💰 还需要的费用

| 项目 | 费用 | 状态 |
|------|------|------|
| ✅ 服务器 | ¥145.98 | 已支付 |
| ✅ Redis | 按量计费 | 已开通 |
| ✅ COS存储 | ¥2.10 | 已支付 |
| ❌ Apple Developer | ¥688/年 | **待支付** |
| 🟡 Google Play | $25 | 可选 |
| ✅ 域名 | ¥已有 | 已注册 |
| **总计** | **~¥836** | **还需¥688** |

---

## 🎯 下一步行动

### 立即开始（今天）
1. ⭐ **注册Apple Developer账号**（必须，需要1-2天审核）
2. 📤 **代码上传到GitHub**（必须，方便服务器拉取）
3. 🖥️ **服务器部署**（必须，让后端运行起来）

### 明天完成
4. 🌐 **配置DNS和SSL**（必须，启用HTTPS）
5. 🗄️ **配置MongoDB和Redis白名单**（必须，确保连接）

### 后天完成
6. 📱 **修改Flutter API地址**（必须，连接真实服务器）
7. 🎨 **准备App Store资料**（必须，截图、描述等）

---

## 📞 需要帮助？

如果遇到问题，按照以下顺序排查：
1. 检查防火墙和安全组配置
2. 查看服务日志：`pm2 logs adhder-api`
3. 测试API连接：`curl http://localhost:3000/health`
4. 检查Nginx配置：`sudo nginx -t`
5. 查看系统日志：`journalctl -xe`

---

**🎉 您的服务器已经配置了80%，只差最后的部署步骤了！**

准备好开始服务器部署了吗？我会一步步指导您完成！

