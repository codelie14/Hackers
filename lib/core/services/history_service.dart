import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// History entry for recently used tools
class HistoryEntry {
  final String toolId;
  final String toolName;
  final DateTime timestamp;

  HistoryEntry({
    required this.toolId,
    required this.toolName,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'toolId': toolId,
        'toolName': toolName,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        toolId: json['toolId'],
        toolName: json['toolName'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

/// Service to manage tool usage history
class HistoryService {
  static const String _historyKey = 'app_history_v1';
  static const int _maxHistory = 20; // Keep last 20 tools

  /// Add a tool to history
  static Future<void> addToHistory(String toolId, String toolName) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    // Remove existing entry if present (to move it to top)
    history.removeWhere((entry) => entry.toolId == toolId);

    // Add new entry at the beginning
    history.insert(
        0,
        HistoryEntry(
            toolId: toolId, toolName: toolName, timestamp: DateTime.now()));

    // Limit to max entries
    if (history.length > _maxHistory) {
      history.removeRange(_maxHistory, history.length);
    }

    // Save back
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  /// Get history entries (most recent first)
  static Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_historyKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(data) as List;
      final entries = decoded.map((e) => HistoryEntry.fromJson(e)).toList();
      return entries;
    } catch (e) {
      return [];
    }
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
