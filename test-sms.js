// 测试阿里云短信API
require('dotenv').config({ path: './website/.env' });
const { sendLoginCode } = require('./website/server/libs/sms-aliyun');

async function testSMS() {
  console.log('🧪 测试阿里云短信服务...\n');
  console.log('AccessKey ID:', process.env.ALIYUN_ACCESS_KEY_ID);
  console.log('签名:', process.env.ALIYUN_SMS_SIGN_NAME);
  console.log('模板:', process.env.ALIYUN_SMS_TEMPLATE_CODE);
  console.log('');

  try {
    // 替换为您的真实手机号
    const testPhone = '13800138000';
    const testCode = '123456';

    console.log(`📱 发送测试短信到: ${testPhone}`);
    await sendLoginCode(testPhone, testCode);
    console.log('✅ 短信发送成功！');
  } catch (error) {
    console.error('❌ 短信发送失败:', error.message);
    console.error('详细错误:', error);
  }
}

testSMS();

