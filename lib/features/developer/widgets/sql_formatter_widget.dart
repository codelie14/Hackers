import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class SqlFormatterWidget extends ConsumerStatefulWidget {
  const SqlFormatterWidget({super.key});

  @override
  ConsumerState<SqlFormatterWidget> createState() => _SqlFormatterWidgetState();
}

class _SqlFormatterWidgetState extends ConsumerState<SqlFormatterWidget> {
  final _controller = TextEditingController();
  String _result = '';
  String _error = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatSql(String sql) {
    var formatted = sql.trim();

    // Keywords to uppercase
    final keywords = [
      'SELECT',
      'FROM',
      'WHERE',
      'INSERT',
      'INTO',
      'VALUES',
      'UPDATE',
      'SET',
      'DELETE',
      'JOIN',
      'LEFT',
      'RIGHT',
      'INNER',
      'OUTER',
      'ON',
      'AND',
      'OR',
      'ORDER',
      'BY',
      'GROUP',
      'HAVING',
      'LIMIT',
      'OFFSET',
      'AS',
      'DISTINCT',
      'CREATE',
      'TABLE',
      'ALTER',
      'DROP',
      'PRIMARY',
      'KEY',
      'FOREIGN',
      'REFERENCES',
      'INDEX',
      'UNIQUE',
      'NOT',
      'NULL',
      'DEFAULT',
      'CHECK',
      'CONSTRAINT',
      'UNION',
      'ALL',
      'EXISTS',
      'BETWEEN',
      'IN',
      'LIKE',
      'IS',
      'ASC',
      'DESC',
      'CASE',
      'WHEN',
      'THEN',
      'ELSE',
      'END',
      'CAST',
      'AS',
      'WITH',
    ];

    // Uppercase keywords
    for (final keyword in keywords) {
      formatted = formatted.replaceAll(
          RegExp('\\b$keyword\\b', caseSensitive: false), keyword);
    }

    // Add newlines after certain keywords
    formatted = formatted.replaceAll(
      RegExp(
          '\\b(SELECT|FROM|WHERE|INSERT|INTO|VALUES|UPDATE|SET|DELETE|JOIN|ORDER|GROUP|HAVING|LIMIT)\\b',
          caseSensitive: false),
      '\n\$1 ',
    );

    // Clean up multiple newlines
    formatted = formatted.replaceAll(RegExp(r'\n\s*\n'), '\n');

    return formatted.trim();
  }

  void _format() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final sql = _controller.text.trim();
      if (sql.isEmpty) {
        setState(() => _error = 'Please enter SQL query');
        return;
      }

      setState(() => _result = _formatSql(sql));
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SQL FORMATTER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'SQL QUERY'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _controller,
              hintText: 'Enter SQL query to format...',
              minLines: 4,
              maxLines: 10,
              onChanged: (_) => setState(() {
                _result = '';
                _error = '';
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'FORMAT SQL',
              icon: Icons.format_align_left,
              onPressed: _format,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(content: _error, isError: true),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'FORMATTED SQL',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
