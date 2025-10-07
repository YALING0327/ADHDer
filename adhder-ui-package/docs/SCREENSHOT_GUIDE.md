# 应用截图生成指南

## 📱 需要生成的截图

### iOS App Store 截图
- **iPhone 14 Pro Max** (iPhone 6.7"): 1290x2796px
- **iPhone 11 Pro Max** (iPhone 6.5"): 1242x2688px
- **iPhone 8 Plus** (iPhone 5.5"): 1242x2208px
- **iPad Pro 12.9** (iPad Pro 12.9"): 2048x2732px
- **iPad Pro 11** (iPad Pro 11"): 1668x2388px
- **Android Phone** (Android Phone): 1080x1920px
- **Android Tablet** (Android Tablet): 1200x1920px

### Android Play Store 截图
- **手机**: 1080x1920px 或更高
- **平板**: 1200x1920px 或更高

## 🎨 截图内容

### 登录页面
- **文件名**: login.png
- **描述**: 展示邮箱/手机号双登录功能
- **重点**: 突出核心功能和用户体验
### 任务管理
- **文件名**: tasks.png
- **描述**: 展示任务列表和 DDL 功能
- **重点**: 突出核心功能和用户体验
### 专注计时器
- **文件名**: focus.png
- **描述**: 展示专注计时器界面
- **重点**: 突出核心功能和用户体验
### 想法记录
- **文件名**: ideas.png
- **描述**: 展示想法记录功能
- **重点**: 突出核心功能和用户体验
### 助眠音景
- **文件名**: sleep.png
- **描述**: 展示音效选择界面
- **重点**: 突出核心功能和用户体验
### 壁纸中心
- **文件名**: wallpaper.png
- **描述**: 展示壁纸预览和保存
- **重点**: 突出核心功能和用户体验

## 🛠️ 生成方法

### 方法 1: 使用 Expo 开发工具
1. 启动开发服务器: `cd apps/mobile && pnpm dev`
2. 在模拟器中打开应用
3. 导航到各个页面
4. 使用模拟器的截图功能
5. 调整尺寸到所需规格

### 方法 2: 使用真实设备
1. 在手机上安装开发版本
2. 导航到各个页面
3. 使用设备截图功能
4. 使用图片编辑软件调整尺寸

### 方法 3: 使用自动化工具
1. 使用 Appium 或 Detox 进行自动化测试
2. 在测试过程中自动截图
3. 批量调整尺寸

## 📁 文件组织

建议的文件结构:
```
screenshots/
├── ios/
│   ├── iPhone-14-Pro-Max/
│   │   ├── login.png
│   │   ├── tasks.png
│   │   ├── focus.png
│   │   ├── ideas.png
│   │   ├── sleep.png
│   │   └── wallpaper.png
│   ├── iPhone-11-Pro-Max/
│   └── iPad-Pro-12.9/
├── android/
│   ├── phone/
│   └── tablet/
└── marketing/
    ├── banner-1024x500.png
    └── social-1200x630.png
```

## 🎯 截图要求

### 内容要求
- 展示应用的核心功能
- 使用真实数据，不要用占位符
- 确保界面美观，无错误信息
- 突出 ADHD 用户的痛点解决方案

### 技术要求
- 高质量 PNG 格式
- 无压缩失真
- 正确的尺寸比例
- 清晰的文字和图标

### 设计建议
- 使用一致的配色方案
- 突出重要功能按钮
- 展示用户友好的界面
- 体现专业性和可信度

## 🚀 自动化脚本

可以使用以下脚本批量处理截图:

```bash
#!/bin/bash
# 批量调整截图尺寸

for size in "1290x2796" "1242x2688" "1080x1920"; do
  for page in login tasks focus ideas sleep wallpaper; do
    if [ -f "screenshots/raw/${page}.png" ]; then
      sips -z ${size#*x} ${size%x*} "screenshots/raw/${page}.png" --out "screenshots/processed/${size}/${page}.png"
    fi
  done
done
```

## 📋 检查清单

- [ ] 所有必需尺寸的截图已生成
- [ ] 截图质量清晰，无模糊
- [ ] 内容展示应用核心功能
- [ ] 界面美观，无错误信息
- [ ] 文件命名规范
- [ ] 文件大小合理 (< 5MB each)
- [ ] 符合应用商店要求

## 🎨 营销素材

除了应用截图，还需要准备:

### 应用商店横幅
- **尺寸**: 1024x500px
- **用途**: App Store 和 Google Play 展示
- **内容**: 应用名称、主要功能、品牌标识

### 社交媒体图片
- **尺寸**: 1200x630px
- **用途**: Facebook、Twitter 等社交平台
- **内容**: 应用介绍、下载链接

### 应用预览视频
- **时长**: 15-30秒
- **内容**: 应用功能演示
- **格式**: MP4, 高质量

## 📞 技术支持

如果在生成截图过程中遇到问题:
1. 检查设备/模拟器设置
2. 确保应用正常运行
3. 使用图片编辑软件调整
4. 参考应用商店指南
