import 'package:flutter/material.dart';
import '../models/insight.dart';
import '../services/insight_service.dart';

/// 灵感存储状态管理
class InsightProvider with ChangeNotifier {
  final InsightService _insightService = InsightService();
  
  List<Insight> _insights = [];
  bool _isLoading = false;
  String? _error;

  List<Insight> get insights => _insights;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 待处理的灵感
  List<Insight> get pendingInsights =>
      _insights.where((i) => !i.isProcessed).toList();

  /// 已处理的灵感
  List<Insight> get processedInsights =>
      _insights.where((i) => i.isProcessed).toList();

  /// 加载灵感列表
  Future<void> loadInsights({bool? isProcessed}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _insights = await _insightService.getInsights(isProcessed: isProcessed);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 创建灵感
  Future<bool> createInsight({
    required String content,
    String contentType = 'text',
    String? mediaUrl,
    List<String>? tags,
  }) async {
    try {
      final newInsight = await _insightService.createInsight(
        content: content,
        contentType: contentType,
        mediaUrl: mediaUrl,
        tags: tags,
      );
      _insights.insert(0, newInsight);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 更新灵感
  Future<bool> updateInsight(String insightId, Insight insight) async {
    try {
      final updatedInsight =
          await _insightService.updateInsight(insightId, insight);
      final index = _insights.indexWhere((i) => i.id == insightId);
      if (index != -1) {
        _insights[index] = updatedInsight;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 标记为已处理
  Future<bool> markAsProcessed(String insightId) async {
    try {
      final updatedInsight = await _insightService.markAsProcessed(insightId);
      final index = _insights.indexWhere((i) => i.id == insightId);
      if (index != -1) {
        _insights[index] = updatedInsight;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 删除灵感
  Future<bool> deleteInsight(String insightId) async {
    try {
      await _insightService.deleteInsight(insightId);
      _insights.removeWhere((i) => i.id == insightId);
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

