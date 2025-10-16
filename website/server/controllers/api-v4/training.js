/**
 * @module controllers/api-v4/training
 * @description 认知训练游戏API
 */

import TrainingRecord from '../../models/training-record';
import { authWithHeaders } from '../../middlewares/auth';
import { model as User } from '../../models/user';

const api = {};

/**
 * @api {get} /api/v4/training/games 获取可用游戏列表
 * @apiName GetTrainingGames
 * @apiGroup Training
 */
api.getTrainingGames = {
  method: 'GET',
  url: '/training/games',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;

    // 获取用户各游戏进度
    const progress = await TrainingRecord.getAllGameProgress(user._id);

    const games = [
      {
        id: 'go-nogo',
        name: '红灯绿灯',
        nameEn: 'Go/No-Go',
        description: '训练反应抑制能力',
        category: '反应抑制',
        difficulty: 'easy',
        duration: 3, // 分钟
        icon: '🚦',
        recommendedDaily: 2,
      },
      {
        id: 'nback',
        name: '数字记忆',
        nameEn: 'N-back',
        description: '强化工作记忆',
        category: '工作记忆',
        difficulty: 'medium',
        duration: 5,
        icon: '🔢',
        recommendedDaily: 1,
      },
      {
        id: 'stroop',
        name: '颜色词语',
        nameEn: 'Stroop Task',
        description: '提升认知灵活性',
        category: '认知灵活性',
        difficulty: 'medium',
        duration: 4,
        icon: '🎨',
        recommendedDaily: 1,
      },
      {
        id: 'cpt',
        name: '太空聚焦',
        nameEn: 'CPT',
        description: '训练持续注意力',
        category: '持续注意力',
        difficulty: 'hard',
        duration: 5,
        icon: '🚀',
        recommendedDaily: 1,
      },
      {
        id: 'attention-bubble',
        name: '专注泡泡',
        nameEn: 'Attention Bubble',
        description: '轻松保持注意力',
        category: '注意力维持',
        difficulty: 'easy',
        duration: 2,
        icon: '🫧',
        recommendedDaily: 3,
      },
    ];

    // 关联用户进度
    const gamesWithProgress = games.map(game => {
      const gameProgress = progress.find(p => p.gameType === game.id);
      return {
        ...game,
        progress: gameProgress || null,
        unlocked: true, // 所有游戏默认解锁
      };
    });

    res.respond(200, { games: gamesWithProgress });
  },
};

/**
 * @api {post} /api/v4/training/games/:gameType/start 开始训练
 * @apiName StartTraining
 * @apiGroup Training
 *
 * @apiParam {Number} [level=1] 难度等级
 * @apiParam {Number} [round=1] 回合数
 */
api.startTraining = {
  method: 'POST',
  url: '/training/games/:gameType/start',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { gameType } = req.params;
    const { level = 1, round = 1 } = req.body;

    const validGames = ['go-nogo', 'nback', 'stroop', 'cpt', 'attention-bubble'];
    if (!validGames.includes(gameType)) {
      throw new Error('Invalid game type');
    }

    // 检查是否有未完成的训练
    const activeTraining = await TrainingRecord.findOne({
      userId: user._id,
      gameType,
      completed: false,
      abandoned: false,
    });

    if (activeTraining) {
      // 返回现有会话
      return res.respond(200, { 
        record: activeTraining,
        message: '继续之前的训练',
      });
    }

    // 创建新训练记录
    const record = new TrainingRecord({
      userId: user._id,
      gameType,
      difficultyLevel: level,
      round,
      startTime: new Date(),
      deviceType: req.headers['x-device-type'] || 'web',
    });

    await record.save();

    res.respond(200, {
      record,
      message: '训练开始！',
    });
  },
};

/**
 * @api {post} /api/v4/training/games/:recordId/submit 提交训练成绩
 * @apiName SubmitTrainingResult
 * @apiGroup Training
 *
 * @apiParam {Number} score 分数
 * @apiParam {Number} totalTrials 总试验次数
 * @apiParam {Number} correctTrials 正确次数
 * @apiParam {Number} incorrectTrials 错误次数
 * @apiParam {Number} missedTrials 遗漏次数
 * @apiParam {Number} duration 时长(秒)
 * @apiParam {Number[]} [reactionTimes] 反应时间列表
 * @apiParam {Object} [gameData] 特定游戏数据
 */
