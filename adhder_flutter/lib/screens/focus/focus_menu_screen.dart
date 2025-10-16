import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'pomodoro_screen.dart';
import 'noodle_focus_screen.dart';

/// 专注模式选择页面
class FocusMenuScreen extends StatelessWidget {
  const FocusMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专注模式'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            const Text(
              '选择专注模式',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '选择适合你的专注方式，开始高效学习',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 24),

            // 番茄钟
            _FocusModeCard(
              icon: '🍅',
              title: '番茄钟',
              description: '经典25分钟专注法，适合短时间集中任务',
              duration: '25分钟',
              color: AppTheme.errorColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PomodoroScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // 专注面条
            _FocusModeCard(
              icon: '🍜',
              title: '专注面条',
              description: '有趣的煮面模式，边专注边收集美味故事',
              duration: '15-30分钟',
              color: AppTheme.warningColor,
              badge: '趣味',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NoodleFocusScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // 旅人冒险
            _FocusModeCard(
              icon: '⚔️',
              title: '旅人冒险',
              description: '在冒险中保持专注，探索未知的旅程',
              duration: '自定义',
              color: AppTheme.successColor,
              badge: '冒险',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('旅人冒险功能开发中...')),
                );
              },
            ),

            const SizedBox(height: 32),

            // 今日统计
            const Text(
              '今日专注',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: '专注时长',
                      value: '0',
                      unit: '分钟',
                      icon: Icons.timer,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppTheme.borderColor,
                    ),
                    _StatItem(
                      label: '完成次数',
                      value: '0',
                      unit: '次',
                      icon: Icons.check_circle,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppTheme.borderColor,
                    ),
                    _StatItem(
                      label: '获得积分',
                      value: '0',
                      unit: '分',
                      icon: Icons.star,
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
}

/// 专注模式卡片
class _FocusModeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String duration;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const _FocusModeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.duration,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // 箭头
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textHintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 统计项
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

