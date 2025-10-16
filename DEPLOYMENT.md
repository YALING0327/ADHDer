# 🚀 ADHDER 部署指南

## ✅ 安全检查完成

您的代码已安全上传到GitHub：https://github.com/YALING0327/ADHDer

**✅ 已确认：**
- Git历史已清理，无敏感信息
- 所有密钥和密码已从代码中移除  
- `.gitignore` 已配置，防止`.env`文件被提交
- `.env.template` 已提供作为配置参考

---

## 📋 部署前准备清单

### 1. 必需的云服务账号

- [x] MongoDB Atlas（已配置）
- [x] 阿里云账号（短信服务，已配置）
- [x] 腾讯云账号（COS存储，已配置）
- [ ] 服务器（腾讯云Lighthouse或Railway/Render）

### 2. 您已有的配置信息

**⚠️ 这些信息请保密，使用您自己的真实配置：**

```
MongoDB: 使用您的MongoDB Atlas连接字符串
Redis: 使用您的Redis实例信息
腾讯云COS: 使用您的腾讯云API密钥
阿里云SMS: 使用您的阿里云AccessKey
```

**获取这些配置信息：**
- MongoDB: https://cloud.mongodb.com → 选择集群 → Connect
- Redis: 腾讯云控制台 → 云数据库Redis
- 腾讯云API密钥: 腾讯云控制台 → 访问管理 → 访问密钥
- 阿里云AccessKey: 阿里云控制台 → RAM访问控制 → 用户 → 访问密钥

---

## 🎯 部署方案选择

### 方案A：Railway（推荐-最简单）🥇

**优点：**
- ✅ 完全免费（5$/月额度）
- ✅ 自动从GitHub部署
- ✅ 自动HTTPS
- ✅ 无需服务器管理

**步骤：**

1. **访问Railway**
   ```
   https://railway.app
   ```

2. **连接GitHub**
   - 点击 "Start a New Project"
   - 选择 "Deploy from GitHub repo"
   - 授权并选择 `YALING0327/ADHDer`

3. **配置环境变量**
   
   在Railway项目设置中添加：
   
   ```env
   NODE_ENV=production
   PORT=3000
   
   MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/dbname
   
   REDIS_HOST=your-redis-host
   REDIS_PORT=6379
   REDIS_PASSWORD=your-redis-password
   
   TENCENT_SECRET_ID=your-tencent-secret-id
   TENCENT_SECRET_KEY=your-tencent-secret-key
   TENCENT_COS_BUCKET=your-bucket-name
   TENCENT_COS_REGION=ap-shanghai
   
   ALIYUN_ACCESS_KEY_ID=your-aliyun-access-key-id
   ALIYUN_ACCESS_KEY_SECRET=your-aliyun-access-key-secret
   ALIYUN_SMS_TEMPLATE_CODE=SMS_XXXXXX
   ALIYUN_SMS_SIGN_NAME=your-sign-name
   
   SESSION_SECRET=your-random-session-secret
   JWT_SECRET=your-random-jwt-secret
   ```

4. **配置启动命令**
   
   在 `railway.toml` 或 Settings 中设置：
   ```
   Build Command: cd website && npm install
   Start Command: cd website && npm start
   ```

5. **获取域名**
   
   部署成功后，Railway会自动分配一个域名：
   ```
   https://adhder-production.up.railway.app
   ```

6. **配置MongoDB白名单**
   
   - 登录MongoDB Atlas
   - Network Access → Add IP Address
   - 选择 "Allow access from anywhere" (0.0.0.0/0)
   - 或添加Railway的出口IP

---

### 方案B：Render（备选）🥈

**优点：**
- ✅ 完全免费（Free tier）
- ✅ 自动从GitHub部署
- ✅ 自动HTTPS

**缺点：**
- ⚠️ Free tier会在15分钟不活动后休眠

**步骤：**

1. **访问Render**
   ```
   https://render.com
   ```

2. **创建Web Service**
   - New → Web Service
   - 连接GitHub仓库: `YALING0327/ADHDer`
   - Root Directory: `website`
   - Environment: Node
   - Build Command: `npm install`
   - Start Command: `npm start`

3. **添加环境变量**（同Railway）

4. **选择Free Plan**

---

### 方案C：腾讯云Lighthouse（需付费）💰

**优点：**
- ✅ 中国大陆访问快
- ✅ 完全控制权限

**费用：** ¥145.98（已购买）

**步骤：**

1. **SSH连接服务器**
   ```bash
   ssh root@your-server-ip
   ```

2. **安装Node.js**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   npm install -g pm2
   ```

3. **克隆代码**
   ```bash
   git clone https://github.com/YALING0327/ADHDer.git
   cd ADHDer/website
   npm install
   ```

4. **配置环境变量**
   ```bash
   nano .env
   # 粘贴上面的环境变量配置
   ```

5. **启动服务**
   ```bash
   pm2 start server.js --name adhder-api
   pm2 save
   pm2 startup
   ```

6. **配置Nginx和SSL**
   ```bash
   sudo apt install nginx certbot python3-certbot-nginx
   # 配置Nginx反向代理
   # 申请SSL证书
   ```

---

## 📱 连接Flutter应用到后端

### 1. 获取API域名

部署完成后，您会得到一个域名，例如：
- Railway: `https://adhder-production.up.railway.app`
- Render: `https://adhder-api.onrender.com`  
- 自建: `https://api.adhder.app`

