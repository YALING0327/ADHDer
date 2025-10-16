/**
 * SendCloud 邮件服务
 * 用于替代SendGrid，提供更优惠的价格和国内更好的支持
 */

import axios from 'axios';
import nconf from 'nconf';

// SendCloud配置
const API_USER = nconf.get('SENDCLOUD_API_USER');
const API_KEY = nconf.get('SENDCLOUD_API_KEY');
const FROM_EMAIL = nconf.get('EMAIL_FROM') || 'noreply@adhder.com';
const FROM_NAME = nconf.get('EMAIL_FROM_NAME') || 'ADHDER';

// SendCloud API地址
const SENDCLOUD_API = 'https://api.sendcloud.net/apiv2/mail/send';
const SENDCLOUD_TEMPLATE_API = 'https://api.sendcloud.net/apiv2/mail/sendtemplate';

/**
 * 发送普通邮件
 * @param {Object} options - 邮件选项
 * @param {string} options.to - 收件人邮箱
 * @param {string} options.subject - 邮件主题
 * @param {string} options.html - HTML内容
 * @param {string} options.text - 纯文本内容（可选）
 * @returns {Promise<Object>} 发送结果
 */
export async function sendEmail({ to, subject, html, text }) {
  try {
    const params = new URLSearchParams({
      apiUser: API_USER,
      apiKey: API_KEY,
      from: FROM_EMAIL,
      fromName: FROM_NAME,
      to,
      subject,
      html: html || text || '',
    });

    const response = await axios.post(SENDCLOUD_API, params, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });

    if (response.data.result) {
      console.log(`✅ 邮件发送成功: ${to}`);
      return {
        success: true,
        data: response.data,
      };
    } else {
      console.error(`❌ 邮件发送失败: ${response.data.message}`);
      return {
        success: false,
        error: response.data.message,
      };
    }
  } catch (error) {
    console.error('❌ SendCloud API错误:', error.message);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 使用模板发送邮件
 * @param {Object} options - 邮件选项
 * @param {string} options.to - 收件人邮箱
 * @param {string} options.templateName - 模板调用名称
 * @param {Object} options.substitution - 模板变量替换
 * @returns {Promise<Object>} 发送结果
 */
export async function sendTemplateEmail({ to, templateName, substitution }) {
  try {
    const params = new URLSearchParams({
      apiUser: API_USER,
      apiKey: API_KEY,
      from: FROM_EMAIL,
      fromName: FROM_NAME,
      to,
      templateInvokeName: templateName,
      substitution_vars: JSON.stringify({
        to: [to],
        sub: substitution,
      }),
    });

    const response = await axios.post(SENDCLOUD_TEMPLATE_API, params, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });

    if (response.data.result) {
      console.log(`✅ 模板邮件发送成功: ${to}`);
      return {
        success: true,
        data: response.data,
      };
    } else {
      console.error(`❌ 模板邮件发送失败: ${response.data.message}`);
      return {
        success: false,
        error: response.data.message,
      };
    }
  } catch (error) {
    console.error('❌ SendCloud模板API错误:', error.message);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 批量发送邮件
 * @param {Object} options - 邮件选项
 * @param {Array<string>} options.to - 收件人邮箱数组
 * @param {string} options.subject - 邮件主题
 * @param {string} options.html - HTML内容
 * @returns {Promise<Object>} 发送结果
 */
export async function sendBulkEmail({ to, subject, html }) {
  try {
    const params = new URLSearchParams({
      apiUser: API_USER,
      apiKey: API_KEY,
      from: FROM_EMAIL,
      fromName: FROM_NAME,
      to: to.join(';'), // 多个收件人用分号分隔
      subject,
      html,
    });

    const response = await axios.post(SENDCLOUD_API, params, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });

    if (response.data.result) {
      console.log(`✅ 批量邮件发送成功: ${to.length}封`);
      return {
        success: true,
        data: response.data,
      };
    } else {
      console.error(`❌ 批量邮件发送失败: ${response.data.message}`);
      return {
        success: false,
        error: response.data.message,
      };
    }
  } catch (error) {
    console.error('❌ SendCloud批量发送错误:', error.message);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 发送密码重置邮件
 * @param {string} to - 收件人邮箱
 * @param {string} username - 用户名
 * @param {string} resetLink - 重置密码链接
 * @returns {Promise<Object>} 发送结果
 */
export async function sendPasswordResetEmail(to, username, resetLink) {
  const subject = '重置您的ADHDER密码';
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #333;
          background-color: #f5f5f5;
          margin: 0;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header {
          background: linear-gradient(135deg, #6133b4 0%, #8b5cf6 100%);
          padding: 30px;
          text-align: center;
        }
        .header h1 {
          color: #ffffff;
          margin: 0;
          font-size: 28px;
        }
        .content {
          padding: 40px 30px;
        }
        .content h2 {
          color: #6133b4;
          margin-top: 0;
        }
        .button {
          display: inline-block;
          background-color: #6133b4;
          color: #ffffff !important;
          padding: 14px 40px;
          text-decoration: none;
          border-radius: 5px;
          font-weight: 600;
          margin: 20px 0;
        }
        .button:hover {
          background-color: #4f2a94;
        }
        .link {
          color: #999;
          font-size: 12px;
          word-break: break-all;
        }
        .footer {
          background-color: #f9f9f9;
          padding: 20px 30px;
          text-align: center;
          color: #999;
          font-size: 12px;
          border-top: 1px solid #eee;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎮 ADHDER</h1>
        </div>
        <div class="content">
          <h2>重置密码</h2>
          <p>您好，${username}！</p>
          <p>我们收到了您重置ADHDER账户密码的请求。请点击下面的按钮重置密码：</p>
          <div style="text-align: center;">
            <a href="${resetLink}" class="button">重置密码</a>
          </div>
          <p style="color: #666;">或复制以下链接到浏览器：</p>
          <p class="link">${resetLink}</p>
          <p style="color: #666; font-size: 14px; margin-top: 30px;">
            ⏰ 此链接将在24小时后失效。<br>
            🔒 如果您没有请求重置密码，请忽略此邮件。
          </p>
        </div>
        <div class="footer">
          <p>ADHDER - 习惯养成RPG游戏</p>
          <p>© ${new Date().getFullYear()} ADHDER. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmail({ to, subject, html });
}

/**
 * 发送欢迎邮件
 * @param {string} to - 收件人邮箱
 * @param {string} username - 用户名
 * @returns {Promise<Object>} 发送结果
 */
export async function sendWelcomeEmail(to, username) {
  const subject = '欢迎加入ADHDER！🎉';
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #333;
          background-color: #f5f5f5;
          margin: 0;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header {
          background: linear-gradient(135deg, #6133b4 0%, #8b5cf6 100%);
          padding: 40px 30px;
          text-align: center;
        }
        .header h1 {
          color: #ffffff;
          margin: 0;
          font-size: 32px;
        }
        .content {
          padding: 40px 30px;
        }
        .content h2 {
          color: #6133b4;
          margin-top: 0;
        }
        .feature {
          background-color: #f9f9f9;
          padding: 15px;
          margin: 10px 0;
          border-radius: 5px;
          border-left: 4px solid #6133b4;
        }
        .button {
          display: inline-block;
          background-color: #6133b4;
          color: #ffffff !important;
          padding: 14px 40px;
          text-decoration: none;
          border-radius: 5px;
          font-weight: 600;
          margin: 20px 0;
        }
        .footer {
          background-color: #f9f9f9;
          padding: 20px 30px;
          text-align: center;
          color: #999;
          font-size: 12px;
          border-top: 1px solid #eee;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎮 欢迎加入ADHDER</h1>
        </div>
        <div class="content">
          <h2>欢迎，${username}！</h2>
          <p>感谢注册ADHDER，开始你的习惯养成之旅吧！</p>
          
          <h3>🚀 快速开始</h3>
          <div class="feature">
            <strong>📝 创建习惯任务</strong>
            <p style="margin: 5px 0 0 0;">设置每日目标，培养好习惯</p>
          </div>
          <div class="feature">
            <strong>⚔️ 完成任务升级</strong>
            <p style="margin: 5px 0 0 0;">获得经验值和金币，提升角色等级</p>
          </div>
          <div class="feature">
            <strong>🏆 解锁成就</strong>
            <p style="margin: 5px 0 0 0;">坚持完成任务，收集徽章和奖励</p>
          </div>
          <div class="feature">
            <strong>👥 加入公会</strong>
            <p style="margin: 5px 0 0 0;">与好友一起完成挑战，互相监督</p>
          </div>

          <div style="text-align: center; margin-top: 30px;">
            <a href="${nconf.get('BASE_URL')}" class="button">开始游戏</a>
          </div>

          <p style="color: #666; font-size: 14px; margin-top: 30px;">
            💡 小提示：每天完成任务，坚持21天就能养成一个新习惯！
          </p>
        </div>
        <div class="footer">
          <p>ADHDER - 习惯养成RPG游戏</p>
          <p>© ${new Date().getFullYear()} ADHDER. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmail({ to, subject, html });
}

/**
 * 发送验证码邮件
 * @param {string} to - 收件人邮箱
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 发送结果
 */
export async function sendVerificationCodeEmail(to, code) {
  const subject = 'ADHDER 验证码';
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #333;
          background-color: #f5f5f5;
          margin: 0;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header {
          background: linear-gradient(135deg, #6133b4 0%, #8b5cf6 100%);
          padding: 30px;
          text-align: center;
        }
        .header h1 {
          color: #ffffff;
          margin: 0;
          font-size: 28px;
        }
        .content {
          padding: 40px 30px;
          text-align: center;
        }
        .code {
          font-size: 48px;
          font-weight: bold;
          color: #6133b4;
          letter-spacing: 8px;
          margin: 30px 0;
          padding: 20px;
          background-color: #f9f9f9;
          border-radius: 8px;
          border: 2px dashed #6133b4;
        }
        .footer {
          background-color: #f9f9f9;
          padding: 20px 30px;
          text-align: center;
          color: #999;
          font-size: 12px;
          border-top: 1px solid #eee;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🎮 ADHDER</h1>
        </div>
        <div class="content">
          <h2>您的验证码</h2>
          <p>请使用以下验证码完成验证：</p>
          <div class="code">${code}</div>
          <p style="color: #666; font-size: 14px;">
            ⏰ 验证码将在10分钟后失效<br>
            🔒 请勿将验证码告知他人
          </p>
        </div>
        <div class="footer">
          <p>ADHDER - 习惯养成RPG游戏</p>
          <p>© ${new Date().getFullYear()} ADHDER. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmail({ to, subject, html });
}

/**
 * 发送任务提醒邮件
 * @param {string} to - 收件人邮箱
 * @param {string} username - 用户名
 * @param {Array<string>} tasks - 未完成的任务列表
 * @returns {Promise<Object>} 发送结果
 */
export async function sendTaskReminderEmail(to, username, tasks) {
  const subject = '⏰ ADHDER 每日任务提醒';
  const taskList = tasks.map(task => `<li style="margin: 8px 0;">${task}</li>`).join('');
  
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #333;
          background-color: #f5f5f5;
          margin: 0;
          padding: 20px;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .header {
          background: linear-gradient(135deg, #6133b4 0%, #8b5cf6 100%);
          padding: 30px;
          text-align: center;
        }
        .header h1 {
          color: #ffffff;
          margin: 0;
          font-size: 28px;
        }
        .content {
          padding: 40px 30px;
        }
        .tasks {
          background-color: #f9f9f9;
          padding: 20px;
          border-radius: 8px;
          margin: 20px 0;
        }
        .tasks ul {
          list-style: none;
          padding: 0;
          margin: 0;
        }
        .tasks li:before {
          content: "☐ ";
          color: #6133b4;
          font-size: 18px;
        }
        .button {
          display: inline-block;
          background-color: #6133b4;
          color: #ffffff !important;
          padding: 14px 40px;
          text-decoration: none;
          border-radius: 5px;
          font-weight: 600;
          margin: 20px 0;
        }
        .footer {
          background-color: #f9f9f9;
          padding: 20px 30px;
          text-align: center;
          color: #999;
          font-size: 12px;
          border-top: 1px solid #eee;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>⏰ 任务提醒</h1>
        </div>
        <div class="content">
          <h2>嗨，${username}！</h2>
          <p>您今天还有 <strong>${tasks.length}</strong> 个任务未完成：</p>
          <div class="tasks">
            <ul>${taskList}</ul>
          </div>
          <p>完成任务可以获得经验值和金币，快来完成吧！</p>
          <div style="text-align: center;">
            <a href="${nconf.get('BASE_URL')}/tasks" class="button">查看任务</a>
          </div>
        </div>
        <div class="footer">
          <p>ADHDER - 习惯养成RPG游戏</p>
          <p>© ${new Date().getFullYear()} ADHDER. All rights reserved.</p>
          <p style="margin-top: 10px;">
            <a href="${nconf.get('BASE_URL')}/settings/notifications" style="color: #999;">取消订阅邮件提醒</a>
          </p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmail({ to, subject, html });
}

// 导出所有方法
export default {
  sendEmail,
  sendTemplateEmail,
  sendBulkEmail,
  sendPasswordResetEmail,
  sendWelcomeEmail,
  sendVerificationCodeEmail,
  sendTaskReminderEmail,
};

