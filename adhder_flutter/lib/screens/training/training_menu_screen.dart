import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'go_nogo_game.dart';
import 'focus_bubbles_game.dart';

/// 认知训练游戏菜单
class TrainingMenuScreen extends StatelessWidget {
  const TrainingMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 认知训练'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            const Text(
              '选择训练项目',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '通过游戏提升专注力和认知能力',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 24),

            // 游戏列表
            _GameCard(
              icon: '🎯',
              title: 'Go/No-Go',
              description: '训练反应抑制能力，提升自控力',
              difficulty: '简单',
              duration: '2-3分钟',
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoNoGoGame()),
                );
              },
            ),

            const SizedBox(height: 16),

            _GameCard(
              icon: '🫧',
              title: '专注泡泡',
              description: '训练选择性注意力，过滤干扰信息',
              difficulty: '中等',
              duration: '1分钟',
              color: AppTheme.secondaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FocusBubblesGame()),
                );
              },
            ),

            const SizedBox(height: 16),

            // 即将推出的游戏
            _GameCard(
              icon: '🧠',
              title: 'N-back记忆',
              description: '训练工作记忆，提升短期记忆能力',
              difficulty: '困难',
              duration: '5分钟',
              color: AppTheme.accentColor,
              comingSoon: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('即将推出...')),
                );
              },
            ),

            const SizedBox(height: 16),

            _GameCard(
              icon: '🎨',
              title: 'Stroop色词',
              description: '训练认知灵活性，提升处理冲突信息能力',
              difficulty: '中等',
              duration: '3分钟',
              color: AppTheme.warningColor,
              comingSoon: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('即将推出...')),
                );
              },
            ),

            const SizedBox(height: 32),

            // 训练提示
            Card(
              color: AppTheme.infoColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: AppTheme.infoColor),
                        const SizedBox(width: 8),
                        const Text(
                          '训练小贴士',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• 每天训练10-15分钟效果最佳\n'
                      '• 找个安静的环境，减少干扰\n'
                      '• 循序渐进，从简单模式开始\n'
                      '• 坚持练习，21天养成习惯',
                      style: TextStyle(height: 1.8),
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

/// 游戏卡片
class _GameCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String difficulty;
  final String duration;
  final Color color;
  final bool comingSoon;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.color,
    this.comingSoon = false,
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
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          icon,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      if (comingSoon)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Soon',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondaryColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Tag(
                          label: difficulty,
                          color: _getDifficultyColor(difficulty),
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          label: duration,
                          color: AppTheme.infoColor,
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
                color: comingSoon
                    ? AppTheme.textHintColor
                    : AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '简单':
        return AppTheme.successColor;
      case '中等':
        return AppTheme.warningColor;
      case '困难':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
}

/// 标签
class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

