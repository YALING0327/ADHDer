/// 灵感笔记模型
class Insight {
  final String id;
  final String userId;
  final String content;
  final String contentType; // 'text', 'voice', 'image'
  final String? mediaUrl;
  final bool isProcessed;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Insight({
    required this.id,
    required this.userId,
    required this.content,
    this.contentType = 'text',
    this.mediaUrl,
    this.isProcessed = false,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      contentType: json['contentType'] ?? 'text',
      mediaUrl: json['mediaUrl'],
      isProcessed: json['isProcessed'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'contentType': contentType,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      'isProcessed': isProcessed,
      'tags': tags,
    };
  }

  Insight copyWith({
    String? content,
    String? contentType,
    String? mediaUrl,
    bool? isProcessed,
    List<String>? tags,
  }) {
    return Insight(
      id: id,
      userId: userId,
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isProcessed: isProcessed ?? this.isProcessed,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 获取内容类型图标
  String get typeIcon {
    switch (contentType) {
      case 'voice':
        return '🎤';
      case 'image':
        return '📷';
      case 'text':
      default:
        return '📝';
    }
  }

  /// 获取内容类型名称
  String get typeName {
    switch (contentType) {
      case 'voice':
        return '语音';
      case 'image':
        return '图片';
      case 'text':
      default:
        return '文字';
    }
  }
}

