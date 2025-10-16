/**
 * ADHDER User Schema (简化版)
 * 移除Habitica的RPG元素，专注于ADHD管理功能
 */

import mongoose from 'mongoose';

const { Schema } = mongoose;

// ===========================
// ADHD 专用字段
// ===========================

const ADHDProfileSchema = new Schema({
  // 诊断状态
  diagnosisStatus: {
    type: String,
    enum: ['none', 'suspected', 'diagnosed', 'prefer-not-say'],
    default: 'none',
  },
  // 严重程度
  severityLevel: {
    type: String,
    enum: ['mild', 'moderate', 'severe'],
    default: 'moderate',
  },
  // 共病情况
  comorbidities: [{
    type: String,
    enum: ['anxiety', 'depression', 'autism', 'learning-disability', 'other'],
  }],
  // 治疗计划
  treatmentPlan: { type: String, default: '' },
  // 服药情况
  medication: {
    isTaking: { type: Boolean, default: false },
    name: String,
    dosage: String,
    schedule: [String], // e.g., ['morning', 'afternoon']
  },
  // 触发因素
  triggers: [String],
  // 应对策略
  copingStrategies: [String],
}, { _id: false });

// ===========================
// 积分系统
// ===========================

const PointsSchema = new Schema({
  total: { type: Number, default: 0 }, // 累计总积分
  available: { type: Number, default: 0 }, // 可用积分
  history: [{
    date: { type: Date, default: Date.now },
    amount: Number,
    source: {
      type: String,
      enum: ['task', 'focus', 'training', 'daily-login', 'achievement', 'purchase', 'admin', 'migration'],
    },
    description: String,
  }],
}, { _id: false });

// ===========================
// 专注统计
// ===========================

const FocusStatsSchema = new Schema({
  totalMinutes: { type: Number, default: 0 },
  todayMinutes: { type: Number, default: 0 },
  weekMinutes: { type: Number, default: 0 },
  monthMinutes: { type: Number, default: 0 },
  currentStreak: { type: Number, default: 0 }, // 连续专注天数
  longestStreak: { type: Number, default: 0 },
  lastFocusDate: Date,
  // 专注模式偏好
  preferredMode: {
    type: String,
    enum: ['pomodoro', 'focus-noodles', 'traveler-adventure'],
    default: 'pomodoro',
  },
  // 番茄钟设置
  pomodoroSettings: {
    workDuration: { type: Number, default: 25 }, // 分钟
    shortBreak: { type: Number, default: 5 },
    longBreak: { type: Number, default: 15 },
    longBreakInterval: { type: Number, default: 4 }, // 几个番茄后长休息
  },
}, { _id: false });

// ===========================
// 训练进度
// ===========================

const TrainingProgressSchema = new Schema({
  // 抑制能力等级
  inhibitionLevel: { type: Number, default: 1, min: 1, max: 10 },
  inhibitionExp: { type: Number, default: 0 },
  // 注意力等级
  attentionLevel: { type: Number, default: 1, min: 1, max: 10 },
  attentionExp: { type: Number, default: 0 },
  // 工作记忆等级
  workingMemoryLevel: { type: Number, default: 1, min: 1, max: 10 },
  workingMemoryExp: { type: Number, default: 0 },
  // 认知灵活性等级
  cognitiveFlexibilityLevel: { type: Number, default: 1, min: 1, max: 10 },
  cognitiveFlexibilityExp: { type: Number, default: 0 },
  // 总训练次数
  totalSessions: { type: Number, default: 0 },
  lastTrainingDate: Date,
}, { _id: false });

// ===========================
// 旅人冒险进度
// ===========================

const AdventureProgressSchema = new Schema({
  level: { type: Number, default: 1 },
  experience: { type: Number, default: 0 },
  currentMapId: { type: String, default: 'map-1' },
  completedMaps: [String],
  attributes: {
    strength: { type: Number, default: 1 }, // 力量（影响奖励）
    agility: { type: Number, default: 1 }, // 敏捷（影响速度）
    focus: { type: Number, default: 1 }, // 专注（影响质量）
  },
  equipment: {
    weapon: String,
    armor: String,
    accessory: String,
  },
  inventory: [{
    itemId: String,
    quantity: { type: Number, default: 1 },
  }],
}, { _id: false });

// ===========================
// 家长控制
// ===========================

