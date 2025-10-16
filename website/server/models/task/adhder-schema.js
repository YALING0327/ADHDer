/**
 * ADHDER Task Schema (简化版)
 * 
 * 两种任务类型：
 * 1. DeadlineTask - 有截止日期的任务（紧急任务）
 * 2. FreeTask - 无截止日期的任务（自由任务）
 */

import mongoose from 'mongoose';

const { Schema } = mongoose;

// ===========================
// 通用字段 Schema
// ===========================

const ChecklistItemSchema = new Schema({
  id: { type: String, required: true },
  text: { type: String, required: true },
  completed: { type: Boolean, default: false },
  completedDate: Date,
}, { _id: false });

const ReminderSchema = new Schema({
  id: { type: String, required: true },
  time: { type: Date, required: true },
  sent: { type: Boolean, default: false },
}, { _id: false });

const TagSchema = new Schema({
  id: { type: String, required: true },
  name: String,
  color: String,
}, { _id: false });

// ===========================
// 基础 Task Schema
// ===========================

const BaseTaskOptions = {
  discriminatorKey: 'type',
  collection: 'tasks',
  timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' },
};

const BaseTaskSchema = new Schema({
  userId: { type: String, ref: 'User', required: true, index: true },
  
  // 基础信息
  title: { type: String, required: true, maxlength: 100 },
  notes: { type: String, maxlength: 3000 },
  
  // 状态
  completed: { type: Boolean, default: false, index: true },
  completedDate: Date,
  archived: { type: Boolean, default: false, index: true },
  
  // 清单
  checklist: [ChecklistItemSchema],
  
  // 提醒
  reminders: [ReminderSchema],
  
  // 标签
  tags: [TagSchema],
  
  // 时间估算
  estimatedMinutes: Number, // 预计耗时
  actualMinutes: Number, // 实际耗时
  
  // 专注会话记录
  focusSessions: [{
    sessionId: { type: Schema.Types.ObjectId, ref: 'FocusSession' },
    minutes: Number,
    completedAt: Date,
  }],
  
  // 元数据
  createdAt: Date,
  updatedAt: Date,
}, BaseTaskOptions);

// ===========================
// DeadlineTask - 有截止日期的任务
// ===========================

const DeadlineTaskSchema = new Schema({
  // 时间相关
  deadline: { type: Date, required: true, index: true },
  startDate: Date, // 可选的开始日期
  
  // 里程碑（用于大任务分解）
  milestones: [{
    title: String,
    deadline: Date,
    completed: { type: Boolean, default: false },
    completedDate: Date,
  }],
  
  // 紧急程度（根据截止日期自动计算）
  urgencyLevel: {
    type: String,
    enum: ['low', 'medium', 'high', 'urgent'],
    default: 'medium',
  },
  
  // 重复设置（for 定期deadline任务）
  repeat: {
    enabled: { type: Boolean, default: false },
    frequency: {
      type: String,
      enum: ['daily', 'weekly', 'monthly'],
    },
    interval: Number, // 每隔几天/周/月
    endDate: Date, // 重复结束日期
  },
}, BaseTaskOptions);

// ===========================
// FreeTask - 无截止日期的任务
// ===========================

const FreeTaskSchema = new Schema({
  // 优先级
  priority: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium',
    index: true,
  },
  
  // 分类
  category: {
    type: String,
    enum: ['work', 'study', 'health', 'personal', 'social', 'creative', 'learning', 'other'],
    default: 'other',
    index: true,
  },
  
  // AI推荐的完成日期（可选）
  suggestedDate: Date,
  
  // 能量需求（帮助用户选择合适精力状态下完成的任务）
  energyLevel: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium',
  },
  
  // 适合的专注模式
  suggestedFocusMode: {
    type: String,
    enum: ['pomodoro', 'focus-noodles', 'traveler-adventure'],
  },
}, BaseTaskOptions);

// ===========================
// 模型创建
// ===========================

const Task = mongoose.model('Task', BaseTaskSchema);
const DeadlineTask = Task.discriminator('deadline', DeadlineTaskSchema);
const FreeTask = Task.discriminator('free', FreeTaskSchema);

// ===========================
// 索引
// ===========================

BaseTaskSchema.index({ userId: 1, completed: 1 });
BaseTaskSchema.index({ userId: 1, archived: 1 });
BaseTaskSchema.index({ 'tags.id': 1 });

DeadlineTaskSchema.index({ userId: 1, deadline: 1 });
DeadlineTaskSchema.index({ userId: 1, urgencyLevel: 1 });

FreeTaskSchema.index({ userId: 1, priority: 1 });
FreeTaskSchema.index({ userId: 1, category: 1 });

// ===========================
// 静态方法
// ===========================