api.submitTrainingResult = {
  method: 'POST',
  url: '/training/games/:recordId/submit',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { recordId } = req.params;
    const {
      score,
      totalTrials,
      correctTrials,
      incorrectTrials,
      missedTrials,
      duration,
      reactionTimes,
      gameData,
    } = req.body;

    const record = await TrainingRecord.findOne({
      _id: recordId,
      userId: user._id,
    });

    if (!record) {
      throw new Error('Training record not found');
    }

    if (record.completed) {
      throw new Error('Training already completed');
    }

    // 更新成绩
    record.score = score || 0;
    record.totalTrials = totalTrials || 0;
    record.correctTrials = correctTrials || 0;
    record.incorrectTrials = incorrectTrials || 0;
    record.missedTrials = missedTrials || 0;
    record.duration = duration || 0;
    record.reactionTimes = reactionTimes || [];

    if (gameData) {
      record.gameData = { ...record.gameData, ...gameData };
    }

    // 完成训练
    record.complete();

    // 获取上次成绩对比
    const previousRecord = await TrainingRecord.findOne({
      userId: user._id,
      gameType: record.gameType,
      completed: true,
      _id: { $ne: record._id },
    }).sort({ startTime: -1 });

    if (previousRecord) {
      record.improvementFromLastSession = {
        score: record.score - (previousRecord.score || 0),
        accuracy: record.accuracy - (previousRecord.accuracy || 0),
        reactionTime: (previousRecord.averageReactionTime || 0) - record.averageReactionTime,
      };
    }

    await record.save();

    // 给用户增加积分
    await User.update(
      { _id: user._id },
      { $inc: { 'stats.points': record.pointsEarned } }
    );

    // 生成反馈消息
    let feedback = `完成训练！获得 ${record.pointsEarned} 积分\n`;
    feedback += `准确率: ${record.accuracy.toFixed(1)}% (${record.performanceGrade})\n`;

    if (record.improvementFromLastSession) {
      const imp = record.improvementFromLastSession;
      if (imp.accuracy > 0) {
        feedback += `准确率提升了 ${imp.accuracy.toFixed(1)}%，继续加油！`;
      } else if (imp.accuracy < -5) {
        feedback += '这次有点小失误，下次会更好的！';
      }
    }

    res.respond(200, {
      record,
      improvement: record.improvementFromLastSession,
      feedback,
    });
  },
};

/**
 * @api {get} /api/v4/training/progress 获取训练进度
 * @apiName GetTrainingProgress
 * @apiGroup Training
 *
 * @apiParam {String} [gameType] 指定游戏类型
 */
api.getTrainingProgress = {
  method: 'GET',
  url: '/training/progress',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const { gameType } = req.query;

    if (gameType) {
      const progress = await TrainingRecord.getProgress(user._id, gameType);
      res.respond(200, { progress });
    } else {
      const allProgress = await TrainingRecord.getAllGameProgress(user._id);
      res.respond(200, { progress: allProgress });
    }
  },
};

/**
 * @api {get} /api/v4/training/stats 获取训练统计
 * @apiName GetTrainingStats
 * @apiGroup Training
 *
 * @apiParam {String} [period=week] 统计周期: day, week, month, year
 */
api.getTrainingStats = {
  method: 'GET',
  url: '/training/stats',
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

    const stats = await TrainingRecord.getStats(user._id, startDate, now);

    res.respond(200, {
      period,
      startDate,
      endDate: now,
      stats,
    });
  },
};

/**
 * @api {get} /api/v4/training/history 获取训练历史
 * @apiName GetTrainingHistory
 * @apiGroup Training
 *
 * @apiParam {String} [gameType] 游戏类型
 * @apiParam {Number} [limit=20] 返回数量
 * @apiParam {Number} [skip=0] 跳过数量
 */
api.getTrainingHistory = {
  method: 'GET',
  url: '/training/history',
  middlewares: [authWithHeaders()],
  async handler (req, res) {
    const { user } = res.locals;
    const {
      gameType,
      limit = 20,
      skip = 0,
    } = req.query;

    const query = {
      userId: user._id,
      completed: true,
    };

    if (gameType) {
      query.gameType = gameType;
    }

    const records = await TrainingRecord
      .find(query)
      .sort({ startTime: -1 })
      .limit(Number(limit))
      .skip(Number(skip))
      .lean();

    const total = await TrainingRecord.countDocuments(query);

    res.respond(200, {
      records,
      total,
      limit: Number(limit),
      skip: Number(skip),
    });
  },
};

export default api;

