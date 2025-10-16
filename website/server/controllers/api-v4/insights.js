/**
 * @module controllers/api-v4/insights
 * @description 灵感存储API - "贮水"功能
 */

import Insight from '../../models/insight';
import { authWithHeaders } from '../../middlewares/auth';

const api = {};

/**
 * @api {post} /api/v4/insights 创建灵感记录
 * @apiName CreateInsight
 * @apiGroup Insights
 *
 * @apiParam {String} content 内容
 * @apiParam {String} [type=text] 类型: text, voice, image, link
 * @apiParam {String} [category=idea] 分类: idea, todo, question, reminder, other
 * @apiParam {String[]} [tags] 标签
 * @apiParam {String} [priority=medium] 优先级: low, medium, high
 * @apiParam {Date} [remindAt] 提醒时间
 * @apiParam {Object} [location] 位置信息
 * @apiParam {Object} [createdDuring] 创建时的活动上下文
 */
api.createInsight = {
  method: 'POST',
  url: '/insights',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const {
      content,
      type,
      category,
      tags,
      priority,
      voiceUrl,
      voiceDuration,
      imageUrl,
      linkUrl,
      linkTitle,
      remindAt,
      location,
      createdDuring,
    } = req.body;

    if (!content || content.trim().length === 0) {
      throw new Error('Content is required');
    }

    const insight = new Insight({
      userId: user._id,
      content: content.trim(),
      type: type || 'text',
      category: category || 'idea',
      tags: tags || [],
      priority: priority || 'medium',
      voiceUrl,
      voiceDuration,
      imageUrl,
      linkUrl,
      linkTitle,
      remindAt: remindAt ? new Date(remindAt) : null,
      location,
      createdDuring,
    });

    await insight.save();

    res.respond(200, insight);
  },
};

/**
 * @api {get} /api/v4/insights 获取灵感列表
 * @apiName GetInsights
 * @apiGroup Insights
 *
 * @apiParam {Number} [limit=20] 返回数量
 * @apiParam {Number} [skip=0] 跳过数量
 * @apiParam {Boolean} [archived=false] 是否只看归档
 * @apiParam {Boolean} [converted] 是否已转换
 * @apiParam {String} [category] 分类筛选
 * @apiParam {String} [search] 搜索关键词
 */
api.getInsights = {
  method: 'GET',
  url: '/insights',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const {
      limit = 20,
      skip = 0,
      archived = false,
      converted,
      category,
      search,
    } = req.query;

    const query = { 
      userId: user._id,
      archived: archived === 'true' || archived === true,
    };

    if (converted !== undefined) {
      query.converted = converted === 'true' || converted === true;
    }

    if (category) {
      query.category = category;
    }

    let insights;
    if (search) {
      insights = await Insight.searchInsights(user._id, search);
    } else {
      insights = await Insight
        .find(query)
        .sort({ createdAt: -1 })
        .limit(Number(limit))
        .skip(Number(skip))
        .lean();
    }

    const total = await Insight.countDocuments(query);
    const inboxCount = await Insight.getInboxCount(user._id);

    res.respond(200, {
      insights,
      total,
      inboxCount,
      limit: Number(limit),
      skip: Number(skip),
    });
  },
};

/**
 * @api {get} /api/v4/insights/pending 获取待处理灵感
 * @apiName GetPendingInsights
 * @apiGroup Insights
 */
api.getPendingInsights = {
  method: 'GET',
  url: '/insights/pending',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { limit = 20 } = req.query;

    const insights = await Insight.findPending(user._id, Number(limit));
    const count = await Insight.getInboxCount(user._id);

    res.respond(200, {
      insights,
      count,
      message: count > 0 ? `你有 ${count} 条待处理的灵感` : '灵感池空空如也～',
    });
  },
};

/**
 * @api {get} /api/v4/insights/:insightId 获取单个灵感详情
 * @apiName GetInsight
 * @apiGroup Insights
 */
api.getInsight = {
  method: 'GET',
  url: '/insights/:insightId',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;

    const insight = await Insight.findOne({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    res.respond(200, insight);
  },
};

/**
 * @api {put} /api/v4/insights/:insightId 更新灵感
 * @apiName UpdateInsight
 * @apiGroup Insights
 */
api.updateInsight = {
  method: 'PUT',
  url: '/insights/:insightId',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;
    const {
      content,
      category,
      tags,
      priority,
      remindAt,
    } = req.body;

    const insight = await Insight.findOne({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    if (content) insight.content = content;
    if (category) insight.category = category;
    if (tags) insight.tags = tags;
    if (priority) insight.priority = priority;
    if (remindAt !== undefined) insight.remindAt = remindAt ? new Date(remindAt) : null;

    await insight.save();

    res.respond(200, insight);
  },
};

/**
 * @api {post} /api/v4/insights/:insightId/convert 转换为任务
 * @apiName ConvertInsightToTask
 * @apiGroup Insights
 *
 * @apiParam {String} [text] 任务文本
 * @apiParam {String} [type=todo] 任务类型
 * @apiParam {Object} [taskData] 其他任务数据
 */
api.convertToTask = {
  method: 'POST',
  url: '/insights/:insightId/convert',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;
    const taskData = req.body;

    const insight = await Insight.findOne({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    if (insight.converted) {
      throw new Error('Insight already converted');
    }

    const task = await insight.convertToTask(taskData);

    res.respond(200, {
      insight,
      task,
      message: '灵感已转换为任务',
    });
  },
};

/**
 * @api {post} /api/v4/insights/:insightId/archive 归档灵感
 * @apiName ArchiveInsight
 * @apiGroup Insights
 */
api.archiveInsight = {
  method: 'POST',
  url: '/insights/:insightId/archive',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;

    const insight = await Insight.findOne({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    await insight.archive();

    res.respond(200, {
      insight,
      message: '已归档',
    });
  },
};

/**
 * @api {post} /api/v4/insights/:insightId/unarchive 取消归档
 * @apiName UnarchiveInsight
 * @apiGroup Insights
 */
api.unarchiveInsight = {
  method: 'POST',
  url: '/insights/:insightId/unarchive',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;

    const insight = await Insight.findOne({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    await insight.unarchive();

    res.respond(200, {
      insight,
      message: '已恢复',
    });
  },
};

/**
 * @api {delete} /api/v4/insights/:insightId 删除灵感
 * @apiName DeleteInsight
 * @apiGroup Insights
 */
api.deleteInsight = {
  method: 'DELETE',
  url: '/insights/:insightId',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { insightId } = req.params;

    const insight = await Insight.findOneAndDelete({
      _id: insightId,
      userId: user._id,
    });

    if (!insight) {
      throw new Error('Insight not found');
    }

    res.respond(200, {
      message: '已删除',
    });
  },
};

/**
 * @api {post} /api/v4/insights/batch/archive 批量归档
 * @apiName BatchArchiveInsights
 * @apiGroup Insights
 *
 * @apiParam {String[]} ids 灵感ID列表
 */
api.batchArchive = {
  method: 'POST',
  url: '/insights/batch/archive',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { ids } = req.body;

    if (!Array.isArray(ids) || ids.length === 0) {
      throw new Error('Invalid ids');
    }

    const result = await Insight.updateMany(
      { _id: { $in: ids }, userId: user._id },
      { $set: { archived: true, archivedAt: new Date() } }
    );

    res.respond(200, {
      modifiedCount: result.modifiedCount,
      message: `已归档 ${result.modifiedCount} 条灵感`,
    });
  },
};

export default api;

