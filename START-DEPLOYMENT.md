# 🚀 开始部署到腾讯云

## ⚡ 5分钟快速开始

### 前置条件检查

```bash
# 1. 检查本地是否有 .env 文件
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final/website
ls -la | grep ".env"
```

**如果没有 .env 文件，请执行：**

```bash
# 从模板创建
cp .env.template .env

# 编辑配置（填入真实的密钥）
nano .env
```

**确保包含这些关键信息：**

```
✅ MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/dbname
✅ TENCENT_SECRET_ID=<YOUR_TENCENT_SECRET_ID>
✅ TENCENT_SECRET_KEY=<YOUR_TENCENT_SECRET_KEY>
✅ ALIYUN_ACCESS_KEY_ID=<YOUR_ALIYUN_ACCESS_KEY_ID>
✅ ALIYUN_ACCESS_KEY_SECRET=<YOUR_ALIYUN_ACCESS_KEY_SECRET>
```

---

### 执行部署

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final

# 运行部署脚本
./deploy-to-tencent.sh
```

**脚本会自动：**
1. ✅ 连接到您的服务器（122.51.20.50）
2. ✅ 安装所有必要的软件
3. ✅ 克隆GitHub代码
4. ✅ 配置应用
5. ✅ 启动服务
6. ✅ 配置Nginx和SSL

---

## 📋 完整部署清单

部署前请确认：

- [ ] 本地有 `.env` 文件并配置完整
- [ ] 可以通过SSH连接到 `122.51.20.50`
- [ ] GitHub代码库已更新（最新commit）
- [ ] 所有云服务密钥都已准备好

---

## 🔍 部署过程中可能遇到的问题

### 问题1：SSH连接失败

```bash
# 测试连接
ssh root@122.51.20.50 "echo hello"
```

**解决方案：**
- 检查服务器是否已启动
- 检查防火墙设置
- 确认SSH密钥正确

### 问题2：.env 文件上传失败

```bash
# 检查本地 .env 是否存在
ls -la website/.env

# 手动上传
scp website/.env root@122.51.20.50:/root/ADHDer/website/
```

### 问题3：部署脚本权限不足

```bash
# 给脚本执行权限
chmod +x deploy-to-tencent.sh

# 重新运行
./deploy-to-tencent.sh
```

---

## ✅ 部署完成后

部署成功后，您会看到类似输出：

```
🎉 部署完成！

📊 服务状态：
   服务器: 122.51.20.50
   API地址: https://api.adhder.app
   
✅ 应用已启动
✅ Nginx已配置
✅ SSL证书已申请
```

---

## 🧪 验证部署

### 1. 检查服务器状态

```bash
ssh root@122.51.20.50 "pm2 status"
```

### 2. 测试API端点

```bash
# HTTP 测试
curl http://122.51.20.50:3000/api/v3/status

# HTTPS 测试（SSL配置后）
curl https://api.adhder.app/api/v3/status
```

### 3. 查看实时日志

```bash
ssh root@122.51.20.50 "pm2 logs adhder-api"
```

---

## 📝 下一步

### 1. 更新Flutter应用

编辑 `adhder_flutter/lib/config/api_config.dart`：

```dart
class ApiConfig {
  static const String baseUrl = 'https://api.adhder.app';
  // ... 其他配置
}
```

### 2. 测试应用

```bash
cd adhder_flutter
flutter run
```

在模拟器中测试：
- ✅ 手机号登录
- ✅ 短信接收
- ✅ 任务管理
- ✅ 专注模式

### 3. 准备App Store上架

- [ ] 准备应用截图
- [ ] 编写应用描述
- [ ] 准备隐私政策
- [ ] 获取开发者账号

---

## 💡 提示

**如果部署失败：**

1. 查看详细错误日志
2. 检查 `.env` 配置是否正确
3. 确认所有云服务密钥有效
4. 查看 `TENCENT-DEPLOY-GUIDE.md` 手动部署步骤

**如果需要帮助：**

- 查看完整指南：`TENCENT-DEPLOY-GUIDE.md`
- 查看部署脚本：`deploy-to-tencent.sh`
- 检查日志：`ssh root@122.51.20.50 "pm2 logs"`

---

## 🎯 预期结果

部署完成后：

```
✅ 后端API运行在 https://api.adhder.app
✅ 数据库连接正常
✅ 短信服务可用
✅ 文件存储配置完成
✅ 安全证书已申请
✅ 可以支持用户登录和使用
```

---

**准备好了吗？开始部署吧！** 🚀

```bash
./deploy-to-tencent.sh
```
