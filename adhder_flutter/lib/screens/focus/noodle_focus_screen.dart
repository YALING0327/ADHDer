import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// 专注面条模式
/// 
/// 有趣的煮面专注法：
/// - 设定专注时间（煮面时间）
/// - 在专注过程中，面条逐渐煮熟
/// - 完成后获得美味故事卡片
class NoodleFocusScreen extends StatefulWidget {
  const NoodleFocusScreen({super.key});

  @override
  State<NoodleFocusScreen> createState() => _NoodleFocusScreenState();
}

class _NoodleFocusScreenState extends State<NoodleFocusScreen>
    with TickerProviderStateMixin {
  // 面条类型
  final List<Map<String, dynamic>> _noodleTypes = [
    {'name': '快手拌面', 'duration': 15, 'icon': '🍜', 'story': '简单快捷的美味'},
    {'name': '经典汤面', 'duration': 25, 'icon': '🍲', 'story': '温暖的家的味道'},
    {'name': '功夫炒面', 'duration': 35, 'icon': '🥘', 'story': '需要耐心的艺术品'},
  ];

  int _selectedIndex = 1; // 默认25分钟
  
  // 计时状态
  bool _isRunning = false;
  bool _isPaused = false;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  
  // 动画控制器
  late AnimationController _steamController;
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _steamController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  void _startCooking() {
    final duration = _noodleTypes[_selectedIndex]['duration'] * 60;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _totalSeconds = duration;
      _remainingSeconds = duration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _completeNoodle();
      }
    });
  }

  void _pauseCooking() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resumeCooking() {
    setState(() => _isPaused = false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _completeNoodle();
      }
    });
  }

  void _stopCooking() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
  }

  void _completeNoodle() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });

    final noodle = _noodleTypes[_selectedIndex];
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                noodle['icon'],
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                '🎉 煮好啦！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      noodle['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noodle['story'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '获得 +15 积分 🌟',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.warningColor,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('返回'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('再煮一碗'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _progress {
    if (_totalSeconds == 0) return 0;
    return 1 - (_remainingSeconds / _totalSeconds);
  }

  String get _timeDisplay {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 获取面条状态描述
  String get _noodleStatus {
    if (_progress < 0.2) return '水还没开呢...';
    if (_progress < 0.4) return '水开始沸腾了 🔥';
    if (_progress < 0.6) return '面条在锅里翻滚 🍜';
    if (_progress < 0.8) return '快好了，再等等 ⏰';
    if (_progress < 1.0) return '马上就要好了！';
    return '出锅啦！🎉';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍜 专注面条'),
        actions: _isRunning
            ? [
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('确认放弃'),
                        content: const Text('面还没煮好，确定要放弃吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('继续煮'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _stopCooking();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorColor,
                            ),
                            child: const Text('放弃'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.warningColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: _isRunning ? _buildCookingArea() : _buildSelectArea(),
        ),
      ),
    );
  }

  Widget _buildSelectArea() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🍜',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              '今天想煮什么面？',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            
            // 面条选择
            ...List.generate(_noodleTypes.length, (index) {
              final noodle = _noodleTypes[index];
              final isSelected = _selectedIndex == index;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _NoodleCard(
                  icon: noodle['icon'],
                  name: noodle['name'],
                  duration: noodle['duration'],
                  story: noodle['story'],
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedIndex = index),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: _startCooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department, size: 28),
                    SizedBox(width: 8),
                    Text(
                      '开始煮面',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookingArea() {
    return Column(
      children: [
        const SizedBox(height: 40),
        
        // 煮面动画区域
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 锅
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.warningColor.withOpacity(0.3),
                        AppTheme.warningColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                
                // 进度环
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 12,
                    backgroundColor: AppTheme.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.warningColor,
                    ),
                  ),
                ),
                
                // 中心内容
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 面条icon + 蒸汽效果
                    AnimatedBuilder(
                      animation: _steamController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _steamController.value * -5),
                          child: Opacity(
                            opacity: 0.3 + _steamController.value * 0.4,
                            child: Text(
                              _noodleTypes[_selectedIndex]['icon'],
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 时间
                    Text(
                      _timeDisplay,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 状态描述
                    Text(
                      _noodleStatus,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                
                // 冒泡效果
                if (_progress > 0.2)
                  ...List.generate(5, (index) {
                    return _BubbleWidget(
                      controller: _bubbleController,
                      delay: index * 0.2,
                      offset: Offset((index - 2) * 40, 0),
                    );
                  }),
              ],
            ),
          ),
        ),
        
        // 控制按钮
        Padding(
          padding: const EdgeInsets.all(24),
          child: _isPaused
              ? SizedBox(
                  width: 200,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _resumeCooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 28),
                        SizedBox(width: 8),
                        Text('继续', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  width: 200,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _pauseCooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.infoColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pause, size: 28),
                        SizedBox(width: 8),
                        Text('暂停', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

/// 面条卡片
class _NoodleCard extends StatelessWidget {
  final String icon;
  final String name;
  final int duration;
  final String story;
  final bool isSelected;
  final VoidCallback onTap;

  const _NoodleCard({
    required this.icon,
    required this.name,
    required this.duration,
    required this.story,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? AppTheme.warningColor.withOpacity(0.1)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? AppTheme.warningColor
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppTheme.warningColor
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$duration分钟',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.infoColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 冒泡动画
class _BubbleWidget extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Offset offset;

  const _BubbleWidget({
    required this.controller,
    required this.delay,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = ((controller.value + delay) % 1.0);
        final y = 100 - (progress * 150);
        final opacity = 1.0 - progress;
        
        return Transform.translate(
          offset: Offset(offset.dx, y),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}

