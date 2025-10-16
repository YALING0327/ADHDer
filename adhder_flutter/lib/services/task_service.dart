import '../models/task.dart';
import '../config/api_config.dart';
import 'api_client.dart';

/// 任务服务
class TaskService {
  final ApiClient _api = ApiClient();

  /// 获取任务列表
  Future<List<Task>> getTasks({String? type}) async {
    final response = await _api.get(
      ApiConfig.tasks,
      queryParameters: type != null ? {'type': type} : null,
    );

    final data = response.data['data'];
    if (data is List) {
      return data.map((json) => Task.fromJson(json)).toList();
    }
    return [];
  }

  /// 创建任务
  Future<Task> createTask(Task task) async {
    final response = await _api.post(
      ApiConfig.taskCreate,
      data: task.toJson(),
    );

    return Task.fromJson(response.data['data']);
  }

  /// 更新任务
  Future<Task> updateTask(String taskId, Task task) async {
    final response = await _api.put(
      '${ApiConfig.tasks}/$taskId',
      data: task.toJson(),
    );

    return Task.fromJson(response.data['data']);
  }

  /// 完成任务
  Future<void> completeTask(String taskId, {required bool completed}) async {
    await _api.post(
      '${ApiConfig.tasks}/$taskId/score/${completed ? "up" : "down"}',
    );
  }

  /// 删除任务
  Future<void> deleteTask(String taskId) async {
    await _api.delete('${ApiConfig.tasks}/$taskId');
  }
}

