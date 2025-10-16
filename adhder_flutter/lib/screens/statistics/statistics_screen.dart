import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme.dart';
import 'package:intl/intl.dart';

/// 数据统计页面
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'week'; // 'week', 'month', 'year'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 数据统计'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'week', child: Text('本周')),
              const PopupMenuItem(value: 'month', child: Text('本月')),
              const PopupMenuItem(value: 'year', child: Text('本年')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '专注'),
            Tab(text: '任务'),
            Tab(text: '成长'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FocusStatistics(period: _selectedPeriod),
          _TaskStatistics(period: _selectedPeriod),
          _GrowthStatistics(period: _selectedPeriod),
        ],
      ),
    );
  }
}

/// 专注统计
class _FocusStatistics extends StatelessWidget {
  final String period;

  const _FocusStatistics({required this.period});

  @override
  Widget build(BuildContext context) {
    // TODO: 从API获取真实数据
    final mockData = _generateMockFocusData();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总览卡片
          _OverviewCard(
            title: '专注总时长',
            value: '12.5',
            unit: '小时',
            icon: Icons.timer,
            color: AppTheme.primaryColor,
            subtitle: '共完成 15 次专注',
          ),

          const SizedBox(height: 16),

          // 专注时长趋势图
          const Text(
            '专注时长趋势',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}h',
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: mockData,
                        isCurved: true,
                        color: AppTheme.primaryColor,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 专注模式分布
          const Text(
            '专注模式分布',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ModeDistributionBar(
                    icon: '🍅',
                    title: '番茄钟',
                    count: 8,
                    total: 15,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 12),
                  _ModeDistributionBar(
                    icon: '🍜',
                    title: '专注面条',
                    count: 5,
                    total: 15,
                    color: AppTheme.warningColor,
                  ),
                  const SizedBox(height: 12),
                  _ModeDistributionBar(
                    icon: '⚔️',
                    title: '旅人冒险',
                    count: 2,
                    total: 15,
                    color: AppTheme.successColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 数据卡片网格
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _DataCard(
                icon: Icons.check_circle,
                title: '完成率',
                value: '87%',
                color: AppTheme.successColor,
              ),
              _DataCard(
                icon: Icons.access_time,
                title: '平均时长',
                value: '50分钟',
                color: AppTheme.infoColor,
              ),
              _DataCard(
                icon: Icons.trending_up,
                title: '最长记录',
                value: '2小时',
                color: AppTheme.warningColor,
              ),
              _DataCard(
                icon: Icons.local_fire_department,
                title: '连续天数',
                value: '7天',
                color: AppTheme.errorColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateMockFocusData() {
    return [
      const FlSpot(0, 1.5),
      const FlSpot(1, 2.0),
      const FlSpot(2, 1.2),
      const FlSpot(3, 2.5),
      const FlSpot(4, 1.8),
      const FlSpot(5, 2.2),
      const FlSpot(6, 1.3),
    ];
  }
}

/// 任务统计
class _TaskStatistics extends StatelessWidget {
  final String period;

  const _TaskStatistics({required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总览
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: '已完成',
                  value: '28',
                  unit: '个',
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewCard(
                  title: '进行中',
                  value: '12',
                  unit: '个',
                  icon: Icons.pending,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 任务完成趋势
          const Text(
            '任务完成趋势',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 7, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 8, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 5, color: AppTheme.successColor)]),
                      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 3, color: AppTheme.successColor)]),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 任务类型分布
          const Text(
            '任务类型分布',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: 45,
                              title: '45%',
                              color: AppTheme.primaryColor,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: 30,
                              title: '30%',
                              color: AppTheme.secondaryColor,
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: 25,
                              title: '25%',
                              color: AppTheme.accentColor,
                              radius: 60,
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(color: AppTheme.primaryColor, label: '待办'),
                        const SizedBox(height: 8),
                        _LegendItem(color: AppTheme.secondaryColor, label: '日常'),
                        const SizedBox(height: 8),
                        _LegendItem(color: AppTheme.accentColor, label: '习惯'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 成长统计
class _GrowthStatistics extends StatelessWidget {
  final String period;

  const _GrowthStatistics({required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 等级进度
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '当前等级',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Lv 5',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('325 / 500 EXP', style: TextStyle(fontSize: 12)),
                      Text('还需 175 EXP', style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 积分统计
          Row(
            children: [
              Expanded(
                child: _DataCard(
                  icon: Icons.star,
                  title: '总积分',
                  value: '1,280',
                  color: AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DataCard(
                  icon: Icons.monetization_on,
                  title: '金币',
                  value: '650',
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 成就徽章
          const Text(
            '最近获得的成就',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _AchievementItem(
                    icon: '🏆',
                    title: '专注大师',
                    description: '完成100次专注会话',
                    date: DateTime.now().subtract(const Duration(days: 2)),
                  ),
                  const Divider(height: 24),
                  _AchievementItem(
                    icon: '⭐',
                    title: '连续打卡',
                    description: '连续7天完成每日任务',
                    date: DateTime.now().subtract(const Duration(days: 5)),
                  ),
                  const Divider(height: 24),
                  _AchievementItem(
                    icon: '💪',
                    title: '任务克星',
                    description: '完成50个待办任务',
                    date: DateTime.now().subtract(const Duration(days: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 总览卡片
class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textHintColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 模式分布条
class _ModeDistributionBar extends StatelessWidget {
  final String icon;
  final String title;
  final int count;
  final int total;
  final Color color;

  const _ModeDistributionBar({
    required this.icon,
    required this.title,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? count / total : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('$count次', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

/// 数据卡片
class _DataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _DataCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 图例项
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

/// 成就项
class _AchievementItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final DateTime date;

  const _AchievementItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          DateFormat('MM-dd').format(date),
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }
}

