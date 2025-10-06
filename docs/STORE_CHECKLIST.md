# 商店提审素材清单

## iOS App Store

### 必需素材
- [ ] **App Icon**: 1024x1024px PNG (无圆角，无透明度)
- [ ] **Screenshots**: 
  - iPhone 6.7" (iPhone 15 Pro Max): 1290x2796px
  - iPhone 6.5" (iPhone 14 Plus): 1242x2688px  
  - iPhone 5.5" (iPhone 8 Plus): 1242x2208px
  - iPad Pro 12.9": 2048x2732px
  - iPad Pro 11": 1668x2388px
- [ ] **App Preview Video** (可选但推荐): 15-30秒 MP4

### 应用信息
- [ ] **App Name**: ADHDer - ADHD 全能助手
- [ ] **Subtitle**: 专注、任务、睡眠、想法管理
- [ ] **Keywords**: ADHD,专注,任务管理,番茄钟,睡眠,想法记录
- [ ] **Description**: 
```
ADHDer 是专为 ADHD 用户设计的全能助手应用，提供：

🎯 专注计时器 - 25/45/60分钟番茄钟，支持中断记录
📝 智能任务管理 - 自由任务和DDL任务，本地通知提醒
💡 想法记录 - 随时记录灵感，支持文字和语音
😴 助眠音景 - 白噪音、自然音等，定时渐隐
🎨 壁纸中心 - 精美壁纸，一键保存到相册
🔍 全局搜索 - 快速查找任务和想法
🎮 指尖佛珠 - 触觉反馈解压小游戏

简洁易用的界面设计，帮助 ADHD 用户更好地管理时间、提高专注力、记录想法。
```

### 隐私信息
- [ ] **Privacy Policy URL**: https://your-domain.com/(legal)/privacy
- [ ] **Data Collection**: 用户邮箱、任务数据、使用统计
- [ ] **Third-party SDKs**: Firebase Analytics, Crashlytics

## Google Play Store

### 必需素材
- [ ] **App Icon**: 512x512px PNG
- [ ] **Feature Graphic**: 1024x500px PNG
- [ ] **Screenshots**: 
  - Phone: 1080x1920px 或更高
  - Tablet: 1200x1920px 或更高
- [ ] **App Preview Video** (可选): 30秒-2分钟 MP4

### 应用信息
- [ ] **App Name**: ADHDer - ADHD 全能助手
- [ ] **Short Description**: 专为 ADHD 用户设计的专注、任务、睡眠管理应用
- [ ] **Full Description**: 同 iOS 描述
- [ ] **Category**: 健康健美 / 生产力

### 内容分级
- [ ] **Content Rating**: 适合所有年龄
- [ ] **Target Audience**: 13+ (建议)

## 通用要求

### 法律页面
- [ ] **Privacy Policy**: 详细说明数据收集和使用
- [ ] **Terms of Service**: 服务条款
- [ ] **Disclaimer**: 医疗免责声明

### 技术准备
- [ ] **App Version**: 1.0.0
- [ ] **Build Number**: 1
- [ ] **Bundle ID**: com.adhder.app
- [ ] **Package Name**: com.adhder.app (Android)

### 测试准备
- [ ] **TestFlight** (iOS): 内部测试完成
- [ ] **Internal Testing** (Android): 内部测试完成
- [ ] **功能测试**: 所有核心功能正常工作
- [ ] **性能测试**: 应用启动时间 < 3秒
- [ ] **兼容性测试**: iOS 13+, Android 8+

## 提交流程

### iOS App Store
1. 在 App Store Connect 创建应用
2. 上传构建版本 (EAS Build)
3. 填写应用信息和元数据
4. 上传截图和预览视频
5. 设置价格和可用性
6. 提交审核

### Google Play Store  
1. 在 Google Play Console 创建应用
2. 上传 APK/AAB (EAS Build)
3. 填写商店详情
4. 上传素材资源
5. 设置内容分级
6. 发布到生产环境

## 审核要点

### 常见拒绝原因
- [ ] 应用崩溃或功能异常
- [ ] 缺少隐私政策
- [ ] 截图与实际功能不符
- [ ] 应用名称或描述误导
- [ ] 违反平台政策

### 优化建议
- [ ] 确保应用在低端设备上流畅运行
- [ ] 提供清晰的使用说明
- [ ] 避免使用医疗相关声明
- [ ] 确保所有外部链接正常工作
