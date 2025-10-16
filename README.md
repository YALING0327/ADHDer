# ADHDER - ADHD专注助手

> 基于行为疗法和游戏化设计的ADHD辅助应用

---

## 📖 项目概述

ADHDER是一款专为ADHD（注意力缺陷多动障碍）用户设计的移动应用，通过科学的认知训练、专注模式和任务管理，帮助18-30岁的ADHD用户及儿童家长改善专注力、提升学习与生活效率。

### 核心功能

1. **🎯 专注模式** - 番茄钟、专注面条、旅人冒险
2. **🧠 认知训练** - Go/No-Go、N-back、Stroop等科学训练游戏
3. **📝 任务管理** - DDL拆解、时间分类、子任务管理
4. **💡 灵感存储** - "贮水"功能，快速记录想法
5. **⭐ 积分系统** - 游戏化激励，可兑换娱乐时间
6. **📊 数据分析** - 专注时长、训练进度、个性化报告
7. **🤖 AI辅助** - 智能对话、语音引导、情绪支持

---

## 🏗️ 技术架构

### 后端 (Node.js)
- **框架**: Express.js
- **数据库**: MongoDB (Atlas) + Redis
- **认证**: Passport.js (Local, Google, Apple, WeChat)
- **存储**: 腾讯云COS / 七牛云
- **短信**: 阿里云SMS
- **邮件**: SendCloud

### 前端 (Flutter)
- **框架**: Flutter 3.x
- **状态管理**: Provider / Riverpod
- **网络请求**: Dio
- **本地存储**: Hive + SharedPreferences
- **UI组件**: Material 3 + 自定义组件

---

## 📁 项目结构

```
adhder/
├── website/
│   ├── server/              # Node.js后端
│   │   ├── controllers/     # API控制器
│   │   │   └── api-v4/      # v4 API
│   │   │       ├── focus.js        # 专注会话API
│   │   │       ├── insights.js     # 灵感存储API
│   │   │       ├── training.js     # 认知训练API
│   │   │       └── tasks.js        # 任务管理API
│   │   ├── models/          # 数据模型
│   │   │   ├── user/        # 用户模型
│   │   │   ├── task.js      # 任务模型
│   │   │   ├── focus-session.js    # 专注会话
│   │   │   ├── training-record.js  # 训练记录
│   │   │   └── insight.js          # 灵感记录
│   │   ├── libs/            # 工具库
│   │   │   ├── email/       # 邮件服务
│   │   │   ├── sms-aliyun.js       # 阿里云短信
│   │   │   ├── storage/     # 云存储
│   │   │   └── wechat.js    # 微信登录
│   │   └── middlewares/     # 中间件
│   └── common/              # 共享代码
│       ├── locales/         # 多语言 (中英文)
│       └── script/          # 游戏逻辑
│
├── PRD-CODE-ANALYSIS.md     # PRD与代码对比分析
├── FLUTTER-APP-GUIDE.md     # Flutter开发指南
└── README.md                # 本文件
```

---

## 🚀 快速开始

### 环境要求

- **Node.js**: 18.x+
- **MongoDB**: 4.4+
- **Redis**: 6.0+
- **Flutter**: 3.10+

### 后端部署

1. **安装依赖**

```bash
cd website
npm install
```

2. **配置环境变量**

参考 `.env.example` 创建 `.env` 文件：

```env
NODE_ENV=production
PORT=3000
BASE_URL=https://your-domain.com

# 数据库
NODE_DB_URI=mongodb+srv://username:password@cluster.mongodb.net/adhder

# Redis
REDIS_HOST=your-redis-host
REDIS_PORT=6379
REDIS_PASSWORD=your-password

# 腾讯云
TENCENT_CLOUD_SECRET_ID=your-secret-id
TENCENT_CLOUD_SECRET_KEY=your-secret-key
TENCENT_COS_BUCKET=your-bucket
TENCENT_COS_REGION=ap-shanghai

# 阿里云短信
ALIYUN_ACCESS_KEY_ID=your-access-key
ALIYUN_ACCESS_KEY_SECRET=your-secret
ALIYUN_SMS_SIGN_NAME=your-sign-name
ALIYUN_SMS_TEMPLATE_CODE=SMS_xxxxxx

# 邮件服务
SENDCLOUD_API_USER=your-api-user
SENDCLOUD_API_KEY=your-api-key

# Session
SESSION_SECRET=your-random-secret
```

3. **启动服务**

```bash
npm start
```

服务将运行在 `http://localhost:3000`

---

### 移动端开发

详见 [FLUTTER-APP-GUIDE.md](./FLUTTER-APP-GUIDE.md)

