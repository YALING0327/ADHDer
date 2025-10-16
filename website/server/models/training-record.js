/**
 * ADHDER TrainingRecord Model
 * 认知训练记录
 */

import mongoose from 'mongoose';

const { Schema } = mongoose;

const TrainingRecordSchema = new Schema({
  userId: { type: String, ref: 'User', required: true, index: true },
  
  // 游戏类型
  gameType: {
    type: String,
    enum: [
      'red-green-light', // 红灯绿灯（抑制控制）
      'space-focus', // 太空聚焦（持续注意力）
      'number-mirror', // 数字倒影（工作记忆）
      'color-words', // 色字游戏（认知灵活性）
      'monkey-banana', // 猴子抓香蕉（奖惩反馈）
    ],
    required: true,
    index: true,
  },
  
  // 难度等级
  difficultyLevel: { type: Number, min: 1, max: 10, required: true },
  
  // 时间信息
  startTime: { type: Date, required: true, index: true },
  endTime: Date,
  durationSeconds: { type: Number, required: true },
  
  // 完成状态
  completed: { type: Boolean, default: false },
  
  // 性能数据（通用）
  performance: {
    totalTrials: Number, // 总试次数
    correctResponses: Number, // 正确次数
    incorrectResponses: Number, // 错误次数
    missedResponses: Number, // 遗漏次数
    averageReactionTime: Number, // 平均反应时（毫秒）
    accuracyRate: Number, // 准确率（百分比）
  },
  
  // 试次详细数据（可选，用于深度分析）
  trialData: [{
    trialNumber: Number,
    stimulusType: String, // 刺激类型
    response: String, // 用户反应
    correct: Boolean,
    reactionTime: Number, // 反应时（毫秒）
    timestamp: Date,
  }],
  
  // 游戏特定数据
  
  // 红灯绿灯特定数据
  redGreenLightData: {
    greenLightResponses: Number, // 绿灯时正确反应
    redLightInhibitions: Number, // 红灯时成功抑制
    falseAlarms: Number, // 红灯时错误反应
    missedGreens: Number, // 绿灯时未反应
    inhibitionRate: Number, // 抑制成功率
  },
  
  // 太空聚焦特定数据
  spaceFocusData: {
    asteroidsDestroyed: Number, // 摧毁的陨石
    asteroidsMissed: Number, // 漏掉的陨石
    friendlyFire: Number, // 误击友军
    vigilanceScore: Number, // 警觉性得分
    performanceDecline: Number, // 性能下降率（前后对比）
  },
  
  // 数字倒影特定数据
  numberMirrorData: {
    nBackLevel: Number, // N-back 等级 (1, 2, 3)
    correctMatches: Number, // 正确匹配
    falseMatches: Number, // 错误匹配
    missedMatches: Number, // 遗漏匹配
    workingMemoryCapacity: Number, // 工作记忆容量评分
  },
  
  // 色字游戏特定数据
  colorWordsData: {
    congruentTrials: Number, // 一致试次（如：红色的"红"）
    incongruentTrials: Number, // 不一致试次（如：红色的"蓝"）
    congruentAccuracy: Number, // 一致试次准确率
    incongruentAccuracy: Number, // 不一致试次准确率
    stroopEffect: Number, // Stroop效应（不一致RT - 一致RT）
    switchCost: Number, // 切换成本
  },
  
  // 猴子抓香蕉特定数据
  monkeyBananaData: {
    positiveRewards: Number, // 获得的正奖励
    penalties: Number, // 受到的惩罚
    learningCurve: Number, // 学习曲线斜率
    sensitivityToReward: Number, // 对奖励的敏感度
    sensitivityToPunishment: Number, // 对惩罚的敏感度
  },
  
  // 自适应难度数据
  adaptive: {
    startLevel: Number,
    endLevel: Number,
    adjustments: [{
      trial: Number,
      fromLevel: Number,
      toLevel: Number,
      reason: String, // 'performance-good', 'performance-poor'
    }],
  },
  
  // 奖励
  rewards: {
    points: { type: Number, default: 0 },
    experience: { type: Number, default: 0 }, // 对应能力的经验值
    achievements: [String],
  },
  
  // 用户反馈
  feedback: {
    difficulty: {
      type: String,
      enum: ['too-easy', 'appropriate', 'too-hard'],
    },
    enjoyment: {
      type: Number,
      min: 1,
      max: 5,
    },
    notes: String,
  },
  
  // 元数据
  createdAt: Date,
  updatedAt: Date,
}, {
  timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' },
  collection: 'training_records',
});

