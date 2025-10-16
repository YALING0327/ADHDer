import '../config/api_config.dart';
import 'api_client.dart';

/// 短信服务
class SmsService {
  final ApiClient _api = ApiClient();

  /// 发送短信验证码
  Future<bool> sendCode(String phone) async {
    try {
      await _api.post(
        '/sms/send-code',
        data: {
          'phone': phone,
          'type': 'login', // 登录类型
        },
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// 验证短信验证码（并登录/注册）
  Future<Map<String, dynamic>> verifyCodeAndLogin(String phone, String code) async {
    try {
      final response = await _api.post(
        '/sms/verify-and-login',
        data: {
          'phone': phone,
          'code': code,
        },
      );
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}