// 获取用户的所有未完成任务
BaseTaskSchema.statics.getActiveTasks = function getActiveTasks(userId) {
  return this.find({
    userId,
    completed: false,
    archived: false,
  }).sort({ createdAt: -1 });
};

// 获取用户的deadline任务（按紧急程度排序）
DeadlineTaskSchema.statics.getUpcomingDeadlines = function getUpcomingDeadlines(userId, days = 7) {
  const endDate = new Date();
  endDate.setDate(endDate.getDate() + days);

  return this.find({
    userId,
    completed: false,
    archived: false,
    deadline: { $lte: endDate },
  }).sort({ deadline: 1 });
};

// 获取用户的过期任务
DeadlineTaskSchema.statics.getOverdueTasks = function getOverdueTasks(userId) {
  return this.find({
    userId,
    completed: false,
    archived: false,
    deadline: { $lt: new Date() },
  }).sort({ deadline: 1 });
};

// 获取用户的自由任务（按优先级排序）
FreeTaskSchema.statics.getByPriority = function getByPriority(userId, priority) {
  const query = {
    userId,
    completed: false,
    archived: false,
  };

  if (priority) {
    query.priority = priority;
  }

  return this.find(query).sort({ priority: -1, createdAt: -1 });
};

// 获取用户的分类任务
FreeTaskSchema.statics.getByCategory = function getByCategory(userId, category) {
  return this.find({
    userId,
    category,
    completed: false,
    archived: false,
  }).sort({ priority: -1, createdAt: -1 });
};

// ===========================
// 实例方法
// ===========================

// 完成任务
BaseTaskSchema.methods.complete = function complete() {
  this.completed = true;
  this.completedDate = new Date();
  return this.save();
};

// 取消完成
BaseTaskSchema.methods.uncomplete = function uncomplete() {
  this.completed = false;
  this.completedDate = null;
  return this.save();
};

// 归档任务
BaseTaskSchema.methods.archive = function archive() {
  this.archived = true;
  return this.save();
};

// 记录专注会话
BaseTaskSchema.methods.addFocusSession = function addFocusSession(sessionId, minutes) {
  this.focusSessions.push({
    sessionId,
    minutes,
    completedAt: new Date(),
  });
  
  // 更新实际耗时
  if (!this.actualMinutes) {
    this.actualMinutes = 0;
  }
  this.actualMinutes += minutes;
  
  return this.save();
};

// 更新紧急程度（DeadlineTask专用）
DeadlineTaskSchema.methods.updateUrgency = function updateUrgency() {
  const now = new Date();
  const timeLeft = this.deadline - now;
  const daysLeft = Math.ceil(timeLeft / (1000 * 60 * 60 * 24));

  if (daysLeft < 0) {
    this.urgencyLevel = 'urgent';
  } else if (daysLeft === 0) {
    this.urgencyLevel = 'urgent';
  } else if (daysLeft <= 1) {
    this.urgencyLevel = 'urgent';
  } else if (daysLeft <= 3) {
    this.urgencyLevel = 'high';
  } else if (daysLeft <= 7) {
    this.urgencyLevel = 'medium';
  } else {
    this.urgencyLevel = 'low';
  }

  return this.save();
};

// 添加里程碑
DeadlineTaskSchema.methods.addMilestone = function addMilestone(title, deadline) {
  this.milestones.push({
    title,
    deadline,
    completed: false,
  });
  return this.save();
};

// 完成里程碑
DeadlineTaskSchema.methods.completeMilestone = function completeMilestone(milestoneIndex) {
  if (this.milestones[milestoneIndex]) {
    this.milestones[milestoneIndex].completed = true;
    this.milestones[milestoneIndex].completedDate = new Date();
  }
  return this.save();
};

// ===========================
// 中间件（Middleware）
// ===========================

// 保存前自动更新紧急程度
DeadlineTaskSchema.pre('save', function preSave(next) {
  if (this.isModified('deadline') && this.deadline && !this.completed) {
    const now = new Date();
    const timeLeft = this.deadline - now;
    const daysLeft = Math.ceil(timeLeft / (1000 * 60 * 60 * 24));

    if (daysLeft < 0 || daysLeft === 0) {
      this.urgencyLevel = 'urgent';
    } else if (daysLeft <= 1) {
      this.urgencyLevel = 'urgent';
    } else if (daysLeft <= 3) {
      this.urgencyLevel = 'high';
    } else if (daysLeft <= 7) {
      this.urgencyLevel = 'medium';
    } else {
      this.urgencyLevel = 'low';
    }
  }
  next();
});

// ===========================
// 导出
// ===========================

export {
  Task,
  DeadlineTask,
  FreeTask,
};

export default Task;