// ===========================
// 索引
// ===========================

TrainingRecordSchema.index({ userId: 1, startTime: -1 });
TrainingRecordSchema.index({ userId: 1, gameType: 1 });
TrainingRecordSchema.index({ userId: 1, gameType: 1, difficultyLevel: 1 });

// ===========================
// 静态方法
// ===========================

// 获取用户的训练历史
TrainingRecordSchema.statics.getUserHistory = function getUserHistory(userId, gameType = null, limit = 30) {
  const query = { userId };
  if (gameType) {
    query.gameType = gameType;
  }
  
  return this.find(query)
    .sort({ startTime: -1 })
    .limit(limit)
    .lean();
};

// 获取用户的训练统计
TrainingRecordSchema.statics.getUserStats = async function getUserStats(userId) {
  const records = await this.find({ userId, completed: true });
  
  const stats = {
    totalSessions: records.length,
    totalTime: 0,
    byGameType: {},
    overallPerformance: {
      averageAccuracy: 0,
      averageReactionTime: 0,
    },
  };
  
  let totalAccuracy = 0;
  let totalReactionTime = 0;
  let count = 0;
  
  records.forEach((record) => {
    stats.totalTime += record.durationSeconds;
    
    // 按游戏类型统计
    if (!stats.byGameType[record.gameType]) {
      stats.byGameType[record.gameType] = {
        count: 0,
        totalTime: 0,
        averageAccuracy: 0,
        averageLevel: 0,
      };
    }
    
    const gameStats = stats.byGameType[record.gameType];
    gameStats.count += 1;
    gameStats.totalTime += record.durationSeconds;
    gameStats.averageAccuracy += record.performance?.accuracyRate || 0;
    gameStats.averageLevel += record.difficultyLevel;
    
    // 总体性能
    if (record.performance) {
      totalAccuracy += record.performance.accuracyRate || 0;
      totalReactionTime += record.performance.averageReactionTime || 0;
      count += 1;
    }
  });
  
  // 计算平均值
  Object.keys(stats.byGameType).forEach((gameType) => {
    const gameStats = stats.byGameType[gameType];
    gameStats.averageAccuracy /= gameStats.count;
    gameStats.averageLevel /= gameStats.count;
  });
  
  if (count > 0) {
    stats.overallPerformance.averageAccuracy = totalAccuracy / count;
    stats.overallPerformance.averageReactionTime = totalReactionTime / count;
  }
  
  return stats;
};

// 获取用户的进步曲线
TrainingRecordSchema.statics.getProgressCurve = async function getProgressCurve(userId, gameType, days = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const records = await this.find({
    userId,
    gameType,
    startTime: { $gte: startDate },
    completed: true,
  }).sort({ startTime: 1 });
  
  const curve = records.map((record) => ({
    date: record.startTime,
    accuracy: record.performance?.accuracyRate || 0,
    reactionTime: record.performance?.averageReactionTime || 0,
    level: record.difficultyLevel,
  }));
  
  return curve;
};

