/**
 * 阿里云短信服务
 * 用于发送验证码短信
 */

import Core from '@alicloud/pop-core';
import nconf from 'nconf';

// 初始化阿里云客户端
const client = new Core({
  accessKeyId: nconf.get('ALIYUN_SMS_ACCESS_KEY_ID'),
  accessKeySecret: nconf.get('ALIYUN_SMS_ACCESS_KEY_SECRET'),
  endpoint: nconf.get('ALIYUN_SMS_ENDPOINT') || 'https://dysmsapi.aliyuncs.com',
  apiVersion: '2017-05-25'
});

/**
 * 发送短信验证码
 * @param {string} phone - 手机号（11位中国大陆手机号）
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 发送结果
 */
export async function sendSMS(phone, code) {
  const params = {
    PhoneNumbers: phone,
    SignName: nconf.get('ALIYUN_SMS_SIGN_NAME'),
    TemplateCode: nconf.get('ALIYUN_SMS_TEMPLATE_CODE'),
    TemplateParam: JSON.stringify({ code })
  };

  const requestOption = {
    method: 'POST'
  };

  try {
    const result = await client.request('SendSms', params, requestOption);
    
    if (result.Code === 'OK') {
      console.log('✅ 阿里云短信发送成功:', {
        phone: phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2'),
        requestId: result.RequestId
      });
      
      return {
        success: true,
        messageId: result.BizId,
        requestId: result.RequestId
      };
    } else {
      console.error('❌ 阿里云短信发送失败:', result);
      throw new Error(result.Message || '短信发送失败');
    }
  } catch (err) {
    console.error('阿里云短信服务错误:', err);
    
    // 处理常见错误
    if (err.data && err.data.Code) {
      const errorMessages = {
        'isv.BUSINESS_LIMIT_CONTROL': '触发流控限制，请稍后再试',
        'isv.INVALID_PARAMETERS': '参数错误，请检查手机号和模板',
        'isv.OUT_OF_SERVICE': '短信服务未开通或已停用',
        'isv.PRODUCT_UN_SUBSCRIPT': '未开通云通信产品',
        'isv.ACCOUNT_NOT_EXISTS': '账户不存在',
        'isv.ACCOUNT_ABNORMAL': '账户异常',
        'isv.SMS_TEMPLATE_ILLEGAL': '短信模板不合法',
        'isv.SMS_SIGNATURE_ILLEGAL': '短信签名不合法',
        'isv.MOBILE_NUMBER_ILLEGAL': '手机号码格式错误',
        'isv.MOBILE_COUNT_OVER_LIMIT': '手机号码数量超过限制',
        'isv.TEMPLATE_MISSING_PARAMETERS': '模板缺少变量',
        'isv.AMOUNT_NOT_ENOUGH': '账户余额不足'
      };
      
      const message = errorMessages[err.data.Code] || err.data.Message || '短信发送失败';
      throw new Error(message);
    }
    
    throw err;
  }
}

/**
 * 生成6位数字验证码
 * @returns {string} 验证码
 */
export function generateCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

/**
 * 验证中国大陆手机号格式
 * @param {string} phone - 手机号
 * @returns {boolean} 是否有效
 */
export function validatePhoneNumber(phone) {
  // 中国大陆手机号：1开头，第二位是3-9，共11位
  return /^1[3-9]\d{9}$/.test(phone);
}

/**
 * 格式化手机号（隐藏中间4位）
 * @param {string} phone - 手机号
 * @returns {string} 格式化后的手机号
 */
export function formatPhone(phone) {
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
}

