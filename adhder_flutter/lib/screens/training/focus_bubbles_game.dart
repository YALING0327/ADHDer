import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// 专注泡泡训练游戏
/// 
/// 规则：
/// - 点击屏幕上的目标泡泡（带星星⭐）
/// - 不要点击干扰泡泡
/// - 训练选择性注意力
class FocusBubblesGame extends StatefulWidget {
  const FocusBubblesGame({super.key});

  @override
  State<FocusBubblesGame> createState() => _FocusBubblesGameState();
}

class _FocusBubblesGameState extends State<FocusBubblesGame>
    with TickerProviderStateMixin {
  // 游戏状态
  bool _isPlaying = false;
  int _score = 0;
  int _targetCount = 0;
  int _distractorCount = 0;
  int _timeLeft = 60; // 60秒倒计时
  
  Timer? _gameTimer;
  Timer? _spawnTimer;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    for (var bubble in _bubbles) {
      bubble.controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    // 清理旧数据
    for (var bubble in _bubbles) {
      bubble.controller.dispose();
    }
    
    setState(() {
      _isPlaying = true;
      _score = 0;
      _targetCount = 0;
      _distractorCount = 0;
      _timeLeft = 60;
      _bubbles.clear();
    });

    // 倒计时
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _endGame();
      }
    });

    // 定期生成泡泡
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      _spawnBubble();
    });
  }

  void _spawnBubble() {
    if (!_isPlaying) return;

    final screenSize = MediaQuery.of(context).size;
    final isTarget = _random.nextDouble() < 0.4; // 40%概率是目标泡泡
    
    final x = 50.0 + _random.nextDouble() * (screenSize.width - 150);
    final y = screenSize.height * 0.3 + _random.nextDouble() * (screenSize.height * 0.4);

    final controller = AnimationController(
      duration: Duration(milliseconds: 2000 + _random.nextInt(1000)),
      vsync: this,
    );

    final bubble = Bubble(
      id: DateTime.now().millisecondsSinceEpoch,
      x: x,
      y: y,
      isTarget: isTarget,
      color: isTarget ? AppTheme.warningColor : _getRandomColor(),
      controller: controller,
    );

    setState(() => _bubbles.add(bubble));

    controller.forward();
    
    // 动画结束后移除泡泡
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _bubbles.removeWhere((b) => b.id == bubble.id));
        controller.dispose();
      }
    });
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      AppTheme.successColor,
      AppTheme.infoColor,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _handleBubbleTap(Bubble bubble) {
    bubble.controller.dispose();
    
    setState(() {
      _bubbles.removeWhere((b) => b.id == bubble.id);
      
      if (bubble.isTarget) {
        // 点击目标泡泡
        _targetCount++;
        _score += 10;
      } else {
        // 点击干扰泡泡
        _distractorCount++;
        _score = max(0, _score - 5);
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    
    setState(() => _isPlaying = false);

    final accuracy = (_targetCount + _distractorCount) > 0
        ? (_targetCount / (_targetCount + _distractorCount) * 100).toInt()
        : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('训练完成！'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('得分: $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('准确率: $accuracy%'),
            Text('目标泡泡: $_targetCount'),
            Text('干扰泡泡: $_distractorCount'),
            const SizedBox(height: 12),
            Text(
              accuracy >= 80 ? '🌟 专注力超强！' : accuracy >= 60 ? '💪 不错的表现！' : '🎯 继续练习！',
              style: TextStyle(
                fontSize: 16,
                color: accuracy >= 80 ? AppTheme.successColor : AppTheme.warningColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('再玩一次'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专注泡泡'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: _isPlaying ? _buildGameArea() : _buildStartScreen(),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🫧',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              '专注泡泡',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '训练选择性注意力',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            
            // 规则说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '游戏规则：',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRuleItem(
                      icon: '⭐',
                      text: '点击带星星的金色泡泡',
                      isGood: true,
                    ),
                    const SizedBox(height: 12),
                    _buildRuleItem(
                      icon: '🚫',
                      text: '不要点击其他颜色的泡泡',
                      isGood: false,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.infoColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.timer, size: 20, color: AppTheme.infoColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '时间限制：60秒\n点击目标+10分，误点-5分',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 28),
                    SizedBox(width: 8),
                    Text(
                      '开始训练',
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

  Widget _buildRuleItem({required String icon, required String text, required bool isGood}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (isGood ? AppTheme.successColor : AppTheme.errorColor).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildGameArea() {
    return Stack(
      children: [
        // 泡泡层
        ...bubbles.map((bubble) => _buildBubble(bubble)),

        // 顶部信息栏
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 20, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$_timeLeft秒',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 20, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(Bubble bubble) {
    return AnimatedBuilder(
      animation: bubble.controller,
      builder: (context, child) {
        final progress = bubble.controller.value;
        final scale = 0.5 + (progress * 0.5); // 从0.5放大到1.0
        final opacity = 1.0 - progress; // 逐渐透明

        return Positioned(
          left: bubble.x,
          top: bubble.y,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: () => _handleBubbleTap(bubble),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bubble.color,
                    boxShadow: [
                      BoxShadow(
                        color: bubble.color.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: bubble.isTarget
                      ? const Center(
                          child: Text(
                            '⭐',
                            style: TextStyle(fontSize: 32),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Bubble> get bubbles => List.from(_bubbles);
}

/// 泡泡数据类
class Bubble {
  final int id;
  final double x;
  final double y;
  final bool isTarget;
  final Color color;
  final AnimationController controller;

  Bubble({
    required this.id,
    required this.x,
    required this.y,
    required this.isTarget,
    required this.color,
    required this.controller,
  });
}

