import mongoose from 'mongoose';

const { Schema } = mongoose;

const InterruptionSchema = new Schema({
  time: { type: Date, default: Date.now },
  reason: { 
    type: String, 
    enum: ['app-switch', 'phone-call', 'notification', 'user-pause', 'other'],
    default: 'other'
  },
  duration: { type: Number, default: 0 }, // 中断时长(秒)
}, { _id: false });

const FocusSessionSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  
  // 专注模式类型
  mode: {
    type: String,
    enum: ['pomodoro', 'noodle', 'adventure', 'mini-game'],
    required: true,
  },
  
  // 时长设置
  plannedDuration: { 
    type: Number, 
    required: true,
    min: 1,
    max: 240, // 最长4小时
  }, // 计划时长(分钟)
  
  actualDuration: { 
    type: Number, 
    default: 0,
  }, // 实际专注时长(分钟)
  
  // 时间记录
  startTime: { 
    type: Date, 
    default: Date.now,
    index: true,
  },
  
  endTime: { type: Date },
  
  pauseTime: { type: Date }, // 暂停时间
  
  resumeTime: { type: Date }, // 恢复时间
  
  // 完成状态
  status: {
    type: String,
    enum: ['active', 'paused', 'completed', 'abandoned'],
    default: 'active',
  },
  
  // 中断记录
  interrupted: { 
    type: Boolean, 
    default: false,
  },
  
  interruptions: [InterruptionSchema],
  
  interruptionCount: {
    type: Number,
    default: 0,
  },
  
  // 奖励
  pointsEarned: { 
    type: Number, 
    default: 0,
  },
  
  rewards: [{
    type: String, // 奖励ID或类型
    name: String,
    description: String,
  }],
  
  // 关联任务
  relatedTaskId: {
    type: Schema.Types.ObjectId,
    ref: 'Task',
  },
  
  taskName: String,
  
  // 特定模式数据
  modeData: {
    // 番茄钟
    pomodoroRound: Number, // 第几个番茄
    breakDuration: Number, // 休息时长
    
    // 专注面条
    noodleType: String, // 面条类型
    storyCardId: String, // 获得的故事卡片
    
    // 旅人冒险
    questLevel: Number,
    monstersDefeated: Number,
    expGained: Number,
    itemsCollected: [String],
  },
  
  // 设备信息
  deviceType: {
    type: String,
    enum: ['ios', 'android', 'web'],
  },
  
  deviceModel: String,
  
  // 环境数据
  ambientNoise: String, // 环境音乐设置
  
  notes: String, // 用户备注
  
}, { 
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// 索引
FocusSessionSchema.index({ userId: 1, startTime: -1 });
FocusSessionSchema.index({ status: 1, startTime: -1 });
FocusSessionSchema.index({ mode: 1, status: 1 });

// 虚拟字段
FocusSessionSchema.virtual('completionRate').get(function () {
  if (!this.plannedDuration) return 0;
  return Math.min((this.actualDuration / this.plannedDuration) * 100, 100);
});

FocusSessionSchema.virtual('isSuccessful').get(function () {
  return this.status === 'completed' && this.completionRate >= 80;
});

// 实例方法
FocusSessionSchema.methods.pause = function () {
  if (this.status !== 'active') return;
  this.status = 'paused';
  this.pauseTime = new Date();
};

FocusSessionSchema.methods.resume = function () {
  if (this.status !== 'paused') return;
  this.status = 'active';
  this.resumeTime = new Date();
};

FocusSessionSchema.methods.complete = function (actualMinutes) {
  this.status = 'completed';
  this.endTime = new Date();
  this.actualDuration = actualMinutes || this.plannedDuration;
  
  // 计算积分奖励
  const basePoints = this.actualDuration;
  let bonusMultiplier = 1;
  
  // 完成率奖励
  if (this.completionRate >= 100) bonusMultiplier += 0.2;
  else if (this.completionRate >= 90) bonusMultiplier += 0.1;
  
  // 无中断奖励
  if (this.interruptionCount === 0) bonusMultiplier += 0.3;
  else if (this.interruptionCount <= 2) bonusMultiplier += 0.1;
  
  // 连续专注奖励（需要外部判断）
  
  this.pointsEarned = Math.floor(basePoints * bonusMultiplier);
  
  return this.pointsEarned;
};

FocusSessionSchema.methods.abandon = function () {
  this.status = 'abandoned';
  this.endTime = new Date();
  
  // 计算实际时长
  const durationMs = this.endTime - this.startTime;
  this.actualDuration = Math.floor(durationMs / 1000 / 60);
  
  // 中途放弃仍给予少量积分
  this.pointsEarned = Math.floor(this.actualDuration * 0.3);
  
  return this.pointsEarned;
};

FocusSessionSchema.methods.recordInterruption = function (reason = 'other') {
  this.interrupted = true;
  this.interruptionCount += 1;
  this.interruptions.push({ 
    reason,
    time: new Date(),
  });
};

// 静态方法
FocusSessionSchema.statics.getStats = async function (userId, startDate, endDate) {
  const sessions = await this.find({
    userId,
    startTime: { $gte: startDate, $lte: endDate },
    status: { $in: ['completed', 'abandoned'] },
  });
  
  const totalSessions = sessions.length;
  const completedSessions = sessions.filter(s => s.status === 'completed').length;
  const totalMinutes = sessions.reduce((sum, s) => sum + s.actualDuration, 0);
  const totalPoints = sessions.reduce((sum, s) => sum + s.pointsEarned, 0);
  const totalInterruptions = sessions.reduce((sum, s) => sum + s.interruptionCount, 0);
  
  return {
    totalSessions,
    completedSessions,
    completionRate: totalSessions > 0 ? (completedSessions / totalSessions * 100).toFixed(1) : 0,
    totalMinutes,
    totalHours: (totalMinutes / 60).toFixed(1),
    totalPoints,
    averageMinutesPerSession: totalSessions > 0 ? (totalMinutes / totalSessions).toFixed(1) : 0,
    totalInterruptions,
    averageInterruptionsPerSession: totalSessions > 0 ? (totalInterruptions / totalSessions).toFixed(1) : 0,
    modeDistribution: sessions.reduce((acc, s) => {
      acc[s.mode] = (acc[s.mode] || 0) + 1;
      return acc;
    }, {}),
  };
};

const FocusSession = mongoose.model('FocusSession', FocusSessionSchema);

export default FocusSession;
