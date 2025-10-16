import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// 番茄钟页面
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int defaultDuration = 25 * 60; // 25分钟
  int remainingSeconds = defaultDuration;
  Timer? _timer;
  bool isRunning = false;
  bool isPaused = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      isRunning = true;
      isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      isPaused = false;
    });
    _startTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = false;
      remainingSeconds = defaultDuration;
    });
  }

  void _completeSession() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = false;
    });

    // 显示完成提示
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🎉 ', style: TextStyle(fontSize: 24)),
            Text('完成！'),
          ],
        ),
        content: const Text('恭喜你完成了一个番茄钟！\n获得 +10 积分'),
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
              setState(() {
                remainingSeconds = defaultDuration;
              });
            },
            child: const Text('再来一个'),
          ),
        ],
      ),
    );
  }

  String get timeDisplay {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    return 1 - (remainingSeconds / defaultDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('番茄钟'),
        actions: [
          if (isRunning)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认放弃'),
                    content: const Text('确定要放弃这个番茄钟吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('继续'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _stopTimer();
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
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.errorColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 番茄图标
              const Text(
                '🍅',
                style: TextStyle(fontSize: 80),
              ),
              
              const SizedBox(height: 40),

              // 圆形进度条
              SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 背景圆
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    
                    // 进度圆环
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: AppTheme.borderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isRunning && !isPaused
                              ? AppTheme.errorColor
                              : AppTheme.textHintColor,
                        ),
                      ),
                    ),
                    
                    // 时间显示
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeDisplay,
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isRunning
                              ? (isPaused ? '已暂停' : '专注中...')
                              : '准备开始',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // 控制按钮
              if (!isRunning)
                SizedBox(
                  width: 200,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
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
                          '开始专注',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isPaused)
                SizedBox(
                  width: 200,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _resumeTimer,
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
                        Text(
                          '继续',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 200,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _pauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pause, size: 28),
                        SizedBox(width: 8),
                        Text(
                          '暂停',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // 提示信息
              if (isRunning && !isPaused)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '💪 保持专注，你可以的！',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
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

