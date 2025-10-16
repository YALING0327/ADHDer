/**
 * ADHDER Inspiration Model
 * 灵感贮水 - 快速记录想法和创意
 */

import mongoose from 'mongoose';

const { Schema } = mongoose;

const InspirationSchema = new Schema({
  userId: { type: String, ref: 'User', required: true, index: true },
  
  // 内容
  content: { type: String, required: true, maxlength: 500 },
  
  // 类型
  type: {
    type: String,
    enum: [
      'idea', // 想法
      'todo', // 待办
      'note', // 笔记
      'question', // 问题
      'quote', // 引用
      'link', // 链接
      'other', // 其他
    ],
    default: 'idea',
    index: true,
  },
  
  // 标签
  tags: [String],
  
  // 情境信息（自动捕获）
  context: {
    location: String, // GPS位置
    activity: String, // 当前活动（如：专注中、休息中）
    time: { type: Date, default: Date.now },
    weather: String, // 天气
  },
  
  // 附件
  attachments: [{
    type: {
      type: String,
      enum: ['image', 'audio', 'file'],
    },
    url: String,
    filename: String,
    size: Number, // bytes
  }],
  
  // 状态
  status: {
    type: String,
    enum: ['new', 'reviewing', 'processed', 'archived'],
    default: 'new',
    index: true,
  },
  
  // 处理结果
  processed: {
    convertedToTask: Boolean, // 是否转换为任务
    taskId: { type: Schema.Types.ObjectId, ref: 'Task' },
    addedToNote: Boolean, // 是否添加到笔记
    noteId: Schema.Types.ObjectId,
    processedAt: Date,
  },
  
  // 优先级（用户可标记）
  priority: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium',
  },
  
  // 收藏
  starred: { type: Boolean, default: false, index: true },
  
  // AI分析结果（可选）
  aiAnalysis: {
    sentiment: {
      type: String,
      enum: ['positive', 'neutral', 'negative'],
    },
    suggestedTags: [String],
    suggestedAction: {
      type: String,
      enum: ['create-task', 'save-for-later', 'research-more', 'discard'],
    },
    category: String,
  },
  
  // 提醒
  reminder: {
    enabled: { type: Boolean, default: false },
    time: Date,
    sent: { type: Boolean, default: false },
  },
  
  // 元数据
  createdAt: Date,
  updatedAt: Date,
}, {
  timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' },
  collection: 'inspirations',
});

// ===========================
// 索引
// ===========================

InspirationSchema.index({ userId: 1, createdAt: -1 });
InspirationSchema.index({ userId: 1, type: 1 });
InspirationSchema.index({ userId: 1, status: 1 });
InspirationSchema.index({ userId: 1, starred: 1 });
InspirationSchema.index({ tags: 1 });
InspirationSchema.index({ 'reminder.time': 1, 'reminder.sent': 1 });

// 全文搜索索引
InspirationSchema.index({ content: 'text', tags: 'text' });

// ===========================
// 静态方法
// ===========================

// 获取用户的灵感列表
InspirationSchema.statics.getUserInspirations = function getUserInspirations(
  userId,
  options = {}
) {
  const {
    type = null,
    status = null,
    starred = null,
    limit = 50,
    skip = 0,
    sortBy = 'createdAt',
    sortOrder = 'desc',
  } = options;

  const query = { userId };

  if (type) query.type = type;
  if (status) query.status = status;
  if (starred !== null) query.starred = starred;

  const sortOptions = {};
  sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;

  return this.find(query)
    .sort(sortOptions)
    .limit(limit)
    .skip(skip)
    .lean();
};

// 搜索灵感
InspirationSchema.statics.searchInspirations = function searchInspirations(
  userId,
  searchTerm,
  options = {}
) {
  const {
    limit = 20,
    skip = 0,
  } = options;

  return this.find({
    userId,
    $text: { $search: searchTerm },
  }, {
    score: { $meta: 'textScore' },
  })
    .sort({ score: { $meta: 'textScore' } })
    .limit(limit)
    .skip(skip)
    .lean();
};

// 获取用户的标签列表（用于筛选和自动完成）
InspirationSchema.statics.getUserTags = async function getUserTags(userId) {
  const inspirations = await this.find({ userId }, { tags: 1 });
  
  const tagCounts = {};
  
  inspirations.forEach((inspiration) => {
    if (inspiration.tags) {
      inspiration.tags.forEach((tag) => {
        tagCounts[tag] = (tagCounts[tag] || 0) + 1;
      });
    }
  });
  
  // 转换为数组并按使用次数排序
  const tags = Object.keys(tagCounts).map((tag) => ({
    name: tag,
    count: tagCounts[tag],
  }));
  
  tags.sort((a, b) => b.count - a.count);
  
  return tags;
};

// 获取待处理的灵感
InspirationSchema.statics.getPendingInspirations = function getPendingInspirations(userId) {
  return this.find({
    userId,
    status: { $in: ['new', 'reviewing'] },
  }).sort({ createdAt: -1 });
};

// 获取需要提醒的灵感
InspirationSchema.statics.getDueReminders = function getDueReminders() {
  const now = new Date();
  
  return this.find({
    'reminder.enabled': true,
    'reminder.sent': false,
    'reminder.time': { $lte: now },
  });
};

