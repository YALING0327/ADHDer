# ADHDER PRD vs 现有代码库 - 功能对比分析

## ✅ 已有的基础功能（来自Habitica后端）

### 1. 用户系统 ✅
- ✅ 用户注册/登录
- ✅ 密码重置
- ✅ 用户资料管理
- ✅ 第三方登录（Google, Facebook, Apple）
- ⚠️ **缺少**: 微信登录集成（代码框架存在但未完整）

### 2. 任务管理基础 ✅
- ✅ 待办事项（Todos）
- ✅ 日常任务（Dailies）
- ✅ 习惯追踪（Habits）
- ✅ 任务标签系统
- ✅ 任务提醒
- ⚠️ **需要调整**: PRD要求的DDL拆解和时间分类需要重构

### 3. 游戏化系统 ✅
- ✅ 经验值和等级系统
- ✅ 金币/积分系统
- ✅ 成就徽章
- ✅ 任务奖励机制
- ⚠️ **需要调整**: 积分兑换娱乐时间等ADHD特定功能需新增

### 4. 数据库架构 ✅
- ✅ MongoDB集成
- ✅ 用户数据模型
- ✅ 任务数据模型
- ✅ Redis缓存支持

---

## ❌ PRD要求但完全缺失的核心功能

### 1. 专注模式功能集 ❌
**PRD需求**: 番茄钟、专注面条、旅人冒险模式
**现状**: 完全没有
**需要新增**:
```
- 专注计时器服务
- 锁屏/防打断机制
- 专注会话记录
- 实时专注状态追踪
```

### 2. 集中注意力小游戏 ❌
**PRD需求**: 泡泡游戏、节奏呼吸引导等
**现状**: 完全没有
**需要新增**:
```
- 小游戏引擎框架
- 传感器集成（手机翻转检测）
- 游戏状态管理
```

### 3. 认知训练游戏 ❌
**PRD需求**: Go/No-Go、n-back、Stroop任务等
**现状**: 完全没有
**需要新增**:
```
- 认知训练模块
- 自适应难度算法
- 训练数据分析
- 进度追踪系统
```

### 4. "贮水"灵感存储 ❌
**PRD需求**: 快速记录想法和待办
**现状**: 只有普通任务创建
**需要新增**:
```
- 快速记录API
- 语音转文字
- 灵感分类和整理
- 一键转换为任务
```

### 5. AI语音引导和对话 ❌
**PRD需求**: AI陪伴、治愈对话、专注引导
**现状**: 完全没有
**需要新增**:
```
- AI对话服务（接入GPT等）
- 文字转语音（TTS）
- 语音转文字（STT）
- AI人格设定系统
- 对话上下文管理
```

### 6. 积分兑换娱乐时间 ❌
**PRD需求**: 积分换取App使用时间
**现状**: 只有虚拟物品兑换
**需要新增**:
```
- 应用使用时间监控
- 使用券系统
- 时间配额管理
```

### 7. 专注数据统计 ❌
**PRD需求**: 专注时长趋势、训练进步报告
**现状**: 基础统计存在但不针对ADHD需求
**需要新增**:
```
- 专注时长聚合
- 训练效果分析
- 个性化报告生成
```

---

## 📱 完全缺失: Flutter移动端

**现状**: 只有Node.js后端，移动端为0
**需要从零开发**:

### Flutter应用架构
```
adhder-flutter/
├── lib/
│   ├── main.dart
│   ├── models/          # 数据模型
│   ├── services/        # API服务
│   ├── screens/         # 页面
│   │   ├── auth/        # 登录注册
│   │   ├── home/        # 主页
│   │   ├── focus/       # 专注模式
│   │   ├── training/    # 训练游戏
│   │   ├── tasks/       # 任务管理
│   │   ├── insights/    # 灵感存储
│   │   └── profile/     # 个人中心
│   ├── widgets/         # UI组件
│   │   ├── avatar.dart
│   │   ├── task_card.dart
│   │   └── focus_timer.dart
│   └── utils/           # 工具类
└── pubspec.yaml
```

---

## 🛠️ 需要新增的后端API

### 1. 专注会话管理
```javascript
POST   /api/v4/focus/sessions        # 开始专注
PUT    /api/v4/focus/sessions/:id    # 更新专注状态
GET    /api/v4/focus/sessions         # 获取专注历史
POST   /api/v4/focus/sessions/:id/complete  # 完成专注
```

### 2. 认知训练
```javascript
GET    /api/v4/training/games         # 获取游戏列表
POST   /api/v4/training/games/:id/start  # 开始训练
POST   /api/v4/training/games/:id/submit # 提交成绩
GET    /api/v4/training/progress       # 训练进度
```