const ParentalControlSchema = new Schema({
  enabled: { type: Boolean, default: false },
  parentEmail: String,
  childAge: Number,
  restrictions: {
    maxDailyScreenTime: Number, // 分钟
    allowedApps: [String],
    requireApproval: {
      purchases: { type: Boolean, default: true },
      socialFeatures: { type: Boolean, default: true },
    },
  },
  reports: {
    weeklyEmailReport: { type: Boolean, default: true },
    lastReportDate: Date,
  },
}, { _id: false });

// ===========================
// 主用户 Schema
// ===========================

const AdhderUserSchema = new Schema({
  // ========== 基础信息 ==========
  auth: {
    local: {
      email: String,
      username: String,
      lowerCaseUsername: String,
      hashed_password: String,
      passwordHashMethod: { type: String, enum: ['bcrypt', 'sha1'], default: 'bcrypt' },
    },
    facebook: {
      id: String,
      emails: [{ value: String }],
      displayName: String,
    },
    google: {
      id: String,
      emails: [{ value: String }],
      displayName: String,
    },
    apple: {
      id: String,
      emails: [{ value: String }],
    },
    timestamps: {
      created: { type: Date, default: Date.now },
      loggedin: { type: Date, default: Date.now },
      updated: { type: Date, default: Date.now },
    },
  },

  profile: {
    name: { type: String, default: '用户' },
    avatar: String, // 头像URL
    bio: String, // 个人简介
    birthday: Date,
    gender: {
      type: String,
      enum: ['male', 'female', 'other', 'prefer-not-say'],
    },
    timezone: { type: String, default: 'Asia/Shanghai' },
  },

  // ========== ADHD 专用 ==========
  adhd: { type: ADHDProfileSchema, default: () => ({}) },

  // ========== 积分系统 ==========
  points: { type: PointsSchema, default: () => ({}) },

  // ========== 专注统计 ==========
  focusStats: { type: FocusStatsSchema, default: () => ({}) },

  // ========== 训练进度 ==========
  trainingProgress: { type: TrainingProgressSchema, default: () => ({}) },

  // ========== 旅人冒险 ==========
  adventureProgress: { type: AdventureProgressSchema, default: () => ({}) },

  // ========== 订阅状态 ==========
  subscription: {
    planId: String, // 'basic', 'premium', 'family'
    status: {
      type: String,
      enum: ['free', 'active', 'cancelled', 'expired'],
      default: 'free',
    },
    startDate: Date,
    endDate: Date,
    autoRenew: { type: Boolean, default: false },
    paymentMethod: String,
  },

  // ========== 偏好设置 ==========
  preferences: {
    // 时间设置
    dayStart: { type: Number, default: 0, min: 0, max: 23 }, // 每天开始的小时
    timezoneOffset: { type: Number, default: 0 },
    
    // 界面设置
    theme: {
      type: String,
      enum: ['healing', 'dark', 'light', 'auto'],
      default: 'healing',
    },
    language: { type: String, default: 'zh' },
    
    // 通知设置
    notifications: {
      enabled: { type: Boolean, default: true },
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true },
      taskReminders: { type: Boolean, default: true },
      focusReminders: { type: Boolean, default: true },
      trainingReminders: { type: Boolean, default: true },
      dailySummary: { type: Boolean, default: true },
    },
    
    // AI 设置
    ai: {
      voice: {
        type: String,
        enum: ['gentle', 'encouraging', 'professional'],
        default: 'gentle',
      },
      personality: {
        type: String,
        enum: ['warm', 'neutral', 'energetic'],
        default: 'warm',
      },
      proactiveness: {
        type: String,
        enum: ['low', 'medium', 'high'],
        default: 'medium',
      },
    },
    
    // 隐私设置
    privacy: {
      shareProgress: { type: Boolean, default: false },
      anonymousData: { type: Boolean, default: true },
    },
  },

  // ========== 家长模式 ==========
  parentalControl: { type: ParentalControlSchema, default: () => ({ enabled: false }) },

  // ========== AI 对话上下文 ==========
  aiContext: {
    conversationHistory: [{
      role: { type: String, enum: ['user', 'assistant'] },
      content: String,
      timestamp: { type: Date, default: Date.now },
    }],
    userPersonality: String, // AI 学习到的用户性格特征
    commonTopics: [String], // 常聊话题
    emotionalState: {
      type: String,
      enum: ['positive', 'neutral', 'stressed', 'anxious', 'motivated'],
      default: 'neutral',
    },
    lastUpdated: Date,
  },

  // ========== 系统字段 ==========
  flags: {
    lastFreeRebirth: Date,
    chatRevoked: { type: Boolean, default: false },
    chatShadowMuted: { type: Boolean, default: false },
  },

  pushDevices: [{
    type: { type: String, enum: ['ios', 'android'] },
    regId: String,
  }],

  lastCron: { type: Date, default: Date.now },
  needsCron: { type: Boolean, default: false },

  _ABtests: Schema.Types.Mixed, // A/B测试数据

  extra: Schema.Types.Mixed, // 扩展字段，用于实验性功能

}, {
  strict: true,
  minimize: false, // 保留空对象
  timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' },
  collection: 'users',
});