// 批量更新状态
InspirationSchema.statics.batchUpdateStatus = function batchUpdateStatus(
  userId,
  inspirationIds,
  newStatus
) {
  return this.updateMany(
    {
      _id: { $in: inspirationIds },
      userId, // 确保只更新用户自己的灵感
    },
    {
      $set: { status: newStatus },
    }
  );
};

// 获取统计数据
InspirationSchema.statics.getStats = async function getStats(userId, days = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const inspirations = await this.find({
    userId,
    createdAt: { $gte: startDate },
  });
  
  const stats = {
    total: inspirations.length,
    byType: {},
    byStatus: {},
    processed: 0,
    convertedToTasks: 0,
    starred: 0,
    dailyAverage: 0,
  };
  
  inspirations.forEach((inspiration) => {
    // 按类型统计
    stats.byType[inspiration.type] = (stats.byType[inspiration.type] || 0) + 1;
    
    // 按状态统计
    stats.byStatus[inspiration.status] = (stats.byStatus[inspiration.status] || 0) + 1;
    
    // 其他统计
    if (inspiration.status === 'processed' || inspiration.status === 'archived') {
      stats.processed++;
    }
    
    if (inspiration.processed && inspiration.processed.convertedToTask) {
      stats.convertedToTasks++;
    }
    
    if (inspiration.starred) {
      stats.starred++;
    }
  });
  
  stats.dailyAverage = Number((stats.total / days).toFixed(1));
  
  return stats;
};

// ===========================
// 实例方法
// ===========================

// 转换为任务
InspirationSchema.methods.convertToTask = async function convertToTask() {
  const { Task, DeadlineTask, FreeTask } = require('./task/adhder-schema');
  
  // 根据内容判断任务类型
  // 这里简化处理，实际可能需要AI分析
  const hasDeadlineKeywords = /明天|今天|本周|下周|截止|deadline/i.test(this.content);
  
  let task;
  
  if (hasDeadlineKeywords) {
    // 创建deadline任务
    const deadline = this.aiAnalysis?.suggestedDeadline || new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 默认7天后
    
    task = new DeadlineTask({
      userId: this.userId,
      title: this.content.substring(0, 100), // 截取前100字符作为标题
      notes: this.content,
      deadline,
      tags: this.tags,
    });
  } else {
    // 创建自由任务
    task = new FreeTask({
      userId: this.userId,
      title: this.content.substring(0, 100),
      notes: this.content,
      priority: this.priority,
      tags: this.tags,
    });
  }
  
  await task.save();
  
  // 更新处理状态
  this.status = 'processed';
  this.processed = {
    convertedToTask: true,
    taskId: task._id,
    processedAt: new Date(),
  };
  
  await this.save();
  
  return task;
};

// 添加标签
InspirationSchema.methods.addTag = function addTag(tag) {
  if (!this.tags.includes(tag)) {
    this.tags.push(tag);
  }
  return this.save();
};

// 移除标签
InspirationSchema.methods.removeTag = function removeTag(tag) {
  this.tags = this.tags.filter((t) => t !== tag);
  return this.save();
};

// 切换收藏状态
InspirationSchema.methods.toggleStar = function toggleStar() {
  this.starred = !this.starred;
  return this.save();
};

// 归档
InspirationSchema.methods.archive = function archive() {
  this.status = 'archived';
  return this.save();
};

// 设置提醒
InspirationSchema.methods.setReminder = function setReminder(time) {
  this.reminder = {
    enabled: true,
    time,
    sent: false,
  };
  return this.save();
};

// 取消提醒
InspirationSchema.methods.cancelReminder = function cancelReminder() {
  this.reminder = {
    enabled: false,
    time: null,
    sent: false,
  };
  return this.save();
};

// 标记提醒已发送
InspirationSchema.methods.markReminderSent = function markReminderSent() {
  if (this.reminder) {
    this.reminder.sent = true;
  }
  return this.save();
};

// 添加AI分析
InspirationSchema.methods.addAIAnalysis = function addAIAnalysis(analysis) {
  this.aiAnalysis = analysis;
  return this.save();
};

// ===========================
// 中间件
// ===========================

// 保存前自动分析（如果启用AI）
InspirationSchema.pre('save', async function preSave(next) {
  // 如果是新创建的灵感，且内容超过10个字符，可以触发AI分析
  if (this.isNew && this.content && this.content.length > 10) {
    // 这里可以调用AI服务进行分析
    // 目前先跳过，实际实现时添加
  }
  next();
});

// ===========================
// 虚拟字段
// ===========================

// 灵感年龄（创建至今的天数）
InspirationSchema.virtual('age').get(function getAge() {
  const now = new Date();
  const diff = now - this.createdAt;
  return Math.floor(diff / (1000 * 60 * 60 * 24));
});

// 是否已处理
InspirationSchema.virtual('isProcessed').get(function getIsProcessed() {
  return this.status === 'processed' || this.status === 'archived';
});

// ===========================
// 导出
// ===========================

export const Inspiration = mongoose.model('Inspiration', InspirationSchema);
export default Inspiration;

