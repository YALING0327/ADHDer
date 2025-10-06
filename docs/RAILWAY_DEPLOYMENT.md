# Railway 部署指南

## 🚀 快速部署步骤

### 1. 注册 Railway 账号
1. 访问 https://railway.app
2. 点击 "Login" 或 "Sign Up"
3. 选择 "Login with GitHub" 使用 GitHub 账号登录

### 2. 创建新项目
1. 登录后点击 "New Project"
2. 选择 "Deploy from GitHub repo"
3. 选择你的 `YALING0327/ADHDer` 仓库
4. 点击 "Deploy Now"

### 3. 配置环境变量
在 Railway 项目设置中添加以下环境变量：

#### 必需的环境变量
```
DATABASE_URL=postgresql://neondb_owner:npg_svEAJiOB41ZR@ep-late-forest-a1clkrf8-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
```

#### 可选的环境变量
```
RESEND_API_KEY=你的Resend API密钥
JWT_SECRET=你的JWT密钥（建议使用随机字符串）
CLARITY_PROJECT_ID=你的Microsoft Clarity项目ID
```

### 4. 配置构建设置
Railway 会自动检测到 Next.js 项目，但我们需要确保正确的构建配置：

1. 在项目设置中找到 "Settings" → "Build"
2. 确保构建命令为：`cd apps/web && npm run build`
3. 确保启动命令为：`cd apps/web && npm start`

### 5. 等待部署完成
- Railway 会自动开始构建
- 构建过程大约需要 3-5 分钟
- 部署完成后会显示你的应用 URL

## 🔧 配置说明

### 项目结构
Railway 会识别我们的 monorepo 结构：
- 根目录：包含 `package.json` 和 `pnpm-lock.yaml`
- Web 应用：位于 `apps/web/` 目录
- 数据库：使用 Neon PostgreSQL

### 构建流程
1. **安装依赖**：`npm install`（安装所有 workspace 依赖）
2. **生成 Prisma**：`cd apps/web && prisma generate`
3. **构建应用**：`cd apps/web && npm run build`
4. **启动服务**：`cd apps/web && npm start`

### 环境变量配置
在 Railway 项目设置中：
1. 点击 "Variables" 标签
2. 添加每个环境变量
3. 点击 "Deploy" 重新部署

## 📊 监控和日志

### 查看日志
1. 在 Railway 项目页面点击 "Deployments"
2. 选择最新的部署
3. 查看构建日志和运行日志

### 监控性能
1. 在项目页面查看 "Metrics"
2. 监控 CPU、内存使用情况
3. 查看请求量和响应时间

## 🔄 自动部署

### GitHub 集成
- Railway 会自动监听 GitHub 推送
- 每次推送到 `main` 分支都会触发部署
- 支持预览部署（Pull Request）

### 手动部署
1. 在 Railway 项目页面点击 "Deploy"
2. 选择要部署的分支
3. 点击 "Deploy" 开始部署

## 💰 成本管理

### 免费额度
- **$5 信用额度/月**
- **500 小时运行时间**
- **1GB 内存**

### 监控使用量
1. 在 Railway 仪表板查看使用情况
2. 设置使用量警报
3. 优化应用性能以节省成本

### 成本优化建议
- 使用环境变量缓存
- 优化构建时间
- 合理设置内存限制

## 🛠️ 故障排除

### 常见问题

#### 1. 构建失败
```
错误：Module not found
解决：检查 package.json 依赖是否正确
```

#### 2. 环境变量未生效
```
错误：Environment variable not found
解决：确保在 Railway 设置中正确配置环境变量
```

#### 3. 数据库连接失败
```
错误：Database connection failed
解决：检查 DATABASE_URL 格式和网络连接
```

### 调试步骤
1. 查看构建日志
2. 检查环境变量配置
3. 验证数据库连接
4. 查看运行时日志

## 📱 移动端配置

### 更新 API 地址
部署成功后，更新移动端的 API 地址：

1. 获取 Railway 部署 URL（如：`https://adhder-production.up.railway.app`）
2. 在移动端设置环境变量：
   ```bash
   export EXPO_PUBLIC_API_BASE="https://你的railway域名.up.railway.app"
   ```

### 测试连接
1. 在移动端测试登录功能
2. 验证 API 调用是否正常
3. 检查数据同步功能

## 🎉 部署完成

部署成功后，你的 ADHDer 应用将：
- ✅ 运行在 Railway 的全球 CDN 上
- ✅ 自动 HTTPS 加密
- ✅ 支持自动扩缩容
- ✅ 提供详细的监控和日志

### 下一步
1. 测试所有功能
2. 配置自定义域名（可选）
3. 设置监控警报
4. 准备应用商店上架