```bash
# 创建Flutter项目
flutter create adhder_flutter

# 安装依赖
flutter pub get

# 运行
flutter run
```

---

## 📊 API文档

### 认证 API

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/api/v4/user/auth/local/register` | 注册 |
| POST | `/api/v4/user/auth/local/login` | 登录 |
| POST | `/api/v4/user/auth/logout` | 登出 |
| GET  | `/api/v4/user` | 获取当前用户信息 |

### 专注会话 API

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/api/v4/focus/sessions` | 开始专注 |
| GET  | `/api/v4/focus/sessions` | 获取专注历史 |
| GET  | `/api/v4/focus/sessions/active` | 获取当前会话 |
| POST | `/api/v4/focus/sessions/:id/complete` | 完成专注 |
| POST | `/api/v4/focus/sessions/:id/abandon` | 放弃专注 |
| GET  | `/api/v4/focus/stats` | 专注统计 |

### 认知训练 API

| 方法 | 端点 | 描述 |
|------|------|------|
| GET  | `/api/v4/training/games` | 获取游戏列表 |
| POST | `/api/v4/training/games/:type/start` | 开始训练 |
| POST | `/api/v4/training/games/:id/submit` | 提交成绩 |
| GET  | `/api/v4/training/progress` | 训练进度 |
| GET  | `/api/v4/training/stats` | 训练统计 |

### 灵感存储 API

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/api/v4/insights` | 创建灵感 |
| GET  | `/api/v4/insights` | 获取灵感列表 |
| GET  | `/api/v4/insights/pending` | 待处理灵感 |
| POST | `/api/v4/insights/:id/convert` | 转换为任务 |
| POST | `/api/v4/insights/:id/archive` | 归档 |
| DELETE | `/api/v4/insights/:id` | 删除 |

---

## 🎮 功能特性

### 1. 专注模式

#### 🍅 番茄钟
- 自定义专注时长（5-120分钟）
- 自动休息提醒
- 专注会话记录
- 中断检测与补偿

#### 🍜 专注面条
- 手机屏幕朝下开始
- 煮面隐喻的游戏化体验
- 完成获得趣味故事卡片
- 黑白插画治愈风格

#### ⚔️ 旅人冒险
- RPG风格冒险旅程
- 专注即战斗
- 经验值与装备系统
- 关卡与剧情推进

### 2. 认知训练游戏

#### 🚦 红灯绿灯 (Go/No-Go)
- 训练反应抑制
- 自适应难度
- 3-5分钟快速训练

#### 🔢 N-back测试
- 强化工作记忆
- 1-back到3-back渐进
- 实时反馈

#### 🎨 Stroop任务
- 提升认知灵活性
- 颜色-文字干扰测试
- 反应时统计

#### 🚀 持续注意力测试 (CPT)
- 维持长时间专注
- 目标识别训练
- 5-10分钟持续测试

### 3. 积分与奖励

- 专注完成获得积分
- 训练成绩奖励
- 任务完成奖励
- 积分兑换娱乐时间
- 徽章与成就系统

---

## 📱 适配平台

- ✅ iOS 11.0+
- ✅ Android 7.0+
- 🔄 Web (计划中)

---

## 🗺️ 开发路线图

### ✅ 已完成 (v0.1 - 后端基础)
- [x] 用户认证系统
- [x] 基础任务管理
- [x] 专注会话模型
- [x] 认知训练模型
- [x] 灵感存储模型
- [x] API框架搭建

### 🔨 进行中 (v0.2 - MVP)
- [ ] Flutter应用框架
- [ ] 番茄钟实现
- [ ] 2-3个训练游戏
- [ ] 任务列表页面
- [ ] 用户个人中心

### 📅 计划中 (v0.3 - 游戏化增强)
- [ ] 专注面条模式
- [ ] 旅人冒险模式
- [ ] 5个完整训练游戏
- [ ] 数据统计报告
- [ ] 积分商城

### 🚀 未来版本
- [ ] AI对话功能
- [ ] 语音引导
- [ ] 家长模式
- [ ] 社交功能
- [ ] 订阅支付

---

## 🤝 贡献指南

欢迎贡献代码、报告Bug或提出建议！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 📮 联系方式

- **项目维护**: lingyaliu
- **邮箱**: llymusic0327@gmail.com
- **网站**: https://arhyme.com

---

## 🙏 致谢

- [Habitica](https://github.com/HabitRPG/habitica) - 任务管理基础架构
- ADHD治疗师课程内容 - 心理学理论支持
- 所有测试用户和反馈者

---

**让我们一起帮助ADHD用户找到专注的力量！** 💪✨