// 获取推荐的训练游戏和难度
TrainingRecordSchema.statics.getRecommendedTraining = async function getRecommendedTraining(userId) {
  const stats = await this.getUserStats(userId);
  
  // 找出用户最薄弱的领域
  const gameTypes = [
    { type: 'red-green-light', ability: 'inhibition' },
    { type: 'space-focus', ability: 'attention' },
    { type: 'number-mirror', ability: 'workingMemory' },
    { type: 'color-words', ability: 'cognitiveFlexibility' },
    { type: 'monkey-banana', ability: 'rewardSensitivity' },
  ];
  
  const recommendations = [];
  
  for (const game of gameTypes) {
    const gameStats = stats.byGameType[game.type];
    
    if (!gameStats) {
      // 未玩过，推荐从初级开始
      recommendations.push({
        gameType: game.type,
        recommendedLevel: 1,
        reason: 'new-game',
        priority: 'medium',
      });
    } else {
      // 根据表现调整难度
      const avgAccuracy = gameStats.averageAccuracy;
      const currentLevel = gameStats.averageLevel;
      
      let recommendedLevel = currentLevel;
      let reason = 'maintain';
      let priority = 'low';
      
      if (avgAccuracy < 60) {
        recommendedLevel = Math.max(1, currentLevel - 1);
        reason = 'difficulty-too-high';
        priority = 'high';
      } else if (avgAccuracy > 85) {
        recommendedLevel = Math.min(10, currentLevel + 1);
        reason = 'ready-for-challenge';
        priority = 'medium';
      }
      
      recommendations.push({
        gameType: game.type,
        recommendedLevel,
        reason,
        priority,
        currentStats: {
          accuracy: avgAccuracy,
          level: currentLevel,
          sessions: gameStats.count,
        },
      });
    }
  }
  
  // 按优先级排序
  const priorityOrder = { high: 0, medium: 1, low: 2 };
  recommendations.sort((a, b) => priorityOrder[a.priority] - priorityOrder[b.priority]);
  
  return recommendations;
};

// ===========================
// 实例方法
// ===========================

// 完成训练
TrainingRecordSchema.methods.completeTraining = function completeTraining() {
  this.completed = true;
  this.endTime = new Date();
  
  // 计算奖励
  this.calculateRewards();
  
  return this.save();
};

// 计算奖励
TrainingRecordSchema.methods.calculateRewards = function calculateRewards() {
  if (!this.rewards) {
    this.rewards = { achievements: [] };
  }
  
  // 基础积分：每分钟2分
  const minutes = Math.ceil(this.durationSeconds / 60);
  let points = minutes * 2;
  
  // 难度加成
  points += this.difficultyLevel * 2;
  
  // 准确率加成
  if (this.performance && this.performance.accuracyRate) {
    const accuracy = this.performance.accuracyRate;
    if (accuracy >= 90) {
      points += 20;
    } else if (accuracy >= 80) {
      points += 10;
    } else if (accuracy >= 70) {
      points += 5;
    }
  }
  
  this.rewards.points = Math.max(5, points);
  
  // 经验值
  this.rewards.experience = points * 2;
};

// 添加试次数据
TrainingRecordSchema.methods.addTrial = function addTrial(trialData) {
  if (!this.trialData) {
    this.trialData = [];
  }
  
  this.trialData.push({
    trialNumber: this.trialData.length + 1,
    ...trialData,
    timestamp: new Date(),
  });
  
  return this;
};

// 更新性能统计
TrainingRecordSchema.methods.updatePerformance = function updatePerformance() {
  if (!this.trialData || this.trialData.length === 0) {
    return this;
  }
  
  const trials = this.trialData;
  const total = trials.length;
  const correct = trials.filter((t) => t.correct).length;
  const incorrect = trials.filter((t) => !t.correct && t.response).length;
  const missed = trials.filter((t) => !t.response).length;
  
  const reactionTimes = trials
    .filter((t) => t.reactionTime)
    .map((t) => t.reactionTime);
  
  const avgReactionTime = reactionTimes.length > 0
    ? reactionTimes.reduce((sum, rt) => sum + rt, 0) / reactionTimes.length
    : 0;
  
  this.performance = {
    totalTrials: total,
    correctResponses: correct,
    incorrectResponses: incorrect,
    missedResponses: missed,
    averageReactionTime: Math.round(avgReactionTime),
    accuracyRate: total > 0 ? Number(((correct / total) * 100).toFixed(1)) : 0,
  };
  
  return this;
};

// ===========================
// 导出
// ===========================

export const TrainingRecord = mongoose.model('TrainingRecord', TrainingRecordSchema);
export default TrainingRecord;

