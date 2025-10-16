/**
 * ADHDER 数据模型初始化迁移脚本
 * 
 * 功能：
 * 1. 创建所有必要的集合和索引
 * 2. 为开发环境添加示例数据
 * 3. 验证数据完整性
 */

import mongoose from 'mongoose';
import {  User } from '../../website/server/models/user/adhder-schema';
import { Task, DeadlineTask, FreeTask } from '../../website/server/models/task/adhder-schema';
import { FocusSession } from '../../website/server/models/focus-session';
import { TrainingRecord } from '../../website/server/models/training-record';
import { Inspiration } from '../../website/server/models/inspiration';

/**
 * 迁移：初始化ADHDER数据模型
 */
async function up() {
  console.log('🚀 开始初始化ADHDER数据模型...\n');

  // 1. 创建集合（如果不存在）
  console.log('📁 创建集合...');
  const collections = [
    'users',
    'tasks',
    'focus_sessions',
    'training_records',
    'inspirations',
  ];

  for (const collectionName of collections) {
    try {
      const exists = await mongoose.connection.db.listCollections({ name: collectionName }).hasNext();
      if (!exists) {
        await mongoose.connection.db.createCollection(collectionName);
        console.log(`  ✅ 创建集合: ${collectionName}`);
      } else {
        console.log(`  ⏭  集合已存在: ${collectionName}`);
      }
    } catch (error) {
      console.error(`  ❌ 创建集合失败 ${collectionName}:`, error.message);
    }
  }

  // 2. 创建索引
  console.log('\n📇 创建索引...');
  
  try {
    await User.createIndexes();
    console.log('  ✅ User 索引创建完成');
  } catch (error) {
    console.error('  ❌ User 索引创建失败:', error.message);
  }

  try {
    await Task.createIndexes();
    console.log('  ✅ Task 索引创建完成');
  } catch (error) {
    console.error('  ❌ Task 索引创建失败:', error.message);
  }

  try {
    await FocusSession.createIndexes();
    console.log('  ✅ FocusSession 索引创建完成');
  } catch (error) {
    console.error('  ❌ FocusSession 索引创建失败:', error.message);
  }

  try {
    await TrainingRecord.createIndexes();
    console.log('  ✅ TrainingRecord 索引创建完成');
  } catch (error) {
    console.error('  ❌ TrainingRecord 索引创建失败:', error.message);
  }

  try {
    await Inspiration.createIndexes();
    console.log('  ✅ Inspiration 索引创建完成');
  } catch (error) {
    console.error('  ❌ Inspiration 索引创建失败:', error.message);
  }

  // 3. 创建示例数据（仅限开发环境）
  if (process.env.NODE_ENV === 'development') {
    console.log('\n👤 创建示例用户...');
    await createSampleData();
  }

  console.log('\n✅ ADHDER数据模型初始化完成！\n');
}

/**
 * 回滚：删除所有ADHDER集合
 */
async function down() {
  console.log('⚠️  开始回滚ADHDER数据模型...\n');

  const collections = [
    'users',
    'tasks',
    'focus_sessions',
    'training_records',
    'inspirations',
  ];

  for (const collectionName of collections) {
    try {
      await mongoose.connection.db.dropCollection(collectionName);
      console.log(`  ✅ 删除集合: ${collectionName}`);
    } catch (error) {
      if (error.message.includes('ns not found')) {
        console.log(`  ⏭  集合不存在: ${collectionName}`);
      } else {
        console.error(`  ❌ 删除集合失败 ${collectionName}:`, error.message);
      }
    }
  }

  console.log('\n✅ 回滚完成\n');
}

/**
 * 创建示例数据
 */
