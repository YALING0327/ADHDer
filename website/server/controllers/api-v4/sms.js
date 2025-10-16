import { Router } from 'express';
import { sendLoginCode } from '../../libs/sms-aliyun'; // 使用阿里云短信
import { NotAuthorized, BadRequest } from '../../libs/errors';
import User from '../../models/user';
import { v4 as uuid } from 'uuid';

const router = Router();

// 存储验证码（生产环境应使用Redis）
const verificationCodes = new Map();

/**
 * @api {post} /api/v4/sms/send-code 发送短信验证码
 * @apiGroup SMS
 * @apiParam {String} phone 手机号（不含+86）
 * @apiParam {String} [type=login] 类型：login（登录）、register（注册）
 * @apiSuccess {String} message 成功消息
 */
router.post('/send-code', async (req, res, next) => {
  try {
    const { phone, type = 'login' } = req.body;

    if (!phone) {
      throw new BadRequest('手机号不能为空');
    }

    // 验证手机号格式
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      throw new BadRequest('手机号格式不正确');
    }

    // 生成6位验证码
    const code = Math.floor(100000 + Math.random() * 900000).toString();

    // 发送短信（使用阿里云）
    await sendLoginCode(phone, code);

    // 存储验证码（5分钟有效期）
    verificationCodes.set(phone, {
      code,
      createdAt: Date.now(),
      expiresAt: Date.now() + 5 * 60 * 1000, // 5分钟
    });

    // 5分钟后自动删除
    setTimeout(() => {
      verificationCodes.delete(phone);
    }, 5 * 60 * 1000);

    res.status(200).json({
      success: true,
      message: '验证码已发送',
    });
  } catch (error) {
    next(error);
  }
});

/**
 * @api {post} /api/v4/sms/verify-and-login 验证验证码并登录
 * @apiGroup SMS
 * @apiParam {String} phone 手机号
 * @apiParam {String} code 验证码
 * @apiSuccess {Object} data 用户数据和token
 */
router.post('/verify-and-login', async (req, res, next) => {
  try {
    const { phone, code } = req.body;

    if (!phone || !code) {
      throw new BadRequest('手机号和验证码不能为空');
    }

    // 验证验证码
    const storedCodeData = verificationCodes.get(phone);

    if (!storedCodeData) {
      throw new BadRequest('验证码已过期或不存在');
    }

    if (storedCodeData.expiresAt < Date.now()) {
      verificationCodes.delete(phone);
      throw new BadRequest('验证码已过期');
    }

    if (storedCodeData.code !== code) {
      throw new BadRequest('验证码错误');
    }

    // 验证成功，删除验证码
    verificationCodes.delete(phone);

    // 查找或创建用户
    let user = await User.findOne({ 'auth.local.phone': phone });

    if (!user) {
      // 创建新用户
      user = new User({
        auth: {
          local: {
            phone,
            username: `user_${phone.slice(-4)}_${Date.now()}`, // 生成唯一用户名
          },
        },
        profile: {
          name: `用户${phone.slice(-4)}`,
        },
      });

      await user.save();
    }

    // 生成API Token
    const apiToken = uuid();
    user.apiToken = apiToken;
    await user.save();

    // 返回用户信息
    const userJSON = user.toJSON();
    userJSON.apiToken = apiToken;

    res.status(200).json({
      success: true,
      data: userJSON,
    });
  } catch (error) {
    next(error);
  }
});

export default router;

