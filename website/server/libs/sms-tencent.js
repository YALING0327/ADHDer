/**
 * 腾讯云短信服务
 * 用于发送验证码和通知短信
 */

import tencentcloud from 'tencentcloud-sdk-nodejs';
import nconf from 'nconf';

// 导入短信客户端
const SmsClient = tencentcloud.sms.v20210111.Client;

// 腾讯云配置
const SecretId = nconf.get('TENCENT_CLOUD_SECRET_ID');
const SecretKey = nconf.get('TENCENT_CLOUD_SECRET_KEY');
const SdkAppId = nconf.get('TENCENT_SMS_SDK_APP_ID');
const SignName = nconf.get('TENCENT_SMS_SIGN_NAME') || 'ADHDER';
const TemplateId = nconf.get('TENCENT_SMS_TEMPLATE_ID');

// 初始化客户端
const client = new SmsClient({
  credential: {
    secretId: SecretId,
    secretKey: SecretKey,
  },
  region: 'ap-guangzhou', // 短信服务地域（固定）
  profile: {
    httpProfile: {
      endpoint: 'sms.tencentcloudapi.com',
    },
  },
});

/**
 * 发送短信
 * @param {string} phoneNumber - 手机号（带国家码，如：+8613800138000）
 * @param {Array<string>} templateParams - 模板参数数组
 * @param {string} templateId - 模板ID（可选，使用默认模板）
 * @returns {Promise<Object>} 发送结果
 */