async function createSampleData() {
  // 检查是否已有用户
  const userCount = await User.countDocuments();
  if (userCount > 0) {
    console.log('  ⏭  已存在用户数据，跳过示例数据创建');
    return;
  }

  // 创建示例用户
  const sampleUser = new User({
    _id: 'sample-user-001',
    auth: {
      local: {
        email: 'demo@adhder.app',
        username: 'demo_user',
        lowerCaseUsername: 'demo_user',
        hashed_password: '$2b$10$abcdefghijklmnopqrstuvwxyz', // 假密码
        passwordHashMethod: 'bcrypt',
      },
      timestamps: {
        created: new Date(),
        loggedin: new Date(),
        updated: new Date(),
      },
    },
    profile: {
      name: '示例用户',
      bio: '这是一个ADHDER示例账户',
      timezone: 'Asia/Shanghai',
    },
    adhd: {
      diagnosisStatus: 'diagnosed',
      severityLevel: 'moderate',
      comorbidities: ['anxiety'],
      treatmentPlan: '认知行为疗法 + 药物治疗',
    },
    points: {
      total: 100,
      available: 100,
      history: [{
        date: new Date(),
        amount: 100,
        source: 'admin',
        description: '初始积分',
      }],
    },
  });

  await sampleUser.save();
  console.log('  ✅ 创建示例用户: demo@adhder.app');

  // 创建示例任务
  const sampleDeadlineTask = new DeadlineTask({
    userId: sampleUser._id,
    title: '完成项目报告',
    notes: '需要包含数据分析和结论',
    deadline: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000), // 3天后
    urgencyLevel: 'medium',
    checklist: [
      { id: '1', text: '收集数据', completed: true },
      { id: '2', text: '数据分析', completed: false },
      { id: '3', text: '撰写报告', completed: false },
    ],
  });

  await sampleDeadlineTask.save();
  console.log('  ✅ 创建示例Deadline任务');

  const sampleFreeTask = new FreeTask({
    userId: sampleUser._id,
    title: '学习新技能',
    notes: '研究一下ADHD管理技巧',
    priority: 'medium',
    category: 'learning',
    tags: ['自我提升', '学习'],
  });

  await sampleFreeTask.save();
  console.log('  ✅ 创建示例Free任务');

  // 创建示例专注会话
  const sampleFocusSession = new FocusSession({
    userId: sampleUser._id,
    taskId: sampleDeadlineTask._id,
    taskTitle: sampleDeadlineTask.title,
    focusMode: 'pomodoro',
    startTime: new Date(Date.now() - 30 * 60 * 1000), // 30分钟前
    duration: 25,
    plannedDuration: 25,
    completed: true,
    pomodoroData: {
      workSessions: 1,
      breakSessions: 0,
      workDuration: 25,
      shortBreakDuration: 5,
    },
    quality: {
      score: 85,
      factors: {
        completion: 100,
        concentration: 80,
        efficiency: 75,
      },
    },
    rewards: {
      points: 30,
    },
  });

  await sampleFocusSession.save();
  console.log('  ✅ 创建示例专注会话');

  // 创建示例训练记录
  const sampleTrainingRecord = new TrainingRecord({
    userId: sampleUser._id,
    gameType: 'red-green-light',
    difficultyLevel: 1,
    startTime: new Date(Date.now() - 10 * 60 * 1000), // 10分钟前
    durationSeconds: 180,
    completed: true,
    performance: {
      totalTrials: 20,
      correctResponses: 18,
      incorrectResponses: 2,
      missedResponses: 0,
      averageReactionTime: 450,
      accuracyRate: 90,
    },
    redGreenLightData: {
      greenLightResponses: 10,
      redLightInhibitions: 8,
      falseAlarms: 2,
      missedGreens: 0,
      inhibitionRate: 80,
    },
    rewards: {
      points: 25,
      experience: 50,
    },
  });

  await sampleTrainingRecord.save();
  console.log('  ✅ 创建示例训练记录');

  // 创建示例灵感
  const sampleInspiration = new Inspiration({
    userId: sampleUser._id,
    content: '开发一个帮助ADHD人群的应用，提供专注训练和任务管理功能',
    type: 'idea',
    tags: ['产品', '创意', 'ADHD'],
    priority: 'high',
    starred: true,
  });

  await sampleInspiration.save();
  console.log('  ✅ 创建示例灵感');
}

/**
 * 验证数据完整性
 */
async function verify() {
  console.log('🔍 验证数据完整性...\n');

  const counts = {
    users: await User.countDocuments(),
    tasks: await Task.countDocuments(),
    deadlineTasks: await DeadlineTask.countDocuments(),
    freeTasks: await FreeTask.countDocuments(),
    focusSessions: await FocusSession.countDocuments(),
    trainingRecords: await TrainingRecord.countDocuments(),
    inspirations: await Inspiration.countDocuments(),
  };

  console.log('📊 数据统计:');
  console.log(`  用户数: ${counts.users}`);
  console.log(`  任务总数: ${counts.tasks}`);
  console.log(`    - Deadline任务: ${counts.deadlineTasks}`);
  console.log(`    - Free任务: ${counts.freeTasks}`);
  console.log(`  专注会话: ${counts.focusSessions}`);
  console.log(`  训练记录: ${counts.trainingRecords}`);
  console.log(`  灵感数: ${counts.inspirations}`);

  console.log('\n✅ 验证完成\n');

  return counts;
}

// 导出
export default {
  up,
  down,
  verify,
};

// 如果直接运行此脚本
if (import.meta.url === `file://${process.argv[1]}`) {
  const action = process.argv[2] || 'up';

  mongoose.connect(process.env.NODE_DB_URI || 'mongodb://localhost:27017/adhder-dev', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }).then(async () => {
    console.log('✅ 数据库连接成功\n');

    if (action === 'up') {
      await up();
      await verify();
    } else if (action === 'down') {
      await down();
    } else if (action === 'verify') {
      await verify();
    }

    await mongoose.disconnect();
    console.log('✅ 数据库连接已关闭');
    process.exit(0);
  }).catch((error) => {
    console.error('❌ 数据库连接失败:', error);
    process.exit(1);
  });
}

