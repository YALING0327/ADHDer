import mongoose from 'mongoose';

const { Schema } = mongoose;

const TrainingRecordSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  
  // 游戏类型
  gameType: {
    type: String,
    enum: [
      'go-nogo',      // 反应抑制: 红灯绿灯
      'nback',        // 工作记忆: N-back测试
      'stroop',       // 认知灵活性: Stroop任务
      'cpt',          // 持续注意力: CPT测试
      'attention-bubble', // 专注泡泡小游戏
      'memory-match', // 记忆配对
      'other',
    ],
    required: true,
  },
  
  // 难度和关卡
  difficultyLevel: {
    type: Number,
    default: 1,
    min: 1,
    max: 20,
  },
  
  round: {
    type: Number,
    default: 1,
  },
  
  // 成绩数据
  score: {
    type: Number,
    default: 0,
  },
  
  maxScore: Number,
  
  // 准确率
  totalTrials: {
    type: Number,
    default: 0,
  },
  
  correctTrials: {
    type: Number,
    default: 0,
  },
  
  incorrectTrials: {
    type: Number,
    default: 0,
  },
  
  missedTrials: {
    type: Number,
    default: 0,
  },
  
  accuracy: {
    type: Number,
    default: 0,
    min: 0,
    max: 100,
  },
  
  // 反应时间
  averageReactionTime: {
    type: Number,
    default: 0,
  }, // 毫秒
  
  medianReactionTime: Number,
  
  reactionTimes: [Number], // 每次试验的反应时间
  
  // 时长
  duration: {
    type: Number,
    required: true,
  }, // 秒
  
  startTime: {
    type: Date,
    default: Date.now,
  },
  
  endTime: Date,
  
  // 完成状态
  completed: {
    type: Boolean,
    default: false,
  },
  
  abandoned: {
    type: Boolean,
    default: false,
  },
  
  // 特定游戏数据
  gameData: {
    // Go/No-Go特定
    goTrials: Number,
    nogoTrials: Number,
    falseAlarms: Number, // 错误按键
    
    // N-back特定
    nLevel: Number, // 1-back, 2-back, 3-back
    sequenceLength: Number,
    
    // Stroop特定
    congruentTrials: Number,
    incongruentTrials: Number,
    neutralTrials: Number,
    stroopEffect: Number, // 干扰效应
    
    // CPT特定
    targetHits: Number,
    targetMisses: Number,
    distractorRejections: Number,
    falseAlarms: Number,
    
    // 其他游戏特定数据
    custom: Schema.Types.Mixed,
  },
  
  // 进步指标
  improvementFromLastSession: {
    score: Number,
    accuracy: Number,
    reactionTime: Number,
  },
  
  // 奖励
  pointsEarned: {
    type: Number,
    default: 0,
  },
  
  achievements: [{
    type: String,
    name: String,
    description: String,
  }],
  
  // 设备和环境
  deviceType: {
    type: String,
    enum: ['ios', 'android', 'web'],
  },
  
  notes: String,
  
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// 索引
TrainingRecordSchema.index({ userId: 1, gameType: 1, startTime: -1 });
TrainingRecordSchema.index({ userId: 1, completed: 1, startTime: -1 });
TrainingRecordSchema.index({ gameType: 1, difficultyLevel: 1 });

// 虚拟字段
TrainingRecordSchema.virtual('performanceGrade').get(function () {
  if (this.accuracy >= 95) return 'S';
  if (this.accuracy >= 90) return 'A';
  if (this.accuracy >= 80) return 'B';
  if (this.accuracy >= 70) return 'C';
  if (this.accuracy >= 60) return 'D';
  return 'F';
});

TrainingRecordSchema.virtual('stars').get(function () {
  if (this.accuracy >= 95) return 3;
  if (this.accuracy >= 85) return 2;
  if (this.accuracy >= 70) return 1;
  return 0;
});

// 计算准确率
TrainingRecordSchema.methods.calculateAccuracy = function () {
  if (this.totalTrials === 0) {
    this.accuracy = 0;
    return 0;
  }
  
  this.accuracy = (this.correctTrials / this.totalTrials) * 100;
  return this.accuracy;
};

