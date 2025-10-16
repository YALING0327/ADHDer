import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

/// API客户端
class ApiClient {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();
  String? _authToken;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));

    // 添加认证拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 添加认证token
          if (_authToken != null) {
            options.headers['x-api-user'] = _authToken;
            options.headers['x-api-key'] = _authToken;
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // 处理401未授权错误
          if (error.response?.statusCode == 401) {
            // 清除token并跳转登录
            await clearAuth();
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// 设置认证token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  /// 获取认证token
  Future<String?> getAuthToken() async {
    _authToken ??= await _storage.read(key: 'auth_token');
    return _authToken;
  }

  /// 清除认证
  Future<void> clearAuth() async {
    _authToken = null;
    await _storage.delete(key: 'auth_token');
  }

  /// 检查是否已登录
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT请求
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE请求
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 处理错误
  ApiException _handleError(DioException error) {
    String message = '网络请求失败';
    int? statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = '连接超时，请检查网络';
    } else if (error.type == DioExceptionType.badResponse) {
      // 服务器返回错误
      final data = error.response?.data;
      if (data is Map && data.containsKey('message')) {
        message = data['message'];
      } else if (data is Map && data.containsKey('error')) {
        message = data['error'];
      } else {
        switch (statusCode) {
          case 400:
            message = '请求参数错误';
            break;
          case 401:
            message = '未登录或登录已过期';
            break;
          case 403:
            message = '没有权限';
            break;
          case 404:
            message = '请求的资源不存在';
            break;
          case 500:
            message = '服务器错误';
            break;
          default:
            message = '请求失败 ($statusCode)';
        }
      }
    } else if (error.type == DioExceptionType.cancel) {
      message = '请求已取消';
    }

    return ApiException(message, statusCode: statusCode);
  }
}

/// API异常
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

