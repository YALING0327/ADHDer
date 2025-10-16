import '../models/user.dart';
import '../config/api_config.dart';
import 'api_client.dart';

/// 认证服务
class AuthService {
  final ApiClient _api = ApiClient();
  
  // 暴露API客户端用于其他服务
  ApiClient get apiClient => _api;

  /// 登录
  Future<User> login(String email, String password) async {
    final response = await _api.post(
      ApiConfig.authLogin,
      data: {
        'username': email,
        'password': password,
      },
    );

    final data = response.data['data'];
    final token = data['apiToken'] ?? data['token'];
    
    if (token != null) {
      await _api.setAuthToken(token);
    }

    return User.fromJson(data);
  }

  /// 注册
  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _api.post(
      ApiConfig.authRegister,
      data: {
        'email': email,
        'password': password,
        'username': username,
        'confirmPassword': password,
      },
    );

    final data = response.data['data'];
    final token = data['apiToken'] ?? data['token'];
    
    if (token != null) {
      await _api.setAuthToken(token);
    }

    return User.fromJson(data);
  }

  /// 登出
  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.authLogout);
    } finally {
      await _api.clearAuth();
    }
  }

  /// 获取当前用户信息
  Future<User> getCurrentUser() async {
    final response = await _api.get(ApiConfig.userProfile);
    return User.fromJson(response.data['data']);
  }

  /// 检查是否已登录
  Future<bool> isAuthenticated() async {
    return await _api.isAuthenticated();
  }

  /// 更新用户资料
  Future<User> updateProfile({
    String? name,
    String? imageUrl,
  }) async {
    final response = await _api.put(
      ApiConfig.userProfile,
      data: {
        'profile': {
          if (name != null) 'name': name,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      },
    );

    return User.fromJson(response.data['data']);
  }
}

