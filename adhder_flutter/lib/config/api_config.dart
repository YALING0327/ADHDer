/// API配置
class ApiConfig {
  // 基础URL - 请修改为您的服务器地址
  static const String baseUrl = 'http://localhost:3000'; // 开发环境
  // static const String baseUrl = 'https://arhyme.com'; // 生产环境
  
  // API版本
  static const String apiVersion = 'v4';
  
  // 完整API路径
  static String get apiBaseUrl => '$baseUrl/api/$apiVersion';
  
  // 超时设置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API端点
  static const String authLogin = '/user/auth/local/login';
  static const String authRegister = '/user/auth/local/register';
  static const String authLogout = '/user/auth/logout';
  static const String userProfile = '/user';
  
  static const String tasks = '/tasks/user';
  static const String taskCreate = '/tasks/user';
  
  static const String focusSessions = '/focus/sessions';
  static const String focusActive = '/focus/sessions/active';
  static const String focusStats = '/focus/stats';
  
  static const String trainingGames = '/training/games';
  static const String trainingProgress = '/training/progress';
  static const String trainingStats = '/training/stats';
  
  static const String insights = '/insights';
  static const String insightsPending = '/insights/pending';
}

