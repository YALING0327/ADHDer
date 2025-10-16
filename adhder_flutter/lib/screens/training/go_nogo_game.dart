import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Go/No-Go认知训练游戏
/// 
/// 规则：
/// - 看到绿色圆圈时点击屏幕（Go）
/// - 看到红色圆圈时不点击（No-Go）
/// - 训练反应抑制能力
class GoNoGoGame extends StatefulWidget {
  const GoNoGoGame({super.key});

  @override
  State<GoNoGoGame> createState() => _GoNoGoGameState();
}

class _GoNoGoGameState extends State<GoNoGoGame> {
  // 游戏状态
  bool _isPlaying = false;
  bool _showStimulus = false;
  bool _isGoStimulus = false; // true: Go(绿色), false: No-Go(红色)
  
  // 游戏数据
  int _round = 0;
  int _totalRounds = 20;
  int _score = 0;
  int _correctCount = 0;
  int _falseAlarmCount = 0; // 错误点击红色
  int _missCount = 0; // 漏点绿色
  
  Timer? _gameTimer;
  final Random _random = Random();
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _round = 0;
      _score = 0;
      _correctCount = 0;
      _falseAlarmCount = 0;
      _missCount = 0;
    });
    
    _nextRound();
  }

  void _nextRound() {
    if (_round >= _totalRounds) {
      _endGame();
      return;
    }

    setState(() {
      _round++;
      _showStimulus = false;
    });

    // 随机延迟1-2秒后显示刺激
    final delay = 1000 + _random.nextInt(1000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (!mounted || !_isPlaying) return;
      
      setState(() {
        _showStimulus = true;
        // 70% 概率是Go刺激
        _isGoStimulus = _random.nextDouble() < 0.7;
      });

      // 1.5秒后自动进入下一轮（如果用户未点击）
      _gameTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!mounted || !_showStimulus) return;
        
        // 如果是Go刺激但用户没点，算miss
        if (_isGoStimulus) {
          setState(() => _missCount++);
        } else {
          // 如果是No-Go刺激且用户没点，算正确
          setState(() {
            _correctCount++;
            _score += 10;
          });
        }
        
        _nextRound();
      });
    });
  }

  void _handleTap() {
    if (!_showStimulus) return;

    _gameTimer?.cancel();

    setState(() {
      if (_isGoStimulus) {
        // 正确点击绿色
        _correctCount++;
        _score += 10;
      } else {
        // 错误点击红色
        _falseAlarmCount++;
        _score = max(0, _score - 5);
      }
    });

    _nextRound();
  }

  void _endGame() {
    setState(() => _isPlaying = false);
    
    final accuracy = _totalRounds > 0 
        ? (_correctCount / _totalRounds * 100).toInt() 
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
            Text('正确率: $accuracy%'),
            Text('正确反应: $_correctCount'),
            Text('错误点击: $_falseAlarmCount'),
            Text('漏点: $_missCount'),
            const SizedBox(height: 12),
            Text(
              accuracy >= 80 ? '👏 表现优秀！' : accuracy >= 60 ? '💪 继续加油！' : '🌟 多多练习！',
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
        title: const Text('Go/No-Go训练'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.05),
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
              '🎯',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              'Go/No-Go训练',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '训练反应抑制能力',
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
                    _RuleItem(
                      color: AppTheme.successColor,
                      icon: '✓',
                      text: '看到绿色圆圈 → 快速点击屏幕',
                    ),
                    const SizedBox(height: 12),
                    _RuleItem(
                      color: AppTheme.errorColor,
                      icon: '✗',
                      text: '看到红色圆圈 → 不要点击！',
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
                          Icon(Icons.info_outline, size: 20, color: AppTheme.infoColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '保持专注，快速反应！\n共20轮，每轮约1.5秒',
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
                  backgroundColor: AppTheme.primaryColor,
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

  Widget _buildGameArea() {
    return Column(
      children: [
        // 顶部信息栏
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '轮次: $_round/$_totalRounds',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 20, color: AppTheme.warningColor),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 游戏区域
        Expanded(
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showStimulus ? 1.0 : 0.0,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isGoStimulus 
                          ? AppTheme.successColor 
                          : AppTheme.errorColor,
                      boxShadow: [
                        BoxShadow(
                          color: (_isGoStimulus 
                                  ? AppTheme.successColor 
                                  : AppTheme.errorColor)
                              .withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 底部提示
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _showStimulus 
                ? (_isGoStimulus ? '点击！' : '不要点击！')
                : '准备...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _showStimulus
                  ? (_isGoStimulus ? AppTheme.successColor : AppTheme.errorColor)
                  : AppTheme.textHintColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// 规则项
class _RuleItem extends StatelessWidget {
  final Color color;
  final String icon;
  final String text;

  const _RuleItem({
    required this.color,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

