import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class TimestampConverterWidget extends ConsumerStatefulWidget {
  const TimestampConverterWidget({super.key});

  @override
  ConsumerState<TimestampConverterWidget> createState() =>
      _TimestampConverterWidgetState();
}

class _TimestampConverterWidgetState
    extends ConsumerState<TimestampConverterWidget> {
  final _inputController = TextEditingController();
  String _selectedMode = 'timestamp_to_date';
  String _result = '';

  final List<String> _modes = [
    'Timestamp → Date',
    'Date → Timestamp',
    'Current Timestamp',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _convert() {
    final input = _inputController.text.trim();

    try {
      final buffer = StringBuffer();
      buffer.writeln('TIMESTAMP CONVERTER');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      if (_selectedMode == 'Current Timestamp') {
        final now = DateTime.now();
        final timestamp = now.millisecondsSinceEpoch ~/ 1000;

        buffer.writeln('CURRENT TIME');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Unix Timestamp: $timestamp\n');
        buffer.writeln('UTC Date: ${now.toUtc().toIso8601String()}\n');
        buffer.writeln('Local Date: ${now.toIso8601String()}\n\n');

        buffer.writeln('COMMON FORMATS');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln(
            'ISO 8601: ${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now)}\n');
        buffer.writeln(
            'RFC 2822: ${DateFormat("EEE, dd MMM yyyy HH:mm:ss").format(now)}\n');
        buffer.writeln(
            'Human: ${DateFormat("EEEE, MMMM d, yyyy 'at' h:mm a").format(now)}\n');
      } else if (_selectedMode == 'Timestamp → Date') {
        if (input.isEmpty) {
          setState(() => _result = 'Please enter a Unix timestamp');
          return;
        }

        final timestamp = int.tryParse(input);
        if (timestamp == null) {
          setState(() => _result = 'Invalid timestamp format');
          return;
        }

        final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        final utcDate =
            DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);

        buffer.writeln('INPUT');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Unix Timestamp: $timestamp\n\n');

        buffer.writeln('CONVERTED DATES');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('UTC: ${utcDate.toIso8601String()}\n');
        buffer.writeln('Local: ${date.toIso8601String()}\n\n');

        buffer.writeln('FORMATTED DATES');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln(
            'ISO 8601: ${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date)}\n');
        buffer.writeln('Short: ${DateFormat("yyyy-MM-dd").format(date)}\n');
        buffer.writeln(
            'Long: ${DateFormat("EEEE, MMMM d, yyyy").format(date)}\n');
        buffer.writeln('Time: ${DateFormat("HH:mm:ss").format(date)}\n');
        buffer.writeln(
            'RFC 2822: ${DateFormat("EEE, dd MMM yyyy HH:mm:ss").format(date)}\n');

        // Time ago
        final now = DateTime.now();
        final diff = now.difference(date);
        buffer.writeln('\nRELATIVE TIME');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        if (diff.inMinutes < 1) {
          buffer.writeln('Just now\n');
        } else if (diff.inHours < 1) {
          buffer.writeln('${diff.inMinutes} minutes ago\n');
        } else if (diff.inDays < 1) {
          buffer.writeln('${diff.inHours} hours ago\n');
        } else if (diff.inDays < 30) {
          buffer.writeln('${diff.inDays} days ago\n');
        } else if (diff.inDays < 365) {
          buffer.writeln('${(diff.inDays / 30).floor()} months ago\n');
        } else {
          buffer.writeln('${(diff.inDays / 365).floor()} years ago\n');
        }
      } else if (_selectedMode == 'Date → Timestamp') {
        if (input.isEmpty) {
          setState(() =>
              _result = 'Please enter a date (ISO format or common formats)');
          return;
        }

        // Try to parse the date
        DateTime? parsedDate;
        final formats = [
          'yyyy-MM-ddTHH:mm:ss',
          'yyyy-MM-dd HH:mm:ss',
          'yyyy-MM-dd',
          'dd/MM/yyyy HH:mm:ss',
          'dd/MM/yyyy',
          'MM/dd/yyyy HH:mm:ss',
          'MM/dd/yyyy',
        ];

        for (final format in formats) {
          try {
            parsedDate = DateFormat(format).parse(input);
            break;
          } catch (_) {}
        }

        if (parsedDate == null) {
          // Try direct parsing
          try {
            parsedDate = DateTime.parse(input);
          } catch (_) {
            setState(() => _result =
                'Unable to parse date. Try ISO format: YYYY-MM-DD HH:MM:SS');
            return;
          }
        }

        final timestamp = parsedDate.millisecondsSinceEpoch ~/ 1000;

        buffer.writeln('INPUT DATE');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Date: ${parsedDate.toIso8601String()}\n\n');

        buffer.writeln('UNIX TIMESTAMP');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Timestamp (seconds): $timestamp\n');
        buffer
            .writeln('Timestamp (ms): ${parsedDate.millisecondsSinceEpoch}\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'TIMESTAMP CONVERTER',
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
                final isSelected = mode == _selectedMode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedMode = mode;
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
            if (_selectedMode != 'Current Timestamp') ...[
              const SectionHeader(title: 'INPUT'),
              const SizedBox(height: 8),
              AppInput(
                controller: _inputController,
                hintText: _selectedMode == 'Timestamp → Date'
                    ? 'Enter Unix timestamp...'
                    : 'Enter date (YYYY-MM-DD HH:MM:SS)...',
                onChanged: (_) {
                  if (_result.isNotEmpty) setState(() => _result = '');
                },
              ),
              const SizedBox(height: 16),
            ],
            Center(
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.swap_horiz),
                label: Text(_selectedMode == 'Current Timestamp'
                    ? 'GET CURRENT TIMESTAMP'
                    : 'CONVERT'),
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
                label: 'CONVERSION RESULT',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
