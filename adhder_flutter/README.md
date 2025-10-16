# ADHDER Flutter App

ADHD专注助手 - Flutter移动应用

## 📱 项目概述

这是ADHDER的Flutter移动客户端，为ADHD用户提供专注力提升和任务管理功能。

### ✨ 已实现功能（MVP版本）

#### 核心功能
- ✅ **用户认证**
  - 登录/注册
  - Token持久化
  - 用户信息管理

- ✅ **任务管理**
  - 待办任务（Todo）
  - 日常任务（Daily）
  - 习惯任务（Habit）
  - 任务创建/编辑/删除
  - 任务完成状态管理

- ✅ **番茄钟专注**
  - 25分钟标准番茄钟
  - 计时器（开始/暂停/停止）
  - 圆形进度显示
  - 完成奖励提示

- ✅ **用户中心**
  - 个人资料展示
  - 等级和经验值
  - 积分和金币统计
  - 退出登录

#### 技术特性
- ✅ Provider状态管理
- ✅ Dio网络请求
- ✅ 安全存储（Token）
- ✅ 莫兰迪色系主题
- ✅ 响应式UI设计

### 🚧 待开发功能

- ⏳ 专注面条模式
- ⏳ 旅人冒险模式
- ⏳ 认知训练游戏
- ⏳ 灵感存储功能
- ⏳ 数据统计图表
- ⏳ 推送通知
- ⏳ 语音输入

---

## 🚀 快速开始

### 前置要求

1. **安装Flutter SDK**
   ```bash
   # macOS
   brew install flutter
   
   # 或下载：https://flutter.dev/docs/get-started/install
   ```

2. **验证Flutter环境**
   ```bash
   flutter doctor
   ```
   
   确保所有必要组件都已安装✅

3. **配置开发工具**
   - Android Studio（Android开发）
   - Xcode（iOS开发，仅macOS）
   - VS Code + Flutter插件（推荐）

### 安装步骤

#### 1. 进入项目目录
```bash
cd /Users/lingyaliu/Downloads/adhder-develop/adhder-develop-final/adhder_flutter
```

#### 2. 安装依赖
```bash
flutter pub get
```

#### 3. 配置后端地址

编辑 `lib/config/api_config.dart`：

```dart
static const String baseUrl = 'http://localhost:3000'; // 改为你的服务器地址
// 或
static const String baseUrl = 'https://arhyme.com'; // 生产环境
```

#### 4. 连接设备/模拟器

**iOS模拟器（仅macOS）**
```bash
open -a Simulator
```

**Android模拟器**
```bash
# 在Android Studio中启动AVD
# 或使用命令行
flutter emulators --launch <emulator_id>
```

**真机调试**
- iOS：需要Apple Developer账号
- Android：启用USB调试

#### 5. 运行应用
```bash
# 查看可用设备
flutter devices

# 运行
flutter run

# 或指定设备
flutter run -d <device_id>
```

---

## 📂 项目结构

```
lib/
├── config/                 # 配置文件
│   ├── api_config.dart    # API配置
│   └── theme.dart         # 主题配置
├── models/                # 数据模型
│   ├── user.dart          # 用户模型
│   ├── task.dart          # 任务模型
│   └── focus_session.dart # 专注会话模型
├── services/              # API服务
│   ├── api_client.dart    # HTTP客户端
│   ├── auth_service.dart  # 认证服务
│   ├── task_service.dart  # 任务服务
│   └── focus_service.dart # 专注服务
├── providers/             # 状态管理
│   ├── auth_provider.dart # 认证状态
│   └── task_provider.dart # 任务状态
├── screens/               # 页面
│   ├── auth/             # 认证页面
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/             # 主页
│   │   └── home_screen.dart
│   ├── tasks/            # 任务页面
│   │   └── tasks_screen.dart
│   ├── focus/            # 专注页面
│   │   ├── focus_menu_screen.dart
│   │   └── pomodoro_screen.dart
│   └── profile/          # 个人中心
│       └── profile_screen.dart
├── widgets/              # 通用组件
└── main.dart             # 应用入口
```

---

## 🔧 开发指南

### 添加新页面

1. 在 `lib/screens/` 创建页面文件
2. 使用StatelessWidget或StatefulWidget
3. 遵循现有UI风格（使用AppTheme）

### 添加新API

1. 在对应的Service文件中添加方法
2. 更新 `api_config.dart` 添加端点
3. 在Provider中调用并管理状态

### 使用Provider

```dart
// 获取数据
final authProvider = context.watch<AuthProvider>();
final user = authProvider.user;

// 调用方法
await context.read<AuthProvider>().login(email, password);
```

### 调试技巧

```bash
# 热重载（在运行时）
按 r

# 热重启（在运行时）
按 R

# 查看日志
flutter logs

# 性能分析
flutter run --profile
```

---

## 📱 打包发布

### Android APK
```bash
flutter build apk --release
# 输出: build/app/outputs/flutter-apk/app-release.apk
```

### Android AAB（Google Play）
```bash
flutter build appbundle --release
# 输出: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA（需要macOS + Apple Developer账号）
```bash
flutter build ios --release
# 然后在Xcode中Archive和Export
```

---

## 🎨 UI设计规范

### 颜色系统
- **主色调**：雾紫 `#B8A5C8`
- **次要色**：薄荷蓝 `#A8D8E8`
- **强调色**：藕粉 `#FFC0BE`
- **成功色**：薄荷绿 `#9ED9A6`
- **警告色**：鹅黄 `#FDD396`
- **错误色**：淡红 `#EE9B9B`

### 字体
- 默认：PingFang SC
- 大标题：32px Bold
- 副标题：24px Bold
- 正文：16px Regular

### 圆角
- 卡片：16px
- 按钮：12px
- 图标容器：8-12px

---

## 🐛 常见问题

### Q: 运行时提示"Waiting for another flutter command to release the startup lock"
```bash
rm -rf /Users/lingyaliu/flutter/bin/cache/lockfile
```

### Q: iOS编译失败
```bash
cd ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

### Q: API请求失败
1. 检查 `api_config.dart` 中的baseUrl是否正确
2. 确保后端服务已启动
3. iOS模拟器使用 `http://localhost`
4. Android模拟器使用 `http://10.0.2.2` 代替 `localhost`

### Q: 依赖安装失败
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

## 📝 待办事项

### 短期（1-2周）
- [ ] 完善专注面条模式
- [ ] 添加灵感存储功能
- [ ] 实现数据统计页面
- [ ] 添加本地通知

### 中期（1个月）
- [ ] 开发认知训练游戏
- [ ] 实现旅人冒险模式
- [ ] 添加语音输入
- [ ] 社交功能

### 长期
- [ ] AI陪伴功能
- [ ] 数据同步优化
- [ ] 离线模式
- [ ] 主题切换

---

## 🤝 贡献指南

1. Fork本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

---

## 📄 许可证

MIT License

---

## 📞 联系方式

- 项目地址：https://github.com/yourusername/adhder
- 问题反馈：https://github.com/yourusername/adhder/issues

---

## 🙏 致谢

- Flutter团队
- Habitica后端架构参考
- 所有贡献者

---

**祝你开发愉快！🎉**

