/**
 * @module controllers/api-v4/focus
 * @description 专注会话管理API
 */

import FocusSession from '../../models/focus-session';
import { authWithHeaders } from '../../middlewares/auth';
import { model as User } from '../../models/user';

const api = {};

/**
 * @api {post} /api/v4/focus/sessions 开始专注会话
 * @apiName CreateFocusSession
 * @apiGroup Focus
 *
 * @apiParam {String} mode 专注模式: pomodoro, noodle, adventure
 * @apiParam {Number} duration 计划时长(分钟)
 * @apiParam {String} [taskId] 关联任务ID
 * @apiParam {String} [taskName] 任务名称
 * @apiParam {Object} [modeData] 特定模式数据
 *
 * @apiSuccess {Object} data 创建的专注会话
 */
api.createFocusSession = {
  method: 'POST',
  url: '/focus/sessions',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const {
      mode,
      duration,
      taskId,
      taskName,
      modeData,
    } = req.body;

    // 验证参数
    if (!mode || !['pomodoro', 'noodle', 'adventure', 'mini-game'].includes(mode)) {
      throw new Error('Invalid focus mode');
    }

    if (!duration || duration < 1 || duration > 240) {
      throw new Error('Duration must be between 1 and 240 minutes');
    }

    // 检查是否有正在进行的会话
    const activeSession = await FocusSession.findOne({
      userId: user._id,
      status: { $in: ['active', 'paused'] },
    });

    if (activeSession) {
      throw new Error('You already have an active focus session. Please complete or abandon it first.');
    }

    // 创建新会话
    const session = new FocusSession({
      userId: user._id,
      mode,
      plannedDuration: duration,
      relatedTaskId: taskId,
      taskName: taskName || '',
      modeData: modeData || {},
      deviceType: req.headers['x-device-type'] || 'web',
      deviceModel: req.headers['x-device-model'] || '',
    });

    await session.save();

    res.respond(200, session);
  },
};

/**
 * @api {get} /api/v4/focus/sessions 获取专注会话列表
 * @apiName GetFocusSessions
 * @apiGroup Focus
 *
 * @apiParam {Number} [limit=20] 返回数量
 * @apiParam {Number} [skip=0] 跳过数量
 * @apiParam {String} [status] 筛选状态: active, completed, abandoned
 * @apiParam {String} [mode] 筛选模式
 */
api.getFocusSessions = {
  method: 'GET',
  url: '/focus/sessions',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const {
      limit = 20,
      skip = 0,
      status,
      mode,
    } = req.query;

    const query = { userId: user._id };
    if (status) query.status = status;
    if (mode) query.mode = mode;

    const sessions = await FocusSession
      .find(query)
      .sort({ startTime: -1 })
      .limit(Number(limit))
      .skip(Number(skip))
      .lean();

    const total = await FocusSession.countDocuments(query);

    res.respond(200, {
      sessions,
      total,
      limit: Number(limit),
      skip: Number(skip),
    });
  },
};

/**
 * @api {get} /api/v4/focus/sessions/:sessionId 获取单个会话详情
 * @apiName GetFocusSession
 * @apiGroup Focus
 */
api.getFocusSession = {
  method: 'GET',
  url: '/focus/sessions/:sessionId',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    res.respond(200, session);
  },
};

/**
 * @api {get} /api/v4/focus/sessions/active 获取当前活跃会话
 * @apiName GetActiveSession
 * @apiGroup Focus
 */
api.getActiveSession = {
  method: 'GET',
  url: '/focus/sessions/active',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;

    const session = await FocusSession.findOne({
      userId: user._id,
      status: { $in: ['active', 'paused'] },
    }).sort({ startTime: -1 });

    res.respond(200, { session: session || null });
  },
};

/**
 * @api {put} /api/v4/focus/sessions/:sessionId/pause 暂停专注会话
 * @apiName PauseFocusSession
 * @apiGroup Focus
 */
api.pauseFocusSession = {
  method: 'PUT',
  url: '/focus/sessions/:sessionId/pause',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    if (session.status !== 'active') {
      throw new Error('Session is not active');
    }

    session.pause();
    await session.save();

    res.respond(200, session);
  },
};