// 计算平均反应时间
TrainingRecordSchema.methods.calculateAverageReactionTime = function () {
  if (!this.reactionTimes || this.reactionTimes.length === 0) {
    this.averageReactionTime = 0;
    return 0;
  }
  
  const sum = this.reactionTimes.reduce((a, b) => a + b, 0);
  this.averageReactionTime = Math.round(sum / this.reactionTimes.length);
  
  // 计算中位数
  const sorted = [...this.reactionTimes].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  this.medianReactionTime = sorted.length % 2 !== 0 
    ? sorted[mid] 
    : (sorted[mid - 1] + sorted[mid]) / 2;
  
  return this.averageReactionTime;
};

// 完成训练
TrainingRecordSchema.methods.complete = function () {
  this.completed = true;
  this.endTime = new Date();
  
  this.calculateAccuracy();
  this.calculateAverageReactionTime();
  
  // 计算积分奖励
  let points = this.score || 0;
  
  // 准确率奖励
  if (this.accuracy >= 95) points += 50;
  else if (this.accuracy >= 90) points += 30;
  else if (this.accuracy >= 80) points += 20;
  else if (this.accuracy >= 70) points += 10;
  
  // 难度奖励
  points += this.difficultyLevel * 5;
  
  // 完成奖励
  points += 10;
  
  this.pointsEarned = points;
  
  return this;
};

// 静态方法
TrainingRecordSchema.statics.getProgress = async function (userId, gameType) {
  const records = await this.find({
    userId,
    gameType,
    completed: true,
  })
    .sort({ startTime: -1 })
    .limit(30)
    .lean();
  
  if (records.length === 0) {
    return null;
  }
  
  const latest = records[0];
  const totalSessions = records.length;
  const averageAccuracy = records.reduce((sum, r) => sum + r.accuracy, 0) / totalSessions;
  const averageReactionTime = records.reduce((sum, r) => sum + r.averageReactionTime, 0) / totalSessions;
  const totalPoints = records.reduce((sum, r) => sum + r.pointsEarned, 0);
  
  // 计算趋势（最近5次 vs 之前5次）
  const recent5 = records.slice(0, Math.min(5, records.length));
  const previous5 = records.slice(5, Math.min(10, records.length));
  
  let trend = 'stable';
  if (previous5.length > 0) {
    const recentAvg = recent5.reduce((sum, r) => sum + r.accuracy, 0) / recent5.length;
    const previousAvg = previous5.reduce((sum, r) => sum + r.accuracy, 0) / previous5.length;
    
    if (recentAvg > previousAvg + 5) trend = 'improving';
    else if (recentAvg < previousAvg - 5) trend = 'declining';
  }
  
  return {
    gameType,
    totalSessions,
    latestLevel: latest.difficultyLevel,
    latestAccuracy: latest.accuracy,
    latestReactionTime: latest.averageReactionTime,
    averageAccuracy: Math.round(averageAccuracy),
    averageReactionTime: Math.round(averageReactionTime),
    totalPoints,
    trend,
    recentRecords: recent5,
  };
};

TrainingRecordSchema.statics.getAllGameProgress = async function (userId) {
  const gameTypes = ['go-nogo', 'nback', 'stroop', 'cpt', 'attention-bubble'];
  const progressList = [];
  
  for (const gameType of gameTypes) {
    const progress = await this.getProgress(userId, gameType);
    if (progress) {
      progressList.push(progress);
    }
  }
  
  return progressList;
};

TrainingRecordSchema.statics.getStats = async function (userId, startDate, endDate) {
  const records = await this.find({
    userId,
    startTime: { $gte: startDate, $lte: endDate },
    completed: true,
  });
  
  const totalSessions = records.length;
  const totalMinutes = records.reduce((sum, r) => sum + (r.duration / 60), 0);
  const totalPoints = records.reduce((sum, r) => sum + r.pointsEarned, 0);
  const averageAccuracy = totalSessions > 0 
    ? records.reduce((sum, r) => sum + r.accuracy, 0) / totalSessions 
    : 0;
  
  return {
    totalSessions,
    totalMinutes: Math.round(totalMinutes),
    totalPoints,
    averageAccuracy: Math.round(averageAccuracy),
    gameTypeDistribution: records.reduce((acc, r) => {
      acc[r.gameType] = (acc[r.gameType] || 0) + 1;
      return acc;
    }, {}),
  };
};

const TrainingRecord = mongoose.model('TrainingRecord', TrainingRecordSchema);

export default TrainingRecord;
