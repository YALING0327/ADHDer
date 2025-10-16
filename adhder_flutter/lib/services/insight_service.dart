import '../models/insight.dart';
import '../config/api_config.dart';
import 'api_client.dart';

/// 灵感存储服务
class InsightService {
  final ApiClient _api = ApiClient();

  /// 创建灵感笔记
  Future<Insight> createInsight({
    required String content,
    String contentType = 'text',
    String? mediaUrl,
    List<String>? tags,
  }) async {
    final response = await _api.post(
      ApiConfig.insights,
      data: {
        'content': content,
        'contentType': contentType,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
    );

    return Insight.fromJson(response.data['data']);
  }

  /// 获取灵感列表
  Future<List<Insight>> getInsights({
    bool? isProcessed,
    int limit = 50,
    int skip = 0,
  }) async {
    final response = await _api.get(
      ApiConfig.insights,
      queryParameters: {
        if (isProcessed != null) 'isProcessed': isProcessed,
        'limit': limit,
        'skip': skip,
      },
    );

    final insights = response.data['data'] as List;
    return insights.map((json) => Insight.fromJson(json)).toList();
  }

  /// 获取单个灵感
  Future<Insight> getInsight(String insightId) async {
    final response = await _api.get('${ApiConfig.insights}/$insightId');
    return Insight.fromJson(response.data['data']);
  }

  /// 更新灵感
  Future<Insight> updateInsight(String insightId, Insight insight) async {
    final response = await _api.put(
      '${ApiConfig.insights}/$insightId',
      data: insight.toJson(),
    );

    return Insight.fromJson(response.data['data']);
  }

  /// 标记为已处理
  Future<Insight> markAsProcessed(String insightId) async {
    final response = await _api.put(
      '${ApiConfig.insights}/$insightId',
      data: {'isProcessed': true},
    );

    return Insight.fromJson(response.data['data']);
  }

  /// 删除灵感
  Future<void> deleteInsight(String insightId) async {
    await _api.delete('${ApiConfig.insights}/$insightId');
  }

  /// 添加标签
  Future<Insight> addTags(String insightId, List<String> tags) async {
    final response = await _api.put(
      '${ApiConfig.insights}/$insightId',
      data: {'tags': tags},
    );

    return Insight.fromJson(response.data['data']);
  }
}

