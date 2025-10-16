import '../models/focus_session.dart';
import '../config/api_config.dart';
import 'api_client.dart';

/// 专注服务
class FocusService {
  final ApiClient _api = ApiClient();

  /// 开始专注会话
  Future<FocusSession> startSession({
    required String mode,
    required int duration,
    String? taskId,
    String? taskName,
    Map<String, dynamic>? modeData,
  }) async {
    final response = await _api.post(
      ApiConfig.focusSessions,
      data: {
        'mode': mode,
        'duration': duration,
        if (taskId != null) 'taskId': taskId,
        if (taskName != null) 'taskName': taskName,
        if (modeData != null) 'modeData': modeData,
      },
    );

    return FocusSession.fromJson(response.data['data']);
  }

  /// 获取当前活跃会话
  Future<FocusSession?> getActiveSession() async {
    try {
      final response = await _api.get(ApiConfig.focusActive);
      final session = response.data['data']?['session'];
      return session != null ? FocusSession.fromJson(session) : null;
    } catch (e) {
      return null;
    }
  }

  /// 暂停会话
  Future<FocusSession> pauseSession(String sessionId) async {
    final response = await _api.put(
      '${ApiConfig.focusSessions}/$sessionId/pause',
    );

    return FocusSession.fromJson(response.data['data']);
  }

  /// 恢复会话
  Future<FocusSession> resumeSession(String sessionId) async {
    final response = await _api.put(
      '${ApiConfig.focusSessions}/$sessionId/resume',
    );

    return FocusSession.fromJson(response.data['data']);
  }

  /// 完成会话
  Future<Map<String, dynamic>> completeSession(
    String sessionId, {
    int? actualMinutes,
    Map<String, dynamic>? modeData,
  }) async {
    final response = await _api.post(
      '${ApiConfig.focusSessions}/$sessionId/complete',
      data: {
        if (actualMinutes != null) 'actualMinutes': actualMinutes,
        if (modeData != null) 'modeData': modeData,
      },
    );

    return response.data['data'];
  }

  /// 放弃会话
  Future<Map<String, dynamic>> abandonSession(String sessionId) async {
    final response = await _api.post(
      '${ApiConfig.focusSessions}/$sessionId/abandon',
    );

    return response.data['data'];
  }

  /// 记录中断
  Future<void> recordInterruption(
    String sessionId, {
    String reason = 'other',
  }) async {
    await _api.post(
      '${ApiConfig.focusSessions}/$sessionId/interrupt',
      data: {'reason': reason},
    );
  }

  /// 获取专注历史
  Future<List<FocusSession>> getSessions({
    int limit = 20,
    int skip = 0,
    String? status,
    String? mode,
  }) async {
    final response = await _api.get(
      ApiConfig.focusSessions,
      queryParameters: {
        'limit': limit,
        'skip': skip,
        if (status != null) 'status': status,
        if (mode != null) 'mode': mode,
      },
    );

    final sessions = response.data['data']['sessions'] as List;
    return sessions.map((json) => FocusSession.fromJson(json)).toList();
  }

  /// 获取专注统计
  Future<FocusStats> getStats({String period = 'week'}) async {
    final response = await _api.get(
      ApiConfig.focusStats,
      queryParameters: {'period': period},
    );

    return FocusStats.fromJson(response.data['data']['stats']);
  }
}

