/**
 * 微信登录 API
 */

import { authWithHeaders } from '../../../middlewares/auth';
import * as wechatService from '../../../libs/wechat';
import { model as User } from '../../../models/user';

const api = {};

/**
 * @api {post} /api/v3/auth/wechat/login 微信登录
 * @apiName WeChatLogin
 * @apiGroup Auth
 *
 * @apiParam {String} code 微信授权code
 *
 * @apiSuccess {Boolean} success 是否成功
 * @apiSuccess {Object} user 用户信息
 * @apiSuccess {String} token JWT Token
 * @apiSuccess {Boolean} needBindPhone 是否需要绑定手机号
 * @apiSuccess {Boolean} isNewUser 是否是新用户
 */
api.login = {
  method: 'POST',
  middlewares: [],
  url: '/auth/wechat/login',
  async handler(req, res) {
    const { code } = req.body;

    if (!code) {
      return res.status(400).json({
        success: false,
        message: '缺少微信授权码'
      });
    }

    try {
      // 1. 获取 access_token 和 openid
      const tokenData = await wechatService.getAccessToken(code);
      
      if (!tokenData.access_token || !tokenData.openid) {
        return res.status(400).json({
          success: false,
          message: '微信授权失败，请重试'
        });
      }

      const { access_token, openid, unionid } = tokenData;

      // 2. 获取用户信息
      const userInfo = await wechatService.getUserInfo(access_token, openid);

      // 3. 查找是否已存在该微信用户
      let user = await User.findOne({ 'auth.wechat.openid': openid });
      let isNewUser = false;

      if (!user) {
        // 新用户 - 创建账号
        user = new User({
          auth: {
            wechat: {
              openid,
              unionid: unionid || null,
              nickname: userInfo.nickname,
              avatar: userInfo.headimgurl
            }
          },
          profile: {
            name: userInfo.nickname || `微信用户${openid.slice(-4)}`
          },
          preferences: {
            language: 'zh'
          }
        });
        await user.save();
        isNewUser = true;
        
        console.log('✅ 微信新用户注册:', {
          userId: user._id,
          openid: openid.slice(-8)
        });
      } else {
        // 老用户 - 更新微信信息
        user.auth.wechat.nickname = userInfo.nickname;
        user.auth.wechat.avatar = userInfo.headimgurl;
        if (unionid) {
          user.auth.wechat.unionid = unionid;
        }
        await user.save();
        
        console.log('✅ 微信用户登录:', {
          userId: user._id,
          openid: openid.slice(-8)
        });
      }

      // 4. 检查是否已绑定手机号
      const hasPhone = user.auth.phone && user.auth.phone.number && user.auth.phone.verified;
      
      // 5. 生成登录 token
      const token = user.generateAuthToken ? user.generateAuthToken() : generateToken(user);

      return res.json({
        success: true,
        user: user.toJSON(),
        token,
        needBindPhone: !hasPhone,
        isNewUser
      });

    } catch (err) {
      console.error('微信登录错误:', err);
      return res.status(500).json({
        success: false,
        message: '登录失败，请稍后重试',
        error: process.env.NODE_ENV === 'development' ? err.message : undefined
      });
    }
  }
};

/**
 * @api {post} /api/v3/auth/wechat/bind 绑定微信
 * @apiName BindWeChat
 * @apiGroup Auth
 *
 * @apiParam {String} code 微信授权code
 *
 * @apiSuccess {Boolean} success 是否成功
 * @apiSuccess {String} message 消息
 */
api.bind = {
  method: 'POST',
  middlewares: [authWithHeaders()],
  url: '/auth/wechat/bind',
  async handler(req, res) {
    const { user } = res.locals;
    const { code } = req.body;

    if (!code) {
      return res.status(400).json({
        success: false,
        message: '缺少微信授权码'
      });
    }

    try {
      // 1. 获取 access_token 和 openid
      const tokenData = await wechatService.getAccessToken(code);
      const { access_token, openid, unionid } = tokenData;

      // 2. 检查该微信号是否已被其他用户绑定
      const existingUser = await User.findOne({
        'auth.wechat.openid': openid,
        _id: { $ne: user._id }
      });

      if (existingUser) {
        return res.status(400).json({
          success: false,
          message: '该微信号已被其他账号绑定'
        });
      }

      // 3. 获取用户信息
      const userInfo = await wechatService.getUserInfo(access_token, openid);

      // 4. 绑定微信
      user.auth.wechat = {
        openid,
        unionid: unionid || null,
        nickname: userInfo.nickname,
        avatar: userInfo.headimgurl
      };
      await user.save();

      console.log('✅ 绑定微信成功:', {
        userId: user._id,
        openid: openid.slice(-8)
      });

      return res.json({
        success: true,
        message: '微信绑定成功'
      });

    } catch (err) {
      console.error('绑定微信错误:', err);
      return res.status(500).json({
        success: false,
        message: '绑定失败，请稍后重试'
      });
    }
  }
};

/**
 * @api {post} /api/v3/auth/wechat/unbind 解绑微信
 * @apiName UnbindWeChat
 * @apiGroup Auth
 *
 * @apiSuccess {Boolean} success 是否成功
 */
api.unbind = {
  method: 'POST',
  middlewares: [authWithHeaders()],
  url: '/auth/wechat/unbind',
  async handler(req, res) {
    const { user } = res.locals;

    // 检查是否有其他登录方式
    const hasOtherAuth = (user.auth.phone && user.auth.phone.verified) || 
                        (user.auth.local && user.auth.local.email);

    if (!hasOtherAuth) {
      return res.status(400).json({
        success: false,
        message: '请先绑定手机号或邮箱后再解绑微信'
      });
    }

    user.auth.wechat = undefined;
    await user.save();

    console.log('✅ 解绑微信:', { userId: user._id });

    return res.json({
      success: true,
      message: '微信解绑成功'
    });
  }
};

// 临时token生成函数（如果User模型没有generateAuthToken方法）
function generateToken(user) {
  const jwt = require('jsonwebtoken');
  const nconf = require('nconf');
  
  return jwt.sign(
    { userId: user._id },
    nconf.get('SESSION_SECRET'),
    { expiresIn: '30d' }
  );
}

export default api;

