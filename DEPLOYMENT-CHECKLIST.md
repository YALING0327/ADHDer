# ✅ 部署前检查清单

## 🔍 预部署检查

### 本地环境检查

- [x] ✅ .env 文件已存在
- [x] ✅ .env 包含所有必需配置
- [x] ✅ GitHub代码已上传
- [x] ✅ 部署脚本已创建 (deploy-to-tencent.sh)
- [x] ✅ 部署脚本已设为可执行

### 配置验证

```
✅ MongoDB 连接字符串: mongodb+srv://username:password@cluster.mongodb.net/dbname
✅ Redis 主机: <YOUR_REDIS_HOST>:22189
✅ 腾讯云 API密钥: <YOUR_TENCENT_SECRET_ID>
✅ 阿里云 AccessKey: <YOUR_ALIYUN_ACCESS_KEY_ID>
✅ 短信模板: SMS_XXXXXX
✅ 签名名称: <YOUR_SIGN_NAME>
```

### 云服务准备

- [x] ✅ MongoDB Atlas 已配置
- [x] ✅ Redis 已购买（腾讯云）
- [x] ✅ 腾讯云 COS 已配置
- [x] ✅ 阿里云短信已激活
- [x] ✅ 服务器已购买（Lighthouse）

### 服务器检查

- [ ] 服务器IP: 122.51.20.50（已准备）
- [ ] 服务器状态：需要验证
- [ ] SSH访问权限：需要验证
- [ ] 域名DNS解析：需要配置

---

## 🚀 部署步骤

### 步骤1：测试SSH连接

```bash
ssh root@122.51.20.50 "echo '连接成功'"
```

**预期输出：**
```
连接成功
```

### 步骤2：验证所有配置

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final

# 检查部署脚本
ls -la deploy-to-tencent.sh

# 检查 .env 文件
cat website/.env | grep -E "MONGODB|TENCENT|ALIYUN"
```

### 步骤3：执行自动部署脚本

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final
./deploy-to-tencent.sh
```

**脚本会自动执行：**
1. ✅ 连接服务器
2. ✅ 安装环境（Node.js、PM2、Nginx、Certbot）
3. ✅ 克隆GitHub代码
4. ✅ 上传 .env 配置
5. ✅ 安装依赖
6. ✅ 启动应用
7. ✅ 配置Nginx反向代理
8. ✅ 申请SSL证书

---

## 📋 部署成功指标

部署完成后应该看到：

```
✅ 环境安装完成
✅ 代码克隆完成
✅ .env 文件已上传
✅ 依赖安装完成
✅ 应用启动成功
✅ Nginx配置完成
✅ SSL证书申请成功
🎉 部署完成！
```

---

## 🧪 部署后验证

### 1. 验证应用运行

```bash
ssh root@122.51.20.50 "pm2 status"
```

**预期输出：**
```
┌─────┬───────────────┬─────────┬──────┬───────────┬──────────┐
│ id  │ name          │ version │ mode │ status    │ uptime   │
├─────┼───────────────┼─────────┼──────┼───────────┼──────────┤
│ 0   │ adhder-api    │ 1.0.0   │ fork │ online    │ 2m       │
└─────┴───────────────┴─────────┴──────┴───────────┴──────────┘
```

### 2. 验证API响应

```bash
# 测试本地API
curl http://122.51.20.50:3000/api/v3/status

# 预期响应
# {"status":"up"}
```

### 3. 验证数据库连接

```bash
ssh root@122.51.20.50 "pm2 logs adhder-api | tail -20"
```

查看是否有数据库连接错误。

### 4. 配置域名解析

在腾讯云DNSPod配置：
- 主机记录: `api`
- 记录类型: `A`
- 记录值: `122.51.20.50`
- TTL: `600`

等待DNS生效（通常5-10分钟），然后测试：

```bash
nslookup api.adhder.app
```

### 5. 验证HTTPS

等待DNS生效后，测试HTTPS：

```bash
curl https://api.adhder.app/api/v3/status
```

---

## 📝 故障排查

### 如果部署脚本失败

**查看错误日志：**

```bash
# 查看最后100行日志
ssh root@122.51.20.50 "pm2 logs adhder-api --lines 100"

# 查看错误输出
ssh root@122.51.20.50 "pm2 logs adhder-api --err"
```

### 如果MongoDB连接失败

```bash
# 检查连接字符串
ssh root@122.51.20.50 "echo $MONGODB_URL"

# 手动测试连接
ssh root@122.51.20.50 "node -e \"console.log(process.env.MONGODB_URL)\""
```

### 如果Nginx报错

```bash
# 测试Nginx配置
ssh root@122.51.20.50 "sudo nginx -t"

# 查看Nginx状态
ssh root@122.51.20.50 "systemctl status nginx"

# 查看Nginx日志
ssh root@122.51.20.50 "sudo tail -100 /var/log/nginx/error.log"
```

---

## ✅ 最终检查清单

部署完成后请验证：

- [ ] PM2应用处于online状态
- [ ] API能正常响应
- [ ] 数据库连接正常
- [ ] 域名DNS已解析
- [ ] HTTPS能正常访问
- [ ] 短信功能可用
- [ ] 文件存储可用

---

## 🎯 预期部署时间

- 脚本执行：约5-10分钟
- DNS生效：约5-10分钟
- SSL证书申请：约1-2分钟
- **总计：约15-20分钟**

---

## 📞 如需帮助

如果遇到问题，请：

1. 查看完整指南：`TENCENT-DEPLOY-GUIDE.md`
2. 查看部署脚本：`deploy-to-tencent.sh`
3. 查看服务器日志：`ssh root@122.51.20.50 "pm2 logs"`

---

**现在可以开始部署了！** 🚀

```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final
./deploy-to-tencent.sh
```
