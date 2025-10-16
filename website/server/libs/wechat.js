/**
 * 微信登录服务
 * 用于实现微信开放平台登录
 */

import axios from 'axios';
import nconf from 'nconf';

const WECHAT_APP_ID = nconf.get('WECHAT_APP_ID');
const WECHAT_APP_SECRET = nconf.get('WECHAT_APP_SECRET');

/**
 * 使用授权码换取 access_token
 * @param {string} code - 微信授权code
 * @returns {Promise<Object>} token信息
 */
export async function getAccessToken(code) {
  const url = 'https://api.weixin.qq.com/sns/oauth2/access_token';
  
  try {
    const response = await axios.get(url, {
      params: {
        appid: WECHAT_APP_ID,
        secret: WECHAT_APP_SECRET,
        code: code,
        grant_type: 'authorization_code'
      }
    });

    if (response.data.errcode) {
      throw new Error(`微信API错误: ${response.data.errmsg}`);
    }

    return response.data;
    // 返回: { access_token, expires_in, refresh_token, openid, scope, unionid }
  } catch (err) {
    console.error('微信获取token错误:', err);
    throw err;
  }
}

/**
 * 获取微信用户信息
 * @param {string} accessToken - 访问令牌
 * @param {string} openid - 用户openid
 * @returns {Promise<Object>} 用户信息
 */
export async function getUserInfo(accessToken, openid) {
  const url = 'https://api.weixin.qq.com/sns/userinfo';
  
  try {
    const response = await axios.get(url, {
      params: {
        access_token: accessToken,
        openid: openid,
        lang: 'zh_CN'
      }
    });

    if (response.data.errcode) {
      throw new Error(`微信API错误: ${response.data.errmsg}`);
    }

    return response.data;
    // 返回: { openid, nickname, sex, province, city, country, headimgurl, unionid }
  } catch (err) {
    console.error('微信获取用户信息错误:', err);
    throw err;
  }
}

/**
 * 刷新 access_token
 * @param {string} refreshToken - 刷新令牌
 * @returns {Promise<Object>} 新的token信息
 */
export async function refreshAccessToken(refreshToken) {
  const url = 'https://api.weixin.qq.com/sns/oauth2/refresh_token';
  
  try {
    const response = await axios.get(url, {
      params: {
        appid: WECHAT_APP_ID,
        grant_type: 'refresh_token',
        refresh_token: refreshToken
      }
    });

    if (response.data.errcode) {
      throw new Error(`微信API错误: ${response.data.errmsg}`);
    }

    return response.data;
  } catch (err) {
    console.error('微信刷新token错误:', err);
    throw err;
  }
}

/**
 * 验证 access_token 是否有效
 * @param {string} accessToken - 访问令牌
 * @param {string} openid - 用户openid
 * @returns {Promise<boolean>} 是否有效
 */
export async function checkAccessToken(accessToken, openid) {
  const url = 'https://api.weixin.qq.com/sns/auth';
  
  try {
    const response = await axios.get(url, {
      params: {
        access_token: accessToken,
        openid: openid
      }
    });

    return response.data.errcode === 0;
  } catch (err) {
    return false;
  }
}

