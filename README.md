# ADHDER - ADHD专注力管理助手

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-green.svg)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-green.svg)](https://www.mongodb.com/)

一款专为ADHD（注意力缺陷多动障碍）用户设计的移动应用，提供专注力训练、任务管理、情绪支持等功能。

## 📱 项目结构

```
adhder-develop-final/
├── adhder_flutter/          # Flutter移动应用（iOS & Android）
├── website/                 # Node.js后端API服务
│   ├── server/             # 服务器代码
│   │   ├── controllers/    # API控制器
│   │   ├── models/         # 数据模型
│   │   └── libs/          # 工具库
│   └── common/            # 公共代码和国际化
└── README.md
```

## ✨ 核心功能

### 移动端（Flutter）
- 🔐 **多种登录方式**：邮箱密码登录、手机号验证码登录
- 📋 **任务管理**：创建、编辑、完成任务
- 🍅 **专注模式**：
  - 番茄钟（25分钟专注）
  - 专注面条（趣味煮面模式）
  - 旅行者冒险模式
- 🎮 **认知训练游戏**：
  - Go/No-Go 反应抑制训练
  - 专注气泡游戏
- 💧 **灵感存储**：快速记录想法和灵感
- 📊 **数据统计**：专注时长、任务完成率可视化

### 后端（Node.js + MongoDB）
- 🔐 用户认证（JWT）
- 📱 短信验证码（阿里云SMS）
- 💾 数据持久化（MongoDB Atlas）
- 🗄️ 缓存（Redis）
- 📦 文件存储（腾讯云COS）
- 📧 邮件服务（可选）

## 🚀 快速开始

### 前置要求
- Node.js 18+
- Flutter 3.x
- MongoDB（本地或Atlas）
- Redis（可选）

### 后端部署

1. 安装依赖
```bash
cd website
npm install
```

2. 配置环境变量
```bash
cp .env.example .env
# 编辑.env文件，填入必要的配置
```

3. 启动服务
```bash
npm start
```

### Flutter应用

1. 安装依赖
```bash
cd adhder_flutter
flutter pub get
```

2. 配置API地址
编辑 `lib/config/api_config.dart`：
```dart
static const String baseUrl = 'https://your-api-domain.com';
```

3. 运行应用
```bash
# iOS模拟器
flutter run -d iPhone

# Android模拟器
flutter run -d Android
```

## 📦 依赖服务

### 必需服务
- **MongoDB Atlas**：数据存储
- **阿里云SMS**：短信验证码

### 可选服务
- **Redis**：缓存
- **腾讯云COS**：文件存储
- **SendCloud**：邮件服务

## 🔧 配置说明

### 环境变量（`.env`）

```env
# 数据库
MONGODB_URL=mongodb+srv://...

# Redis
REDIS_HOST=...
REDIS_PORT=6379
REDIS_PASSWORD=...

# 阿里云短信
ALIYUN_ACCESS_KEY_ID=...
ALIYUN_ACCESS_KEY_SECRET=...
ALIYUN_SMS_TEMPLATE_CODE=...
ALIYUN_SMS_SIGN_NAME=...

# 腾讯云COS
TENCENT_SECRET_ID=...
TENCENT_SECRET_KEY=...
TENCENT_COS_BUCKET=...
TENCENT_COS_REGION=...
```

## 📱 应用截图

（TODO：添加应用截图）

## 🛠️ 技术栈

### 前端
- **Flutter**：跨平台移动应用框架
- **Provider**：状态管理
- **Dio**：HTTP网络请求
- **FL Chart**：数据可视化

### 后端
- **Node.js + Express**：RESTful API
- **MongoDB + Mongoose**：数据存储
- **Redis**：缓存
- **JWT**：身份认证

### 云服务
- **MongoDB Atlas**：数据库
- **阿里云SMS**：短信服务
- **腾讯云COS**：对象存储

## 📝 API文档

主要API端点：

### 认证
- `POST /api/v3/user/auth/local/login` - 邮箱登录
- `POST /api/v3/user/auth/local/register` - 注册
- `POST /api/v4/sms/send-code` - 发送短信验证码
- `POST /api/v4/sms/verify-and-login` - 验证码登录

### 任务
- `GET /api/v3/tasks/user` - 获取用户任务
- `POST /api/v3/tasks/user` - 创建任务
- `PUT /api/v3/tasks/:taskId` - 更新任务
- `DELETE /api/v3/tasks/:taskId` - 删除任务

### 专注会话
- `POST /api/v4/focus/start` - 开始专注
- `POST /api/v4/focus/:sessionId/stop` - 结束专注
- `GET /api/v4/focus` - 获取专注记录

### 认知训练
- `POST /api/v4/training/start` - 开始训练
- `POST /api/v4/training/:recordId/complete` - 完成训练
- `GET /api/v4/training` - 获取训练记录

### 灵感存储
- `POST /api/v4/insights` - 创建灵感笔记
- `GET /api/v4/insights` - 获取灵感列表
- `PUT /api/v4/insights/:insightId` - 更新灵感
- `DELETE /api/v4/insights/:insightId` - 删除灵感

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

MIT License

## 👥 作者

ADHDER Team

## 📞 联系方式

- GitHub: [@YALING0327](https://github.com/YALING0327)

---

**⚠️ 注意事项**

1. 生产环境请务必修改所有默认密钥和密码
2. 确保配置正确的CORS域名
3. 建议使用HTTPS协议
4. 定期备份数据库
5. 遵守GDPR和隐私保护法规

## 🎯 路线图

- [x] 基础任务管理
- [x] 专注模式（番茄钟、专注面条）
- [x] 认知训练游戏
- [x] 灵感存储功能
- [x] 数据统计可视化
- [x] 短信验证码登录
- [ ] AI智能助手
- [ ] 社区功能
- [ ] Apple Watch支持
- [ ] 数据同步优化
- [ ] 离线模式
