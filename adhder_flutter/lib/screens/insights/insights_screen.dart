import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/insight.dart';
import '../../providers/insight_provider.dart';
import 'package:intl/intl.dart';

/// 灵感存储页面（贮水功能）
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 加载灵感列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InsightProvider>().loadInsights();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _showAddInsightDialog() {
    _textController.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题
            Row(
              children: [
                const Text(
                  '💧 快速贮水',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 输入框
            TextField(
              controller: _textController,
              maxLines: 5,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '记录你的灵感、想法、待办事项...\n\n它们都会被安全地贮存起来 💧',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 快速操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 语音输入
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('语音输入功能开发中...')),
                      );
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('语音'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 图片上传
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('图片上传功能开发中...')),
                      );
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('图片'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 保存按钮
            ElevatedButton(
              onPressed: () async {
                if (_textController.text.trim().isEmpty) {
                  return;
                }
                
                final success = await context.read<InsightProvider>().createInsight(
                  content: _textController.text.trim(),
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('💧 已贮存'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('保存'),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💧 贮水'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待处理'),
            Tab(text: '已处理'),
          ],
        ),
      ),
      body: Consumer<InsightProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _InsightList(
                insights: provider.pendingInsights,
                showProcessButton: true,
              ),
              _InsightList(
                insights: provider.processedInsights,
                showProcessButton: false,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddInsightDialog,
        icon: const Icon(Icons.add),
        label: const Text('快速贮水'),
      ),
    );
  }
}

/// 灵感列表
class _InsightList extends StatelessWidget {
  final List<Insight> insights;
  final bool showProcessButton;

  const _InsightList({
    required this.insights,
    required this.showProcessButton,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '💧',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              showProcessButton ? '暂无待处理灵感' : '暂无已处理灵感',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '随时记录你的灵感和想法',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textHintColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: insights.length,
      itemBuilder: (context, index) {
        final insight = insights[index];
        return _InsightCard(
          insight: insight,
          showProcessButton: showProcessButton,
        );
      },
    );
  }
}

/// 灵感卡片
class _InsightCard extends StatelessWidget {
  final Insight insight;
  final bool showProcessButton;

  const _InsightCard({
    required this.insight,
    required this.showProcessButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：类型和时间
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(insight.typeIcon, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        insight.typeName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.infoColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(insight.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 内容
            Text(
              insight.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            
            // 标签（如果有）
            if (insight.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: insight.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // 操作按钮
            Row(
              children: [
                if (showProcessButton)
                  TextButton.icon(
                    onPressed: () async {
                      await context.read<InsightProvider>().markAsProcessed(insight.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ 已标记为已处理'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('标记已处理'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.successColor,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppTheme.errorColor,
                  onPressed: () {
                    _showDeleteConfirm(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return DateFormat('MM-dd HH:mm').format(time);
    }
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条灵感吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<InsightProvider>().deleteInsight(insight.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已删除'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