### 3. 灵感存储
```javascript
POST   /api/v4/insights               # 创建灵感
GET    /api/v4/insights               # 获取灵感列表
PUT    /api/v4/insights/:id/convert  # 转为任务
DELETE /api/v4/insights/:id          # 删除灵感
```

### 4. AI对话
```javascript
POST   /api/v4/ai/chat               # AI对话
POST   /api/v4/ai/voice-guide        # 语音引导
GET    /api/v4/ai/encouragement      # 获取鼓励语
```

### 5. 数据分析
```javascript
GET    /api/v4/analytics/focus       # 专注统计
GET    /api/v4/analytics/training    # 训练统计
GET    /api/v4/analytics/report      # 生成报告
```

---

## 📋 开发优先级建议

### 第一阶段（MVP核心功能）- 2-3个月
1. ✅ **用户系统完善** (已有80%)
2. 🔨 **任务管理重构** - 适配DDL拆解
3. 🆕 **基础专注计时** - 番茄钟模式
4. 🆕 **积分系统扩展** - 支持兑换规则
5. 📱 **Flutter基础框架** - 登录、主页、任务列表

### 第二阶段（游戏化增强）- 2-3个月
6. 🆕 **专注面条模式**
7. 🆕 **旅人冒险模式**
8. 🆕 **认知训练游戏** (3-5个)
9. 🆕 **灵感存储功能**
10. 🆕 **数据统计报告**

### 第三阶段（AI智能化）- 2-3个月
11. 🆕 **AI对话服务**
12. 🆕 **语音引导功能**
13. 🆕 **个性化推荐**
14. 🆕 **智能提醒**

### 第四阶段（高级功能）- 2-3个月
15. 🆕 **家长模式**
16. 🆕 **社交功能**
17. 🆕 **订阅支付**
18. 🆕 **数据导出**

---

## 💾 需要新增的数据库模型

### 1. FocusSession (专注会话)
```javascript
{
  userId: ObjectId,
  mode: String,  // 'pomodoro', 'noodle', 'adventure'
  duration: Number,  // 预定时长(分钟)
  actualDuration: Number,  // 实际时长
  startTime: Date,
  endTime: Date,
  interrupted: Boolean,
  interruptions: [{
    time: Date,
    reason: String
  }],
  points: Number,  // 获得积分
  rewards: [String]  // 获得奖励
}
```

### 2. TrainingRecord (训练记录)
```javascript
{
  userId: ObjectId,
  gameType: String,  // 'go-nogo', 'nback', 'stroop'
  level: Number,
  score: Number,
  accuracy: Number,
  reactionTime: Number,
  date: Date,
  duration: Number
}
```

### 3. Insight (灵感)
```javascript
{
  userId: ObjectId,
  content: String,
  type: String,  // 'text', 'voice', 'image'
  voiceUrl: String,
  imageUrl: String,
  tags: [String],
  convertedToTask: Boolean,
  taskId: ObjectId,
  createdAt: Date
}
```

### 4. AIConversation (AI对话)
```javascript
{
  userId: ObjectId,
  messages: [{
    role: String,  // 'user', 'ai'
    content: String,
    timestamp: Date
  }],
  context: Object,  // 对话上下文
  mood: String,  // 用户情绪
  createdAt: Date
}
```

---

## 🎨 UI/UX组件需求

### Flutter组件库需求
1. **FocusTimer** - 专注计时器组件
2. **TrainingGameCanvas** - 游戏画布
3. **TaskBreakdown** - 任务拆解组件
4. **ProgressChart** - 进度图表
5. **AIAvatar** - AI头像动画
6. **InsightCard** - 灵感卡片
7. **PointsDisplay** - 积分显示
8. **RewardModal** - 奖励弹窗

---

## 总结

### ✅ 可以直接使用的 (约30%)
- 用户认证系统
- 基础任务管理
- 数据库架构
- 积分/经验系统框架

### 🔨 需要调整的 (约20%)
- 任务系统 - 适配DDL和拆解
- 积分系统 - 增加娱乐兑换
- 通知系统 - 适配专注提醒

### 🆕 需要从零开发的 (约50%)
- 所有专注模式功能
- 所有训练游戏
- AI对话和语音
- 灵感存储
- 完整的Flutter应用

### 📱 移动端开发量 (100%)
- 整个Flutter应用需从零开始

---

## 建议下一步行动

1. **先开发后端API** - 为专注、训练、灵感等功能建立API
2. **并行开发Flutter框架** - 搭建基础路由和状态管理
3. **从简单到复杂** - 先实现番茄钟，再做复杂游戏
4. **分模块测试** - 每个功能独立测试后再集成

**预估总开发时间**: 8-12个月（1-2个全职开发者）

