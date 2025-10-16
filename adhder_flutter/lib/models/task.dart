/// 任务模型
class Task {
  final String id;
  final String userId;
  final String text;
  final String type; // 'todo', 'daily', 'habit'
  final String? notes;
  final bool completed;
  final double priority;
  final DateTime? date;
  final List<Checklist>? checklist;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.userId,
    required this.text,
    required this.type,
    this.notes,
    this.completed = false,
    this.priority = 1.0,
    this.date,
    this.checklist,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? 'todo',
      notes: json['notes'],
      completed: json['completed'] ?? false,
      priority: (json['priority'] ?? 1.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      checklist: json['checklist'] != null
          ? (json['checklist'] as List)
              .map((item) => Checklist.fromJson(item))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      if (notes != null) 'notes': notes,
      'completed': completed,
      'priority': priority,
      if (date != null) 'date': date!.toIso8601String(),
      if (checklist != null) 
        'checklist': checklist!.map((item) => item.toJson()).toList(),
    };
  }

  /// 复制并修改
  Task copyWith({
    String? text,
    String? notes,
    bool? completed,
    double? priority,
    DateTime? date,
    List<Checklist>? checklist,
  }) {
    return Task(
      id: id,
      userId: userId,
      text: text ?? this.text,
      type: type,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      checklist: checklist ?? this.checklist,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 获取子任务完成度
  double get checklistProgress {
    if (checklist == null || checklist!.isEmpty) return 0.0;
    final completedCount = checklist!.where((item) => item.completed).length;
    return completedCount / checklist!.length;
  }

  /// 是否有DDL
  bool get hasDeadline => date != null;

  /// 是否即将到期
  bool get isDueSoon {
    if (date == null) return false;
    final now = DateTime.now();
    final diff = date!.difference(now);
    return diff.inHours < 24 && diff.inHours > 0;
  }

  /// 是否已过期
  bool get isOverdue {
    if (date == null || completed) return false;
    return date!.isBefore(DateTime.now());
  }
}

/// 子任务
class Checklist {
  final String id;
  final String text;
  final bool completed;

  Checklist({
    required this.id,
    required this.text,
    this.completed = false,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'completed': completed,
    };
  }

  Checklist copyWith({
    String? text,
    bool? completed,
  }) {
    return Checklist(
      id: id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }
}

