class HistoryEntry {
  final int? id;
  final String toolId;
  final String toolName;
  final String input;
  final String output;
  final DateTime timestamp;

  const HistoryEntry({
    this.id,
    required this.toolId,
    required this.toolName,
    required this.input,
    required this.output,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tool_id': toolId,
      'tool_name': toolName,
      'input': input,
      'output': output,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'] as int?,
      toolId: map['tool_id'] as String,
      toolName: map['tool_name'] as String,
      input: map['input'] as String,
      output: map['output'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  HistoryEntry copyWith({
    int? id,
    String? toolId,
    String? toolName,
    String? input,
    String? output,
    DateTime? timestamp,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      toolId: toolId ?? this.toolId,
      toolName: toolName ?? this.toolName,
      input: input ?? this.input,
      output: output ?? this.output,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
