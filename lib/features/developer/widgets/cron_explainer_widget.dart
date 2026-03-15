import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class CronExplainerWidget extends ConsumerStatefulWidget {
  const CronExplainerWidget({super.key});

  @override
  ConsumerState<CronExplainerWidget> createState() =>
      _CronExplainerWidgetState();
}

class _CronExplainerWidgetState extends ConsumerState<CronExplainerWidget> {
  final _cronController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _cronController.dispose();
    super.dispose();
  }

  String _parseCronField(String field, int min, int max, String unit) {
    if (field == '*') {
      return 'Every $unit';
    } else if (field.contains(',')) {
      return 'Values: ${field.split(',').join(', ')}';
    } else if (field.contains('-')) {
      final parts = field.split('-');
      return 'From ${parts[0]} to ${parts[1]}';
    } else if (field.contains('/')) {
      final parts = field.split('/');
      return 'Every ${parts[1]} $unit${int.parse(parts[1]) > 1 ? 's' : ''}';
    } else {
      return field;
    }
  }

  String _getOrdinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  void _explainCron() {
    final cron = _cronController.text.trim();
    if (cron.isEmpty) {
      setState(() => _result = 'Please enter a cron expression');
      return;
    }

    try {
      final parts = cron.split(RegExp(r'\s+'));
      if (parts.length < 5) {
        setState(() =>
            _result = 'Invalid cron expression. Must have at least 5 fields');
        return;
      }

      final minute = parts[0];
      final hour = parts[1];
      final dayOfMonth = parts[2];
      final month = parts[3];
      final dayOfWeek = parts[4];

      final buffer = StringBuffer();
      buffer.writeln('CRON EXPRESSION EXPLAINED');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Expression: $cron\n\n');

      buffer.writeln('FIELD BREAKDOWN');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln(
          '┌───────────── minute (0-59): ${_parseCronField(minute, 0, 59, 'minute')}\n');
      buffer.writeln(
          '│ ┌─────────── hour (0-23): ${_parseCronField(hour, 0, 23, 'hour')}\n');
      buffer.writeln(
          '│ │ ┌───────── day of month (1-31): ${_parseCronField(dayOfMonth, 1, 31, 'day')}\n');
      buffer.writeln(
          '│ │ │ ┌─────── month (1-12): ${_parseCronField(month, 1, 12, 'month')}\n');
      buffer.writeln(
          '│ │ │ │ ┌───── day of week (0-6, Sunday=0): ${_parseCronField(dayOfWeek, 0, 6, 'day')}\n');
      buffer.writeln('│ │ │ │ │\n');
      buffer.writeln('* * * * *\n\n');

      // Human readable description
      buffer.writeln('HUMAN READABLE DESCRIPTION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      String description = 'At ';

      // Time description
      if (minute == '*' && hour == '*') {
        description += 'every minute';
      } else if (minute == '*') {
        description += 'minute $hour';
      } else if (hour == '*') {
        description += '$minute minutes past every hour';
      } else {
        final hourNum =
            hour == '*' ? 'every hour' : '${_getOrdinal(int.parse(hour))} hour';
        final minNum = minute == '0' ? '' : ':$minute';
        description += '${hourNum}${minNum}';
      }

      // Day description
      if (dayOfMonth != '*' || dayOfWeek != '*') {
        if (dayOfMonth == '*' && dayOfWeek == '*') {
          description += ', every day';
        } else if (dayOfMonth == '*') {
          description +=
              ', every ${dayOfWeek == '0' ? 'Sunday' : dayOfWeek == '6' ? 'Saturday' : 'day ' + dayOfWeek}';
        } else if (dayOfWeek == '*') {
          description += ', on the ${_getOrdinal(int.parse(dayOfMonth))}';
        } else {
          description += ', on specific days';
        }
      } else {
        description += ', every day';
      }

      // Month description
      if (month != '*') {
        description += ', in month ${month}';
      }

      buffer.writeln('$description\n\n');

      // Next execution times
      buffer.writeln('NEXT EXECUTION TIMES');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      final now = DateTime.now();
      var nextTimes = <DateTime>[];

      // Simple simulation - check next 1000 minutes
      for (var i = 0; i < 1000 && nextTimes.length < 5; i++) {
        final checkTime = now.add(Duration(minutes: i));
        if (_matchesCron(
            checkTime, minute, hour, dayOfMonth, month, dayOfWeek)) {
          nextTimes.add(checkTime);
        }
      }

      for (final time in nextTimes) {
        buffer.writeln(
            '• ${time.toString().substring(0, 16)} (${_getRelativeTime(time)})\n');
      }

      buffer.writeln('\nEXAMPLES');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('* * * * *     → Every minute\n');
      buffer.writeln('0 * * * *     → Every hour at :00\n');
      buffer.writeln('*/15 * * * *   → Every 15 minutes\n');
      buffer.writeln('0 9 * * *     → Every day at 9:00 AM\n');
      buffer.writeln('0 9 * * 1-5   → Weekdays at 9:00 AM\n');
      buffer.writeln('0 0 1 * *     → First day of every month\n');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  bool _matchesCron(DateTime dt, String minute, String hour, String dayOfMonth,
      String month, String dayOfWeek) {
    return _matchesField(dt.minute, minute, 0, 59) &&
        _matchesField(dt.hour, hour, 0, 23) &&
        _matchesField(dt.day, dayOfMonth, 1, 31) &&
        _matchesField(dt.month, month, 1, 12) &&
        _matchesField(dt.weekday % 7, dayOfWeek, 0, 6);
  }

  bool _matchesField(int value, String field, int min, int max) {
    if (field == '*') return true;

    if (field.contains(',')) {
      return field.split(',').any((v) => int.parse(v) == value);
    }

    if (field.contains('-')) {
      final parts = field.split('-');
      return value >= int.parse(parts[0]) && value <= int.parse(parts[1]);
    }

    if (field.contains('/')) {
      final parts = field.split('/');
      final step = int.parse(parts[1]);
      final start = parts[0] == '*' ? min : int.parse(parts[0]);
      return (value - start) % step == 0;
    }

    return value == int.parse(field);
  }

  String _getRelativeTime(DateTime time) {
    final diff = time.difference(DateTime.now());
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return 'in ${diff.inMinutes}m';
    if (diff.inDays < 1) return 'in ${diff.inHours}h';
    return 'in ${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CRON EXPLAINER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'CRON EXPRESSION'),
            const SizedBox(height: 8),
            AppInput(
              controller: _cronController,
              hintText: 'e.g., */15 * * * * or 0 9 * * 1-5...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _explainCron,
                icon: const Icon(Icons.schedule),
                label: const Text('EXPLAIN CRON'),
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
                label: 'CRON EXPLANATION',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
