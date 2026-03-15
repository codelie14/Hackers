import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class JsonCsvConverterWidget extends ConsumerStatefulWidget {
  const JsonCsvConverterWidget({super.key});

  @override
  ConsumerState<JsonCsvConverterWidget> createState() =>
      _JsonCsvConverterWidgetState();
}

class _JsonCsvConverterWidgetState
    extends ConsumerState<JsonCsvConverterWidget> {
  final _inputController = TextEditingController();
  String _mode = 'json_to_csv';
  String _result = '';

  final List<String> _modes = [
    'JSON → CSV',
    'CSV → JSON',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _jsonToCsv(String jsonStr) {
    final data = json.decode(jsonStr);

    if (data is! List) {
      throw Exception('JSON must be an array of objects');
    }

    if (data.isEmpty) {
      return '';
    }

    // Extract all unique headers
    final headers = <String>{};
    for (final item in data) {
      if (item is Map) {
        headers.addAll(item.keys.map((k) => k.toString()));
      }
    }

    final sortedHeaders = headers.toList()..sort();

    // Build CSV
    final buffer = StringBuffer();

    // Header row
    buffer.writeln(sortedHeaders.join(','));

    // Data rows
    for (final item in data) {
      if (item is Map) {
        final row = sortedHeaders.map((header) {
          final value = item[header];
          if (value == null) {
            return '';
          }
          final str = value.toString();
          // Escape quotes and wrap in quotes if contains comma or quote
          if (str.contains(',') || str.contains('"') || str.contains('\n')) {
            return '"${str.replaceAll('"', '""')}"';
          }
          return str;
        }).join(',');
        buffer.writeln(row);
      }
    }

    return buffer.toString();
  }

  String _csvToJson(String csvStr) {
    final lines = csvStr
        .split(RegExp(r'\r?\n'))
        .where((l) => l.trim().isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return '[]';
    }

    // Parse header
    final headers = _parseCsvLine(lines.first);

    // Parse data rows
    final result = [];
    for (var i = 1; i < lines.length; i++) {
      final values = _parseCsvLine(lines[i]);
      final obj = <String, dynamic>{};

      for (var j = 0; j < headers.length && j < values.length; j++) {
        obj[headers[j]] = values[j];
      }

      result.add(obj);
    }

    return JsonEncoder.withIndent('  ').convert(result);
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = '';
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current += '"';
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current.trim());
        current = '';
      } else {
        current += char;
      }
    }

    result.add(current.trim());
    return result;
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result =
          'Please enter ${_mode.contains('JSON') ? 'JSON' : 'CSV'} data');
      return;
    }

    try {
      String output;

      if (_mode == 'JSON → CSV') {
        output = _jsonToCsv(input);
      } else {
        output = _csvToJson(input);
      }

      final buffer = StringBuffer();
      buffer.writeln('CONVERSION RESULT');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln(output);

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'JSON ↔ CSV CONVERTER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'MODE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modes.map((mode) {
                final isSelected = mode == _mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _mode = mode;
                      _result = '';
                      _inputController.clear();
                    });
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _inputController,
              hintText: _mode == 'JSON → CSV'
                  ? 'Enter JSON array of objects...'
                  : 'Enter CSV data...',
              maxLines: 10,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.swap_horiz),
                label: Text('CONVERT ${_mode.toUpperCase()}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'OUTPUT',
                monospace: _mode == 'CSV → JSON',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