/**
 * @api {put} /api/v4/focus/sessions/:sessionId/resume 恢复专注会话
 * @apiName ResumeFocusSession
 * @apiGroup Focus
 */
api.resumeFocusSession = {
  method: 'PUT',
  url: '/focus/sessions/:sessionId/resume',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    if (session.status !== 'paused') {
      throw new Error('Session is not paused');
    }

    session.resume();
    await session.save();

    res.respond(200, session);
  },
};

/**
 * @api {post} /api/v4/focus/sessions/:sessionId/interrupt 记录中断
 * @apiName RecordInterruption
 * @apiGroup Focus
 *
 * @apiParam {String} reason 中断原因
 */
api.recordInterruption = {
  method: 'POST',
  url: '/focus/sessions/:sessionId/interrupt',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;
    const { reason } = req.body;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    session.recordInterruption(reason || 'other');
    await session.save();

    res.respond(200, session);
  },
};

/**
 * @api {post} /api/v4/focus/sessions/:sessionId/complete 完成专注会话
 * @apiName CompleteFocusSession
 * @apiGroup Focus
 *
 * @apiParam {Number} [actualMinutes] 实际专注时长
 * @apiParam {Object} [modeData] 更新模式数据
 */
api.completeFocusSession = {
  method: 'POST',
  url: '/focus/sessions/:sessionId/complete',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;
    const { actualMinutes, modeData } = req.body;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    if (session.status === 'completed' || session.status === 'abandoned') {
      throw new Error('Session already ended');
    }

    // 更新模式数据
    if (modeData) {
      session.modeData = { ...session.modeData, ...modeData };
    }

    // 完成会话
    const pointsEarned = session.complete(actualMinutes);

    // 给用户增加积分
    await User.update(
      { _id: user._id },
      { $inc: { 'stats.points': pointsEarned } }
    );

    await session.save();

    // 更新用户对象
    await user.save();

    res.respond(200, {
      session,
      pointsEarned,
      message: `专注完成！获得 ${pointsEarned} 积分`,
    });
  },
};

/**
 * @api {post} /api/v4/focus/sessions/:sessionId/abandon 放弃专注会话
 * @apiName AbandonFocusSession
 * @apiGroup Focus
 */
api.abandonFocusSession = {
  method: 'POST',
  url: '/focus/sessions/:sessionId/abandon',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { sessionId } = req.params;

    const session = await FocusSession.findOne({
      _id: sessionId,
      userId: user._id,
    });

    if (!session) {
      throw new Error('Focus session not found');
    }

    if (session.status === 'completed' || session.status === 'abandoned') {
      throw new Error('Session already ended');
    }

    // 放弃会话，但仍给予少量积分
    const pointsEarned = session.abandon();

    // 给用户增加积分
    if (pointsEarned > 0) {
      await User.update(
        { _id: user._id },
        { $inc: { 'stats.points': pointsEarned } }
      );
    }

    await session.save();

    res.respond(200, {
      session,
      pointsEarned,
      message: pointsEarned > 0 
        ? `虽然中断了，但你仍获得了 ${pointsEarned} 积分，下次继续加油！` 
        : '专注被中断，下次尝试坚持更久一点吧！',
    });
  },
};

/**
 * @api {get} /api/v4/focus/stats 获取专注统计数据
 * @apiName GetFocusStats
 * @apiGroup Focus
 *
 * @apiParam {String} [period=week] 统计周期: day, week, month, year
 */
api.getFocusStats = {
  method: 'GET',
  url: '/focus/stats',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { period = 'week' } = req.query;

    const now = new Date();
    let startDate;

    switch (period) {
      case 'day':
        startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        break;
      case 'week':
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        break;
      case 'month':
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
        break;
      case 'year':
        startDate = new Date(now.getFullYear(), 0, 1);
        break;
      default:
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    }

    const stats = await FocusSession.getStats(user._id, startDate, now);

    res.respond(200, {
      period,
      startDate,
      endDate: now,
      stats,
    });
  },
};

export default api;