### 2. 修改Flutter配置

编辑 `adhder_flutter/lib/config/api_config.dart`：

```dart
class ApiConfig {
  // 修改为您的实际API地址
  static const String baseUrl = 'https://adhder-production.up.railway.app';
  
  // API端点
  static const String authLogin = '/api/v3/user/auth/local/login';
  static const String authRegister = '/api/v3/user/auth/local/register';
  static const String sendSmsCode = '/api/v4/sms/send-code';
  static const String verifySmsLogin = '/api/v4/sms/verify-and-login';
  // ... 其他配置保持不变
}
```

### 3. 重新编译应用

```bash
cd adhder_flutter
flutter run
```

---

## 🧪 测试部署是否成功

### 1. 测试API健康检查

```bash
curl https://your-api-domain.com/api/v3/status
```

应该返回：
```json
{
  "status": "up"
}
```

### 2. 测试短信发送

在Flutter应用中：
1. 打开手机号登录页面
2. 输入手机号：13800138000（您的真实手机号）
3. 点击"获取验证码"
4. 应该收到短信

### 3. 测试登录流程

1. 输入收到的验证码
2. 点击登录
3. 应该成功进入主页

---

## ⚙️ 配置MongoDB和Redis

### MongoDB Atlas白名单

1. 登录 https://cloud.mongodb.com
2. 选择 `adhder` 集群
3. 点击 Network Access
4. Add IP Address
5. 选择 "Allow access from anywhere" (0.0.0.0/0)
   或添加服务器的具体IP

### Redis安全组（如果使用腾讯云服务器）

1. 腾讯云控制台 → Redis实例
2. 安全组设置
3. 添加规则：
   - 来源：0.0.0.0/0（或服务器公网IP）
   - 协议端口：TCP:22189
   - 策略：允许

---

## 🔒 安全建议

### 1. ⚠️ 立即更改的配置

部署到生产环境后，请立即修改：

```env
# 生成新的随机密钥（至少32字符）
SESSION_SECRET=$(openssl rand -hex 32)
JWT_SECRET=$(openssl rand -hex 32)
```

### 2. 环境变量管理

**✅ 推荐做法：**
- 在Railway/Render控制台配置环境变量
- 本地使用 `.env` 文件（已在.gitignore）
- 绝不提交 `.env` 到Git

**❌ 不要做：**
- 不要在代码中硬编码密钥
- 不要将 `.env` 文件提交到GitHub
- 不要在公开的文档中分享密钥

### 3. 定期更换密钥

建议每3-6个月更换一次：
- 腾讯云API密钥
- 阿里云AccessKey
- MongoDB密码
- Redis密码

---

## 📊 监控和日志

### Railway/Render监控

- 自动提供日志查看
- 实时监控CPU/内存使用
- 自动重启服务（如果崩溃）

### 自建服务器监控

```bash
# 查看PM2日志
pm2 logs adhder-api

# 查看实时日志
pm2 logs adhder-api --lines 100

# 重启服务
pm2 restart adhder-api
```

---

## 🎯 下一步

### 完成部署后：

1. ✅ **测试所有功能**
   - 手机号登录
   - 任务管理
   - 专注模式
   - 数据统计

2. ✅ **准备App Store资料**
   - 应用截图
   - 应用描述
   - 隐私政策
   - 使用条款

3. ✅ **注册开发者账号**
   - Apple Developer（¥688/年）
   - Google Play（$25一次性）

4. ✅ **打包应用**
   ```bash
   # iOS
   flutter build ipa
   
   # Android
   flutter build appbundle
   ```

5. ✅ **上传到App Store/Google Play**

---

## 🆘 常见问题

### Q: API请求失败，显示CORS错误？

**A:** 在服务器环境变量中添加：
```env
CORS_ORIGINS=https://your-flutter-app-domain.com
```

### Q: 短信验证码发送失败？

**A:** 检查：
1. 阿里云账号余额是否充足
2. 短信模板和签名是否审核通过
3. 手机号格式是否正确（+86开头）

### Q: MongoDB连接失败？

**A:** 检查：
1. MongoDB URL是否正确
2. 密码中的特殊字符是否URL编码
3. Network Access白名单是否包含服务器IP

### Q: Railway/Render部署失败？

**A:**  
1. 检查 `package.json` 中的启动脚本
2. 查看部署日志中的错误信息
3. 确保环境变量都已配置

---

## 📞 获取帮助

**GitHub Issues:**  
https://github.com/YALING0327/ADHDer/issues

**项目文档:**  
https://github.com/YALING0327/ADHDer/blob/main/README.md

---

## 🎉 恭喜！

按照此指南，您的ADHDER应用将很快可以正常使用！

**推荐部署顺序：**
1. 先用Railway部署（最快，5分钟）
2. 测试所有功能
3. 准备App Store上架资料
4. 如需要更好的性能，再考虑自建服务器

**祝您部署顺利！** 🚀