export async function sendSMS(phoneNumber, templateParams, templateId = TemplateId) {
  try {
    // 确保手机号格式正确
    let formattedPhone = phoneNumber;
    if (!formattedPhone.startsWith('+')) {
      // 如果没有国家码，默认添加+86（中国）
      formattedPhone = `+86${formattedPhone}`;
    }

    const params = {
      PhoneNumberSet: [formattedPhone],
      SmsSdkAppId: SdkAppId,
      SignName,
      TemplateId: templateId,
      TemplateParamSet: templateParams,
    };

    const response = await client.SendSms(params);
    
    if (response.SendStatusSet && response.SendStatusSet.length > 0) {
      const status = response.SendStatusSet[0];
      
      if (status.Code === 'Ok') {
        console.log(`✅ 短信发送成功: ${phoneNumber}`);
        return {
          success: true,
          serialNo: status.SerialNo,
          phoneNumber,
        };
      } else {
        console.error(`❌ 短信发送失败: ${status.Code} - ${status.Message}`);
        return {
          success: false,
          error: status.Message,
          code: status.Code,
        };
      }
    }

    throw new Error('发送短信响应异常');
  } catch (error) {
    console.error('❌ 腾讯云短信API错误:', error);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 发送验证码短信
 * @param {string} phoneNumber - 手机号
 * @param {string} code - 验证码
 * @param {number} minutes - 有效时间（分钟），默认10分钟
 * @returns {Promise<Object>} 发送结果
 */
export async function sendVerificationCode(phoneNumber, code, minutes = 10) {
  // 模板参数：{1}为验证码，{2}为有效时间
  const templateParams = [code, minutes.toString()];
  return sendSMS(phoneNumber, templateParams);
}

/**
 * 发送登录验证码
 * @param {string} phoneNumber - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 发送结果
 */
export async function sendLoginCode(phoneNumber, code) {
  return sendVerificationCode(phoneNumber, code, 10);
}

/**
 * 发送注册验证码
 * @param {string} phoneNumber - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 发送结果
 */
export async function sendRegisterCode(phoneNumber, code) {
  return sendVerificationCode(phoneNumber, code, 10);
}

/**
 * 发送密码重置验证码
 * @param {string} phoneNumber - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 发送结果
 */
export async function sendResetPasswordCode(phoneNumber, code) {
  return sendVerificationCode(phoneNumber, code, 10);
}

/**
 * 批量发送短信
 * @param {Array<string>} phoneNumbers - 手机号数组
 * @param {Array<string>} templateParams - 模板参数
 * @param {string} templateId - 模板ID
 * @returns {Promise<Object>} 发送结果
 */
export async function sendBulkSMS(phoneNumbers, templateParams, templateId = TemplateId) {
  try {
    // 格式化所有手机号
    const formattedPhones = phoneNumbers.map(phone => {
      return phone.startsWith('+') ? phone : `+86${phone}`;
    });

    const params = {
      PhoneNumberSet: formattedPhones,
      SmsSdkAppId: SdkAppId,
      SignName,
      TemplateId: templateId,
      TemplateParamSet: templateParams,
    };

    const response = await client.SendSms(params);
    
    const results = response.SendStatusSet.map(status => ({
      phoneNumber: status.PhoneNumber,
      success: status.Code === 'Ok',
      serialNo: status.SerialNo,
      error: status.Code !== 'Ok' ? status.Message : null,
    }));

    const successCount = results.filter(r => r.success).length;
    console.log(`✅ 批量发送完成: 成功${successCount}/${phoneNumbers.length}条`);

    return {
      success: true,
      results,
      successCount,
      totalCount: phoneNumbers.length,
    };
  } catch (error) {
    console.error('❌ 腾讯云批量短信API错误:', error);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 查询短信发送状态
 * @param {Array<string>} serialNos - 短信流水号数组
 * @returns {Promise<Object>} 查询结果
 */
export async function querySMSStatus(serialNos) {
  try {
    const params = {
      SmsSdkAppId: SdkAppId,
      SerialNoSet: serialNos,
    };

    const response = await client.PullSmsSendStatus(params);
    
    return {
      success: true,
      statusList: response.PullSmsSendStatusSet,
    };
  } catch (error) {
    console.error('❌ 查询短信状态失败:', error);
    return {
      success: false,
      error: error.message,
    };
  }
}

/**
 * 生成随机验证码
 * @param {number} length - 验证码长度，默认6位
 * @returns {string} 验证码
 */
export function generateCode(length = 6) {
  const digits = '0123456789';
  let code = '';
  for (let i = 0; i < length; i++) {
    code += digits[Math.floor(Math.random() * digits.length)];
  }
  return code;
}

/**
 * 验证手机号格式
 * @param {string} phoneNumber - 手机号
 * @returns {boolean} 是否有效
 */
export function validatePhoneNumber(phoneNumber) {
  // 中国大陆手机号验证
  const pattern = /^1[3-9]\d{9}$/;
  return pattern.test(phoneNumber);
}

/**
 * 格式化手机号（添加国家码）
 * @param {string} phoneNumber - 手机号
 * @param {string} countryCode - 国家码，默认+86
 * @returns {string} 格式化后的手机号
 */
export function formatPhoneNumber(phoneNumber, countryCode = '+86') {
  if (phoneNumber.startsWith('+')) {
    return phoneNumber;
  }
  return `${countryCode}${phoneNumber}`;
}

/**
 * 获取短信统计数据
 * @param {string} startDate - 开始日期（YYYY-MM-DD）
 * @param {string} endDate - 结束日期（YYYY-MM-DD）
 * @returns {Promise<Object>} 统计数据
 */
export async function getSMSStatistics(startDate, endDate) {
  try {
    const params = {
      SmsSdkAppId: SdkAppId,
      BeginTime: new Date(`${startDate} 00:00:00`).getTime() / 1000,
      EndTime: new Date(`${endDate} 23:59:59`).getTime() / 1000,
    };

    const response = await client.SendStatusStatistics(params);
    
    return {
      success: true,
      statistics: response.SendStatusStatisticsSet,
    };
  } catch (error) {
    console.error('❌ 获取短信统计失败:', error);
    return {
      success: false,
      error: error.message,
    };
  }
}

// 导出所有方法
export default {
  sendSMS,
  sendVerificationCode,
  sendLoginCode,
  sendRegisterCode,
  sendResetPasswordCode,
  sendBulkSMS,
  querySMSStatus,
  generateCode,
  validatePhoneNumber,
  formatPhoneNumber,
  getSMSStatistics,
};

