# ADHDER Flutter 移动端开发指南

## 📱 项目结构

```
adhder_flutter/
├── android/                  # Android原生配置
├── ios/                      # iOS原生配置  
├── lib/
│   ├── main.dart            # 应用入口
│   │
│   ├── config/              # 配置文件
│   │   ├── api_config.dart  # API端点配置
│   │   ├── theme.dart       # 主题配置
│   │   └── constants.dart   # 常量定义
│   │
│   ├── models/              # 数据模型
│   │   ├── user.dart
│   │   ├── task.dart
│   │   ├── focus_session.dart
│   │   ├── training_record.dart
│   │   └── insight.dart
│   │
│   ├── services/            # API服务层
│   │   ├── api_service.dart      # 基础API
│   │   ├── auth_service.dart     # 认证服务
│   │   ├── focus_service.dart    # 专注服务
│   │   ├── training_service.dart # 训练服务
│   │   ├── insight_service.dart  # 灵感服务
│   │   └── task_service.dart     # 任务服务
│   │
│   ├── providers/           # 状态管理 (Provider/Riverpod)
│   │   ├── auth_provider.dart
│   │   ├── user_provider.dart
│   │   ├── focus_provider.dart
│   │   ├── training_provider.dart
│   │   └── theme_provider.dart
│   │
│   ├── screens/             # 页面
│   │   │
│   │   ├── auth/            # 认证相关
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── welcome_screen.dart
│   │   │
│   │   ├── home/            # 主页
│   │   │   ├── home_screen.dart
│   │   │   ├── dashboard_tab.dart
│   │   │   ├── tasks_tab.dart
│   │   │   ├── focus_tab.dart
│   │   │   └── profile_tab.dart
│   │   │
│   │   ├── focus/           # 专注模式
│   │   │   ├── focus_menu_screen.dart
│   │   │   ├── pomodoro_screen.dart
│   │   │   ├── noodle_screen.dart
│   │   │   ├── adventure_screen.dart
│   │   │   └── focus_stats_screen.dart
│   │   │
│   │   ├── training/        # 认知训练
│   │   │   ├── training_menu_screen.dart
│   │   │   ├── games/
│   │   │   │   ├── go_nogo_game.dart
│   │   │   │   ├── nback_game.dart
│   │   │   │   ├── stroop_game.dart
│   │   │   │   └── cpt_game.dart
│   │   │   └── training_stats_screen.dart
│   │   │
│   │   ├── tasks/           # 任务管理
│   │   │   ├── tasks_screen.dart
│   │   │   ├── task_detail_screen.dart
│   │   │   ├── task_edit_screen.dart
│   │   │   └── task_breakdown_screen.dart
│   │   │
│   │   ├── insights/        # 灵感存储
│   │   │   ├── insights_screen.dart
│   │   │   ├── insight_detail_screen.dart
│   │   │   ├── quick_capture_screen.dart
│   │   │   └── voice_record_screen.dart
│   │   │
│   │   ├── analytics/       # 数据统计
│   │   │   ├── analytics_screen.dart
│   │   │   ├── focus_report_screen.dart
│   │   │   └── training_report_screen.dart
│   │   │
│   │   ├── shop/            # 积分商城
│   │   │   ├── shop_screen.dart
│   │   │   └── redeem_screen.dart
│   │   │
│   │   └── profile/         # 个人中心
│   │       ├── profile_screen.dart
│   │       ├── settings_screen.dart
│   │       ├── edit_profile_screen.dart
│   │       └── about_screen.dart
│   │
│   ├── widgets/             # 通用组件
│   │   ├── common/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── error_widget.dart
│   │   │
│   │   ├── focus/
│   │   │   ├── focus_timer.dart
│   │   │   ├── pomodoro_clock.dart
│   │   │   ├── noodle_pot.dart
│   │   │   └── adventure_map.dart
│   │   │
│   │   ├── training/
│   │   │   ├── game_canvas.dart
│   │   │   ├── score_display.dart
│   │   │   └── progress_chart.dart
│   │   │
│   │   ├── tasks/
│   │   │   ├── task_card.dart
│   │   │   ├── task_list.dart
│   │   │   └── subtask_item.dart
│   │   │
│   │   └── insights/
│   │       ├── insight_card.dart
│   │       ├── quick_input.dart
│   │       └── voice_button.dart
│   │
│   └── utils/               # 工具类
│       ├── date_utils.dart
│       ├── validators.dart
│       ├── notification_helper.dart
│       ├── sensor_helper.dart     # 传感器检测
│       └── storage_helper.dart    # 本地存储
│
├── assets/                  # 资源文件
│   ├── images/
│   ├── icons/
│   ├── animations/          # Lottie动画
│   └── sounds/              # 音效文件
│
├── test/                    # 测试文件
├── pubspec.yaml            # 依赖配置
└── README.md

```

---

