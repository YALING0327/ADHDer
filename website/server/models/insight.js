import mongoose from 'mongoose';

const { Schema } = mongoose;

const InsightSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
  },
  
  // 内容
  content: {
    type: String,
    required: true,
    maxlength: 2000,
  },
  
  // 类型
  type: {
    type: String,
    enum: ['text', 'voice', 'image', 'link'],
    default: 'text',
  },
  
  // 媒体文件
  voiceUrl: String,
  voiceDuration: Number, // 秒
  
  imageUrl: String,
  
  linkUrl: String,
  linkTitle: String,
  
  // 分类
  category: {
    type: String,
    enum: ['idea', 'todo', 'question', 'reminder', 'other'],
    default: 'idea',
  },
  
  tags: [{
    type: String,
    trim: true,
  }],
  
  // 转换状态
  converted: {
    type: Boolean,
    default: false,
  },
  
  convertedTo: {
    type: String,
    enum: ['task', 'event', 'note'],
  },
  
  taskId: {
    type: Schema.Types.ObjectId,
    ref: 'Task',
  },
  
  // 优先级
  priority: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium',
  },
  
  // 上下文
  createdDuring: {
    activityType: String, // 'focusing', 'training', 'browsing'
    sessionId: Schema.Types.ObjectId,
  },
  
  location: {
    latitude: Number,
    longitude: Number,
    placeName: String,
  },
  
  // 状态
  archived: {
    type: Boolean,
    default: false,
  },
  
  archivedAt: Date,
  
  reminded: {
    type: Boolean,
    default: false,
  },
  
  remindAt: Date,
  
  // 附加数据
  metadata: Schema.Types.Mixed,
  
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// 索引
InsightSchema.index({ userId: 1, createdAt: -1 });
InsightSchema.index({ userId: 1, category: 1 });
InsightSchema.index({ userId: 1, converted: 1 });
InsightSchema.index({ userId: 1, archived: 1, createdAt: -1 });
InsightSchema.index({ userId: 1, remindAt: 1 }, { 
  partialFilterExpression: { reminded: false, remindAt: { $exists: true } } 
});

// 文本搜索
InsightSchema.index({ content: 'text', tags: 'text' });

// 虚拟字段
InsightSchema.virtual('age').get(function () {
  const now = new Date();
  const created = this.createdAt;
  const diffMs = now - created;
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  
  if (diffDays === 0) return 'today';
  if (diffDays === 1) return '1 day ago';
  if (diffDays < 7) return `${diffDays} days ago`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago';
  return `${Math.floor(diffDays / 30)} months ago`;
});

// 实例方法
InsightSchema.methods.convertToTask = async function (taskData) {
  const Task = mongoose.model('Task');
  
  const task = new Task({
    userId: this.userId,
    text: taskData.text || this.content,
    type: taskData.type || 'todo',
    notes: `来自灵感: ${this.content.substring(0, 50)}...`,
    priority: this.priority === 'high' ? 2 : this.priority === 'medium' ? 1.5 : 1,
    ...taskData,
  });
  
  await task.save();
  
  this.converted = true;
  this.convertedTo = 'task';
  this.taskId = task._id;
  await this.save();
  
  return task;
};

InsightSchema.methods.archive = function () {
  this.archived = true;
  this.archivedAt = new Date();
  return this.save();
};

InsightSchema.methods.unarchive = function () {
  this.archived = false;
  this.archivedAt = null;
  return this.save();
};

// 静态方法
InsightSchema.statics.getInboxCount = function (userId) {
  return this.countDocuments({
    userId,
    archived: false,
    converted: false,
  });
};

InsightSchema.statics.findPending = function (userId, limit = 20) {
  return this.find({
    userId,
    archived: false,
    converted: false,
  })
    .sort({ createdAt: -1 })
    .limit(limit)
    .lean();
};

InsightSchema.statics.searchInsights = function (userId, query) {
  return this.find({
    userId,
    archived: false,
    $text: { $search: query },
  }, {
    score: { $meta: 'textScore' },
  })
    .sort({ score: { $meta: 'textScore' } })
    .limit(20)
    .lean();
};

InsightSchema.statics.getDueReminders = function () {
  return this.find({
    reminded: false,
    remindAt: { $lte: new Date() },
  })
    .populate('userId', 'auth.local.email profile.name')
    .lean();
};

const Insight = mongoose.model('Insight', InsightSchema);

export default Insight;

