# EAS 构建指南

## 🚀 快速开始

### 1. 安装和登录 EAS CLI
```bash
# 安装 EAS CLI
npm install -g eas-cli

# 登录 Expo 账号
eas login
```

### 2. 配置项目
```bash
cd apps/mobile

# 配置构建
eas build:configure
```

### 3. 构建应用

#### 开发版本 (用于测试)
```bash
# iOS 开发版本
eas build --profile development --platform ios

# Android 开发版本  
eas build --profile development --platform android

# 同时构建两个平台
eas build --profile development --platform all
```

#### 预览版本 (内部测试)
```bash
# iOS 预览版本
eas build --profile preview --platform ios

# Android 预览版本
eas build --profile preview --platform android
```

#### 生产版本 (应用商店)
```bash
# iOS 生产版本
eas build --profile production --platform ios

# Android 生产版本
eas build --profile production --platform android
```

## 📱 构建配置说明

### Development Profile
- **用途**: 开发测试
- **特点**: 包含调试信息，可以热重载
- **API**: 连接到开发服务器
- **签名**: 使用开发证书

### Preview Profile  
- **用途**: 内部测试
- **特点**: 接近生产版本，但可以安装到测试设备
- **API**: 连接到生产服务器
- **签名**: 使用临时证书

### Production Profile
- **用途**: 应用商店发布
- **特点**: 完全优化的生产版本
- **API**: 连接到生产服务器
- **签名**: 使用发布证书

## 🔧 构建前准备

### 1. 检查配置文件
确保以下文件存在且配置正确：
- `app.json` - Expo 配置
- `eas.json` - EAS 构建配置
- `package.json` - 依赖配置

### 2. 环境变量
确保 EAS 配置中的环境变量正确：
```json
{
  "env": {
    "EXPO_PUBLIC_API_BASE": "https://adhder.onrender.com"
  }
}
```

### 3. 图标和启动画面
确保以下文件存在：
- `assets/icon.png` (1024x1024)
- `assets/splash.png` (启动画面)
- `assets/adaptive-icon.png` (Android 自适应图标)

## 📋 构建流程

### 1. 开始构建
```bash
eas build --profile production --platform all
```

### 2. 监控构建进度
- 构建会在 Expo 服务器上进行
- 可以通过 EAS CLI 或网页查看进度
- 通常需要 10-20 分钟

### 3. 下载构建结果
构建完成后会提供下载链接：
- iOS: `.ipa` 文件
- Android: `.apk` 或 `.aab` 文件

## 🍎 iOS 特定配置

### 1. Apple Developer 账号
- 需要付费的 Apple Developer 账号 ($99/年)
- 在 App Store Connect 创建应用

### 2. 证书和配置文件
EAS 会自动处理：
- 开发证书
- 发布证书  
- 配置文件

### 3. 应用商店连接
```bash
# 提交到 App Store Connect
eas submit --platform ios
```

## 🤖 Android 特定配置

### 1. Google Play Console
- 需要 Google Play Developer 账号 ($25 一次性费用)
- 在 Google Play Console 创建应用

### 2. 签名密钥
EAS 会自动生成和管理：
- 上传密钥
- 应用签名密钥

### 3. Google Play 提交
```bash
# 提交到 Google Play
eas submit --platform android
```

## 🔍 故障排除

### 常见问题

#### 1. 构建失败
```bash
# 查看详细日志
eas build:list
eas build:view [BUILD_ID]
```

#### 2. 证书问题
```bash
# 重新配置证书
eas credentials
```

#### 3. 环境变量问题
```bash
# 检查环境变量
eas env:list
```

### 调试技巧

#### 1. 本地构建
```bash
# 在本地构建 (需要 Xcode/Android Studio)
eas build --local
```

#### 2. 查看构建日志
```bash
# 实时查看构建日志
eas build:view [BUILD_ID] --logs
```

## 📊 构建优化

### 1. 减小应用大小
- 使用 `expo-optimize` 优化图片
- 移除未使用的依赖
- 启用代码分割

### 2. 提高构建速度
- 使用构建缓存
- 并行构建多个平台
- 使用 EAS Build 的付费计划

### 3. 自动化构建
```bash
# 设置 GitHub Actions 自动构建
eas build --auto-submit
```

## 🎯 下一步

构建完成后：

1. **测试应用**: 在真实设备上测试所有功能
2. **准备素材**: 创建应用商店截图和描述
3. **提交审核**: 提交到 App Store 和 Google Play
4. **监控发布**: 跟踪审核进度和用户反馈

## 📞 支持

如果遇到问题：
- 查看 [EAS 文档](https://docs.expo.dev/build/introduction/)
- 访问 [Expo 论坛](https://forums.expo.dev/)
- 联系 Expo 支持团队