## 🔧 核心依赖 (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  provider: ^6.1.0
  # 或使用 riverpod: ^2.4.0

  # 网络请求
  dio: ^5.4.0
  pretty_dio_logger: ^1.3.0

  # 本地存储
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # 路由导航
  go_router: ^13.0.0

  # UI组件
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^3.0.0

  # 图表
  fl_chart: ^0.66.0
  syncfusion_flutter_charts: ^24.1.41

  # 日期时间
  intl: ^0.18.1
  flutter_datetime_picker: ^1.5.1

  # 传感器
  sensors_plus: ^4.0.2
  light: ^3.0.1

  # 通知
  flutter_local_notifications: ^16.3.0
  permission_handler: ^11.2.0

  # 语音
  speech_to_text: ^6.6.0
  flutter_tts: ^4.0.2
  audioplayers: ^5.2.1

  # 相机/相册
  image_picker: ^1.0.7
  camera: ^0.10.5+9

  # 工具
  uuid: ^4.3.3
  logger: ^2.0.2+1
  url_launcher: ^6.2.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
```

---

## 🎨 主题配置示例

```dart
// config/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 柔和的莫兰迪色系
  static const Color primaryColor = Color(0xFFB8A5C8); // 雾紫
  static const Color secondaryColor = Color(0xFFA8D8E8); // 薄荷蓝
  static const Color accentColor = Color(0xFFFFC0BE); // 藕粉
  
  // 功能色
  static const Color successColor = Color(0xFF9ED9A6);
  static const Color warningColor = Color(0xFFFDD396);
  static const Color errorColor = Color(0xFFEE9B9B);
  static const Color infoColor = Color(0xFFA8D8E8);
  
  // 背景色
  static const Color backgroundColor = Color(0xFFF5F3F7);
  static const Color cardColor = Colors.white;
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      background: backgroundColor,
      error: errorColor,
    ),
    fontFamily: 'PingFang SC',
    
    // 卡片主题
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
    ),
    
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),
    
    // AppBar主题
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      centerTitle: true,
    ),
  );
}
```

---

## 🔐 认证流程示例

```dart
// services/auth_service.dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class AuthService {
  final Dio _dio;
  
  AuthService(this._dio);
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/api/v4/user/auth/local/login',
        data: {
          'username': email,
          'password': password,
        },
      );
      
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/api/v4/user/auth/local/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'confirmPassword': password,
        },
      );
      
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> logout() async {
    await _dio.post('${ApiConfig.baseUrl}/api/v4/user/auth/logout');
  }
  
  String _handleError(dynamic error) {
    if (error is DioException) {
      return error.response?.data['message'] ?? '网络错误';
    }
    return error.toString();
  }
}
```

---

## 📍 专注计时器组件示例

```dart
// widgets/focus/focus_timer.dart
import 'package:flutter/material.dart';
import 'dart:async';

class FocusTimer extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback onComplete;
  final VoidCallback? onPause;
  
  const FocusTimer({
    Key? key,
    required this.durationMinutes,
    required this.onComplete,
    this.onPause,
  }) : super(key: key);

  @override
  State<FocusTimer> createState() => _FocusTimerState();
}

class _FocusTimerState extends State<FocusTimer> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  
  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
    _startTimer();
  }
  
  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          widget.onComplete();
        }
      });
    });
  }
  
  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    widget.onPause?.call();
  }
  
  @override
  Widget build(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 圆形进度指示器
        SizedBox(
          width: 250,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 1 - (_remainingSeconds / (widget.durationMinutes * 60)),
                strokeWidth: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        // 控制按钮
        ElevatedButton.icon(
          onPressed: _isRunning ? _pauseTimer : _startTimer,
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          label: Text(_isRunning ? '暂停' : '继续'),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

---

## 🚀 快速开始步骤

### 1. 创建Flutter项目

```bash
flutter create adhder_flutter
cd adhder_flutter
```

### 2. 更新依赖

将上述`pubspec.yaml`内容复制到项目中，然后运行：

```bash
flutter pub get
```

### 3. 配置API端点

```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://arhyme.com'; // 您的服务器地址
  static const String wsUrl = 'wss://arhyme.com';
  
  // API版本
  static const String apiVersion = 'v4';
  
  // 超时设置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### 4. 实现基础页面

从登录页面开始，逐步实现：
1. 认证流程
2. 主页导航
3. 任务列表
4. 专注计时器
5. 训练游戏
6. 灵感记录

### 5. 测试

```bash
flutter test
```

### 6. 运行

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

---

## 📝 开发建议

1. **使用Provider/Riverpod进行状态管理** - 避免组件间复杂的传值
2. **实现API缓存** - 使用Hive本地存储，离线可用
3. **添加错误处理** - 网络异常、数据异常都要友好提示
4. **优化性能** - 使用`const`构造函数，避免不必要的rebuild
5. **适配深色模式** - 提供白天/夜间主题切换
6. **国际化支持** - 使用`intl`实现中英文切换
7. **单元测试** - 为核心业务逻辑编写测试
8. **持续集成** - 使用GitHub Actions自动化构建

---

## 🎯 开发里程碑

### MVP阶段 (4-6周)
- [ ] 用户登录注册
- [ ] 任务管理基础功能
- [ ] 番茄钟专注模式
- [ ] 1-2个训练小游戏
- [ ] 个人统计页面

### 第二阶段 (4-6周)
- [ ] 专注面条模式
- [ ] 旅人冒险模式
- [ ] 灵感存储功能
- [ ] 3-5个训练游戏
- [ ] 积分商城

### 第三阶段 (4-6周)
- [ ] AI对话功能
- [ ] 语音引导
- [ ] 高级数据分析
- [ ] 社交功能
- [ ] 订阅支付

---

**现在您可以开始Flutter开发了！后端API已经准备好，移动端只需要调用相应接口即可。**

