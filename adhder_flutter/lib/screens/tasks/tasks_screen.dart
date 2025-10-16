import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import 'package:intl/intl.dart';

/// 任务页面
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 加载任务
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    final textController = TextEditingController();
    final taskType = ['todo', 'daily', 'habit'][_tabController.index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建任务'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: '任务名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isEmpty) return;

              final task = Task(
                id: '',
                userId: '',
                text: textController.text.trim(),
                type: taskType,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              final success = await context.read<TaskProvider>().createTask(task);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('任务创建成功')),
                  );
                }
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的任务'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '待办'),
            Tab(text: '日常'),
            Tab(text: '习惯'),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _TaskList(tasks: taskProvider.todos),
              _TaskList(tasks: taskProvider.dailies),
              _TaskList(tasks: taskProvider.habits),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 任务列表
class _TaskList extends StatelessWidget {
  final List<Task> tasks;

  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.task_alt,
              size: 64,
              color: AppTheme.textHintColor,
            ),
            const SizedBox(height: 16),
            const Text(
              '暂无任务',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                // TODO: 触发添加任务
              },
              icon: const Icon(Icons.add),
              label: const Text('添加第一个任务'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskCard(task: task);
      },
    );
  }
}

/// 任务卡片
class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) {
            context.read<TaskProvider>().toggleTaskComplete(
                  task.id,
                  value ?? false,
                );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          task.text,
          style: TextStyle(
            decoration: task.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.completed
                ? AppTheme.textSecondaryColor
                : AppTheme.textPrimaryColor,
          ),
        ),
        subtitle: task.date != null
            ? Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: task.isOverdue
                        ? AppTheme.errorColor
                        : AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MM-dd HH:mm').format(task.date!),
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isOverdue
                          ? AppTheme.errorColor
                          : AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              )
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: AppTheme.errorColor)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirm(context);
            } else if (value == 'edit') {
              // TODO: 编辑任务
            }
          },
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个任务吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<TaskProvider>().deleteTask(task.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('任务已删除')),
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

