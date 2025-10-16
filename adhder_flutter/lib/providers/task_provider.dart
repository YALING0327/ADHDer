import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// 任务状态管理
class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 待办任务
  List<Task> get todos => _tasks.where((t) => t.type == 'todo').toList();
  
  /// 日常任务
  List<Task> get dailies => _tasks.where((t) => t.type == 'daily').toList();
  
  /// 习惯任务
  List<Task> get habits => _tasks.where((t) => t.type == 'habit').toList();

  /// 加载任务列表
  Future<void> loadTasks({String? type}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskService.getTasks(type: type);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 创建任务
  Future<bool> createTask(Task task) async {
    try {
      final newTask = await _taskService.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 更新任务
  Future<bool> updateTask(String taskId, Task task) async {
    try {
      final updatedTask = await _taskService.updateTask(taskId, task);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 完成/取消完成任务
  Future<bool> toggleTaskComplete(String taskId, bool completed) async {
    try {
      await _taskService.completeTask(taskId, completed: completed);
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(completed: completed);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 删除任务
  Future<bool> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

