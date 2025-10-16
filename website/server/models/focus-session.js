/**
 * ADHDER FocusSession Model
 * 专注会话记录
 */

import mongoose from 'mongoose';

const { Schema } = mongoose;

const FocusSessionSchema = new Schema({
  userId: { type: String, ref: 'User', required: true, index: true },
  
  // 关联任务（可选）
  taskId: { type: Schema.Types.ObjectId, ref: 'Task' },
  taskTitle: String, // 冗余字段，方便查询
  
  // 专注模式
  focusMode: {
    type: String,
    enum: ['pomodoro', 'focus-noodles', 'traveler-adventure'],
    required: true,
    index: true,
  },
  
  // 时间信息
  startTime: { type: Date, required: true, index: true },
  endTime: Date,
  duration: { type: Number, required: true }, // 分钟数
  plannedDuration: Number, // 计划时长
  
  // 完成状态
  completed: { type: Boolean, default: false },
  interruptedReason: {
    type: String,
    enum: ['user-cancelled', 'phone-call', 'notification', 'emergency', 'break-time', 'other'],
  },
  interruptedAt: Date,
  
  // 番茄钟特定数据
  pomodoroData: {
    workSessions: Number, // 完成的工作番茄数
    breakSessions: Number, // 完成的休息番茄数
    workDuration: Number, // 每个工作番茄时长（分钟）
    shortBreakDuration: Number,
    longBreakDuration: Number,
  },
  
  // 面条专注特定数据
  focusNoodlesData: {
    noodleLength: Number, // 面条长度（厘米）
    sensorTriggered: Boolean, // 传感器是否被触发
    triggerCount: Number, // 触发次数
    holdDuration: Number, // 单次最长持续时长（分钟）
  },
  
  // 旅人冒险特定数据
  travelerAdventureData: {
    mapId: String, // 地图ID
    distanceTraveled: Number, // 旅行距离
    enemiesDefeated: Number, // 击败敌人数
    goldEarned: Number, // 获得金币
    expEarned: Number, // 获得经验
    itemsCollected: [String], // 收集的物品
    levelUps: Number, // 升级次数
  },
  
  // 质量评分
  quality: {
    score: { type: Number, min: 0, max: 100 }, // 专注质量评分 (0-100)
    factors: {
      completion: Number, // 完成度
      concentration: Number, // 专注度
      efficiency: Number, // 效率
    },
  },
  
  // 奖励
  rewards: {
    points: { type: Number, default: 0 }, // 获得的积分
    achievements: [String], // 解锁的成就
  },
  
  // 用户反馈
  feedback: {
    feeling: {
      type: String,
      enum: ['very-productive', 'productive', 'neutral', 'distracted', 'very-distracted'],
    },
    notes: String, // 用户备注
    tags: [String], // 用户标签（如：environment-good, music-helpful）
  },
  
  // 元数据
  createdAt: Date,
  updatedAt: Date,
}, {
  timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' },
  collection: 'focus_sessions',
});

// ===========================
// 索引
// ===========================

FocusSessionSchema.index({ userId: 1, startTime: -1 });
FocusSessionSchema.index({ userId: 1, focusMode: 1 });
FocusSessionSchema.index({ userId: 1, completed: 1 });
FocusSessionSchema.index({ taskId: 1 });

// ===========================
// 静态方法
// ===========================

// 获取用户的专注历史
FocusSessionSchema.statics.getUserHistory = function getUserHistory(userId, limit = 30) {
  return this.find({ userId })
    .sort({ startTime: -1 })
    .limit(limit)
    .lean();
};

// 获取用户今天的专注时长
FocusSessionSchema.statics.getTodayFocusTime = async function getTodayFocusTime(userId) {
  const startOfDay = new Date();
  startOfDay.setHours(0, 0, 0, 0);
  
  const sessions = await this.find({
    userId,
    startTime: { $gte: startOfDay },
    completed: true,
  });
  
  return sessions.reduce((total, session) => total + (session.duration || 0), 0);
};

// 获取用户本周的专注统计
FocusSessionSchema.statics.getWeeklyStats = async function getWeeklyStats(userId) {
  const startOfWeek = new Date();
  startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
  startOfWeek.setHours(0, 0, 0, 0);
  
  const sessions = await this.find({
    userId,
    startTime: { $gte: startOfWeek },
    completed: true,
  });
  
  const stats = {
    totalMinutes: 0,
    sessionCount: sessions.length,
    byMode: {},
    dailyBreakdown: {},
  };
  
  sessions.forEach((session) => {
    stats.totalMinutes += session.duration || 0;
    
    // 按模式统计
    if (!stats.byMode[session.focusMode]) {
      stats.byMode[session.focusMode] = {
        count: 0,
        minutes: 0,
      };
    }
    stats.byMode[session.focusMode].count += 1;
    stats.byMode[session.focusMode].minutes += session.duration || 0;
    
    // 按天统计
    const day = session.startTime.toDateString();
    if (!stats.dailyBreakdown[day]) {
      stats.dailyBreakdown[day] = 0;
    }
    stats.dailyBreakdown[day] += session.duration || 0;
  });
  
  return stats;
};

