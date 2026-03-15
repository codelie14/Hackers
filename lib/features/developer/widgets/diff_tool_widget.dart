import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class DiffToolWidget extends ConsumerStatefulWidget {
  const DiffToolWidget({super.key});

  @override
  ConsumerState<DiffToolWidget> createState() => _DiffToolWidgetState();
}

class _DiffToolWidgetState extends ConsumerState<DiffToolWidget> {
  final _originalController = TextEditingController();
  final _modifiedController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _originalController.dispose();
    _modifiedController.dispose();
    super.dispose();
  }

  List<String> _computeDiffLines(String original, String modified) {
    final originalLines = original.split('\n');
    final modifiedLines = modified.split('\n');
    final result = <String>[];

    // Simple line-by-line diff algorithm
    int i = 0, j = 0;

    while (i < originalLines.length || j < modifiedLines.length) {
      if (i >= originalLines.length) {
        // Only modified lines remain - these are additions
        result.add('+ ${modifiedLines[j]}');
        j++;
      } else if (j >= modifiedLines.length) {
        // Only original lines remain - these are deletions
        result.add('- ${originalLines[i]}');
        i++;
      } else if (originalLines[i] == modifiedLines[j]) {
        // Lines match - unchanged
        result.add('  ${originalLines[i]}');
        i++;
        j++;
      } else {
        // Lines differ - check for nearby matches
        bool foundMatch = false;

        // Look ahead in modified to see if this line appears later
        for (int k = j + 1; k < modifiedLines.length && k < j + 5; k++) {
          if (originalLines[i] == modifiedLines[k]) {
            // Found match later in modified - current original line is deleted
            result.add('- ${originalLines[i]}');
            i++;
            foundMatch = true;
            break;
          }
        }

        if (!foundMatch) {
          // Look ahead in original to see if modified line appears later
          for (int k = i + 1; k < originalLines.length && k < i + 5; k++) {
            if (modifiedLines[j] == originalLines[k]) {
              // Found match later in original - current modified line is added
              result.add('+ ${modifiedLines[j]}');
              j++;
              foundMatch = true;
              break;
            }
          }
        }

        if (!foundMatch) {
          // No match found - treat as change (delete then add)
          result.add('- ${originalLines[i]}');
          result.add('+ ${modifiedLines[j]}');
          i++;
          j++;
        }
      }
    }

    return result;
  }

  void _runDiff() {
    final original = _originalController.text;
    final modified = _modifiedController.text;

    if (original.isEmpty && modified.isEmpty) {
      setState(() => _result = 'Please enter text in both fields');
      return;
    }

    try {
      final diffLines = _computeDiffLines(original, modified);

      // Calculate statistics
      var additions = 0;
      var deletions = 0;
      var unchanged = 0;

      for (final line in diffLines) {
        if (line.startsWith('+'))
          additions++;
        else if (line.startsWith('-'))
          deletions++;
        else
          unchanged++;
      }

      final buffer = StringBuffer();
      buffer.writeln('DIFF RESULTS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('STATISTICS\n');
      buffer.writeln('Original Lines: ${original.split('\n').length}\n');
      buffer.writeln('Modified Lines: ${modified.split('\n').length}\n');
      buffer.writeln('Additions: +$additions\n');
      buffer.writeln('Deletions: -$deletions\n');
      buffer.writeln('Unchanged: $unchanged\n\n');

      buffer.writeln('UNIFIED DIFF OUTPUT');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // Add unified diff header
      buffer.writeln('--- original.txt\n');
      buffer.writeln('+++ modified.txt\n');
      final origLines = original.split('\n').length;
      final modLines = modified.split('\n').length;
      buffer.writeln('@@ -1,$origLines +1,$modLines @@\n\n');

      // Add diff content with line numbers
      int lineNum = 1;
      for (final line in diffLines) {
        if (line.startsWith(' ')) {
          buffer.writeln('$lineNum $line\n');
          lineNum++;
        } else if (line.startsWith('-')) {
          buffer.writeln('   $line\n');
        } else if (line.startsWith('+')) {
          buffer.writeln('$lineNum $line\n');
          lineNum++;
        }
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DIFF TOOL',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'ORIGINAL TEXT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _originalController,
              hintText: 'Paste original text here...',
              maxLines: 8,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'MODIFIED TEXT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _modifiedController,
              hintText: 'Paste modified text here...',
              maxLines: 8,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _runDiff,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('COMPARE TEXTS'),
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
                label: 'UNIFIED DIFF',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