// ===========================
// 索引
// ===========================

AdhderUserSchema.index({ 'auth.local.lowerCaseUsername': 1 }, { unique: true, sparse: true });
AdhderUserSchema.index({ 'auth.local.email': 1 }, { sparse: true });
AdhderUserSchema.index({ 'auth.facebook.id': 1 }, { sparse: true });
AdhderUserSchema.index({ 'auth.google.id': 1 }, { sparse: true });
AdhderUserSchema.index({ 'auth.apple.id': 1 }, { sparse: true });
AdhderUserSchema.index({ lastCron: 1 });

// ===========================
// 方法
// ===========================

// 添加积分
AdhderUserSchema.methods.addPoints = function addPoints(amount, source, description) {
  this.points.total += amount;
  this.points.available += amount;
  this.points.history.push({
    date: new Date(),
    amount,
    source,
    description,
  });
  return this.save();
};

// 消费积分
AdhderUserSchema.methods.spendPoints = function spendPoints(amount, description) {
  if (this.points.available < amount) {
    throw new Error('积分不足');
  }
  this.points.available -= amount;
  this.points.history.push({
    date: new Date(),
    amount: -amount,
    source: 'purchase',
    description,
  });
  return this.save();
};

// 更新专注统计
AdhderUserSchema.methods.updateFocusStats = function updateFocusStats(minutes) {
  this.focusStats.totalMinutes += minutes;
  this.focusStats.todayMinutes += minutes;
  this.focusStats.weekMinutes += minutes;
  this.focusStats.monthMinutes += minutes;

  const today = new Date().toDateString();
  const lastFocusDay = this.focusStats.lastFocusDate
    ? this.focusStats.lastFocusDate.toDateString()
    : null;

  if (lastFocusDay !== today) {
    // 新的一天
    if (lastFocusDay === new Date(Date.now() - 86400000).toDateString()) {
      // 昨天专注过，连续天数+1
      this.focusStats.currentStreak += 1;
    } else {
      // 断了，重置
      this.focusStats.currentStreak = 1;
    }

    if (this.focusStats.currentStreak > this.focusStats.longestStreak) {
      this.focusStats.longestStreak = this.focusStats.currentStreak;
    }
  }

  this.focusStats.lastFocusDate = new Date();
  return this.save();
};

// 增加训练经验
AdhderUserSchema.methods.addTrainingExp = function addTrainingExp(type, exp) {
  const typeMap = {
    inhibition: 'inhibitionExp',
    attention: 'attentionExp',
    workingMemory: 'workingMemoryExp',
    cognitiveFlexibility: 'cognitiveFlexibilityExp',
  };

  const expField = typeMap[type];
  if (!expField) throw new Error('Invalid training type');

  this.trainingProgress[expField] += exp;
  this.trainingProgress.totalSessions += 1;
  this.trainingProgress.lastTrainingDate = new Date();

  // 检查是否升级（100经验=1级）
  const levelField = expField.replace('Exp', 'Level');
  const currentExp = this.trainingProgress[expField];
  const currentLevel = this.trainingProgress[levelField];

  const newLevel = Math.min(10, Math.floor(currentExp / 100) + 1);
  if (newLevel > currentLevel) {
    this.trainingProgress[levelField] = newLevel;
    // 可以在这里触发升级奖励
  }

  return this.save();
};

// 导出
export const User = mongoose.model('User', AdhderUserSchema);
export default User;