// 获取用户的专注排行（与其他用户比较）
FocusSessionSchema.statics.getLeaderboard = async function getLeaderboard(timeRange = 'week', limit = 10) {
  const now = new Date();
  let startDate = new Date();
  
  switch (timeRange) {
    case 'day':
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'week':
      startDate.setDate(startDate.getDate() - 7);
      break;
    case 'month':
      startDate.setMonth(startDate.getMonth() - 1);
      break;
    default:
      startDate.setDate(startDate.getDate() - 7);
  }
  
  const leaderboard = await this.aggregate([
    {
      $match: {
        startTime: { $gte: startDate },
        completed: true,
      },
    },
    {
      $group: {
        _id: '$userId',
        totalMinutes: { $sum: '$duration' },
        sessionCount: { $sum: 1 },
      },
    },
    {
      $sort: { totalMinutes: -1 },
    },
    {
      $limit: limit,
    },
    {
      $lookup: {
        from: 'users',
        localField: '_id',
        foreignField: '_id',
        as: 'user',
      },
    },
    {
      $unwind: '$user',
    },
    {
      $project: {
        userId: '$_id',
        totalMinutes: 1,
        sessionCount: 1,
        userName: '$user.profile.name',
        userAvatar: '$user.profile.avatar',
      },
    },
  ]);
  
  return leaderboard;
};

// ===========================
// 实例方法
// ===========================

// 完成专注会话
FocusSessionSchema.methods.completeFocusSession = async function completeFocusSession() {
  this.completed = true;
  this.endTime = new Date();
  
  // 计算实际时长（如果没有设置）
  if (!this.duration) {
    const durationMs = this.endTime - this.startTime;
    this.duration = Math.round(durationMs / (1000 * 60));
  }
  
  // 计算质量评分
  this.calculateQuality();
  
  // 计算奖励
  this.calculateRewards();
  
  return this.save();
};

// 中断专注会话
FocusSessionSchema.methods.interrupt = function interrupt(reason) {
  this.completed = false;
  this.interruptedAt = new Date();
  this.interruptedReason = reason;
  
  // 计算已进行的时长
  const durationMs = this.interruptedAt - this.startTime;
  this.duration = Math.round(durationMs / (1000 * 60));
  
  return this.save();
};

// 计算专注质量
FocusSessionSchema.methods.calculateQuality = function calculateQuality() {
  if (!this.quality) {
    this.quality = { factors: {} };
  }
  
  // 完成度评分（实际时长 / 计划时长）
  let completionScore = 100;
  if (this.plannedDuration && this.duration) {
    completionScore = Math.min(100, (this.duration / this.plannedDuration) * 100);
  }
  this.quality.factors.completion = completionScore;
  
  // 专注度评分（基于模式特定数据）
  let concentrationScore = 80; // 默认
  
  if (this.focusMode === 'focus-noodles' && this.focusNoodlesData) {
    // 面条专注：触发次数越少越好
    const triggers = this.focusNoodlesData.triggerCount || 0;
    concentrationScore = Math.max(0, 100 - (triggers * 10));
  } else if (this.focusMode === 'pomodoro' && this.pomodoroData) {
    // 番茄钟：完成的番茄数越多越好
    const completed = this.pomodoroData.workSessions || 0;
    concentrationScore = Math.min(100, completed * 25);
  } else if (this.focusMode === 'traveler-adventure' && this.travelerAdventureData) {
    // 旅人冒险：距离和战斗次数反映专注度
    const distance = this.travelerAdventureData.distanceTraveled || 0;
    concentrationScore = Math.min(100, distance / this.duration * 10);
  }
  
  this.quality.factors.concentration = concentrationScore;
  
  // 效率评分（用户反馈）
  let efficiencyScore = 70; // 默认
  if (this.feedback && this.feedback.feeling) {
    const feelingScores = {
      'very-productive': 100,
      'productive': 85,
      'neutral': 70,
      'distracted': 50,
      'very-distracted': 30,
    };
    efficiencyScore = feelingScores[this.feedback.feeling] || 70;
  }
  this.quality.factors.efficiency = efficiencyScore;
  
  // 综合评分
  this.quality.score = Math.round(
    (completionScore * 0.3) + 
    (concentrationScore * 0.4) + 
    (efficiencyScore * 0.3)
  );
};

// 计算奖励
FocusSessionSchema.methods.calculateRewards = function calculateRewards() {
  if (!this.rewards) {
    this.rewards = { achievements: [] };
  }
  
  // 基础积分：每分钟1分
  let points = this.duration || 0;
  
  // 质量加成
  if (this.quality && this.quality.score) {
    const qualityBonus = Math.floor((this.quality.score - 50) / 10);
    points += Math.max(0, qualityBonus * 2);
  }
  
  // 完成加成
  if (this.completed) {
    points += 10;
  }
  
  // 连续专注加成（需要从用户数据中获取）
  // 这里简化处理
  
  this.rewards.points = Math.max(1, points);
};

// ===========================
// 导出
// ===========================

export const FocusSession = mongoose.model('FocusSession', FocusSessionSchema);
export default FocusSession;

