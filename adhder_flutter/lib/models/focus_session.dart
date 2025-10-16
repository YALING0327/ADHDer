/// 专注会话模型
class FocusSession {
  final String id;
  final String userId;
  final String mode; // 'pomodoro', 'noodle', 'adventure'
  final int plannedDuration; // 计划时长(分钟)
  final int actualDuration; // 实际时长(分钟)
  final DateTime startTime;
  final DateTime? endTime;
  final String status; // 'active', 'paused', 'completed', 'abandoned'
  final bool interrupted;
  final int interruptionCount;
  final int pointsEarned;
  final String? relatedTaskId;
  final String? taskName;
  final Map<String, dynamic>? modeData;

  FocusSession({
    required this.id,
    required this.userId,
    required this.mode,
    required this.plannedDuration,
    this.actualDuration = 0,
    required this.startTime,
    this.endTime,
    this.status = 'active',
    this.interrupted = false,
    this.interruptionCount = 0,
    this.pointsEarned = 0,
    this.relatedTaskId,
    this.taskName,
    this.modeData,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      mode: json['mode'] ?? 'pomodoro',
      plannedDuration: json['plannedDuration'] ?? 25,
      actualDuration: json['actualDuration'] ?? 0,
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: json['status'] ?? 'active',
      interrupted: json['interrupted'] ?? false,
      interruptionCount: json['interruptionCount'] ?? 0,
      pointsEarned: json['pointsEarned'] ?? 0,
      relatedTaskId: json['relatedTaskId'],
      taskName: json['taskName'],
      modeData: json['modeData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'duration': plannedDuration,
      if (relatedTaskId != null) 'taskId': relatedTaskId,
      if (taskName != null) 'taskName': taskName,
      if (modeData != null) 'modeData': modeData,
    };
  }

  /// 完成率
  double get completionRate {
    if (plannedDuration == 0) return 0.0;
    return (actualDuration / plannedDuration * 100).clamp(0.0, 100.0);
  }

  /// 是否成功完成
  bool get isSuccessful {
    return status == 'completed' && completionRate >= 80;
  }

  /// 剩余时间(秒)
  int get remainingSeconds {
    if (status != 'active') return 0;
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final planned = plannedDuration * 60;
    return (planned - elapsed).clamp(0, planned);
  }

  /// 已用时间(秒)
  int get elapsedSeconds {
    if (endTime != null) {
      return endTime!.difference(startTime).inSeconds;
    }
    return DateTime.now().difference(startTime).inSeconds;
  }

  /// 获取模式显示名称
  String get modeDisplayName {
    switch (mode) {
      case 'pomodoro':
        return '番茄钟';
      case 'noodle':
        return '专注面条';
      case 'adventure':
        return '旅人冒险';
      default:
        return '专注模式';
    }
  }

  /// 获取模式图标
  String get modeIcon {
    switch (mode) {
      case 'pomodoro':
        return '🍅';
      case 'noodle':
        return '🍜';
      case 'adventure':
        return '⚔️';
      default:
        return '⏰';
    }
  }
}

/// 专注统计
class FocusStats {
  final int totalSessions;
  final int completedSessions;
  final double completionRate;
  final int totalMinutes;
  final double totalHours;
  final int totalPoints;
  final double averageMinutesPerSession;
  final int totalInterruptions;
  final Map<String, int> modeDistribution;

  FocusStats({
    required this.totalSessions,
    required this.completedSessions,
    required this.completionRate,
    required this.totalMinutes,
    required this.totalHours,
    required this.totalPoints,
    required this.averageMinutesPerSession,
    required this.totalInterruptions,
    required this.modeDistribution,
  });

  factory FocusStats.fromJson(Map<String, dynamic> json) {
    return FocusStats(
      totalSessions: json['totalSessions'] ?? 0,
      completedSessions: json['completedSessions'] ?? 0,
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      totalMinutes: json['totalMinutes'] ?? 0,
      totalHours: (json['totalHours'] ?? 0).toDouble(),
      totalPoints: json['totalPoints'] ?? 0,
      averageMinutesPerSession: (json['averageMinutesPerSession'] ?? 0).toDouble(),
      totalInterruptions: json['totalInterruptions'] ?? 0,
      modeDistribution: Map<String, int>.from(json['modeDistribution'] ?? {}),
    );
  }
}

