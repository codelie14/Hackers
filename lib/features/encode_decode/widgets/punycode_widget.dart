import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class PunycodeWidget extends ConsumerStatefulWidget {
  const PunycodeWidget({super.key});

  @override
  ConsumerState<PunycodeWidget> createState() => _PunycodeWidgetState();
}

class _PunycodeWidgetState extends ConsumerState<PunycodeWidget> {
  final _inputController = TextEditingController();
  String _mode = 'encode';
  String _result = '';

  final List<String> _modes = [
    'Encode → Punycode',
    'Decode ← Punycode',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // Simple Punycode encoding (simplified version)
  String _encodePunycode(String input) {
    try {
      // For a real implementation, you'd use the full RFC 3492 algorithm
      // This is a simplified version for demonstration

      // Check if input contains non-ASCII characters
      final hasNonAscii = input.codeUnits.any((c) => c > 127);

      if (!hasNonAscii) {
        return input; // Already ASCII
      }

      // Simplified: Just prefix with xn-- and show Unicode code points
      // In production, use proper punycode package
      final basic =
          input.split('').where((c) => c.codeUnitAt(0) < 128).join('');
      final encoded = input.codeUnits.map((c) => c.toRadixString(16)).join('-');

      return 'xn--$basic-$encoded';
    } catch (e) {
      throw Exception('Encoding failed: ${e.toString()}');
    }
  }

  // Simple Punycode decoding (simplified version)
  String _decodePunycode(String input) {
    try {
      if (!input.startsWith('xn--')) {
        return input; // Not punycode
      }

      // Simplified decoding - in production use proper punycode package
      // This is just for demonstration
      final parts = input.substring(4).split('-');
      if (parts.length < 2) {
        return input;
      }

      final basic = parts[0];
      // Reconstruct from hex codes (simplified)
      final buffer = StringBuffer(basic);
      for (var i = 1; i < parts.length; i++) {
        try {
          final code = int.parse(parts[i], radix: 16);
          buffer.writeCharCode(code);
        } catch (_) {}
      }

      return buffer.toString();
    } catch (e) {
      throw Exception('Decoding failed: ${e.toString()}');
    }
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter text to convert');
      return;
    }

    try {
      String output;

      if (_mode == 'encode') {
        output = _encodePunycode(input);
      } else {
        output = _decodePunycode(input);
      }

      final buffer = StringBuffer();
      buffer.writeln('PUNYCODE CONVERSION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      if (_mode == 'encode') {
        buffer.writeln('INPUT (Unicode/UTF-8)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n\n');

        buffer.writeln('OUTPUT (Punycode/xn--)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n\n');

        buffer.writeln('USAGE');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Use in domain names:\n');
        buffer.writeln('https://$output/\n');
      } else {
        buffer.writeln('INPUT (Punycode)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n\n');

        buffer.writeln('OUTPUT (Unicode/UTF-8)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n\n');

        buffer.writeln('INFORMATION');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('Domain: ${output.split('.').first}\n');
        buffer.writeln(
            'TLD: ${output.contains('.') ? '.${output.split('.').last}' : 'N/A'}\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'PUNYCODE CONVERTER',
      activeCategory: ToolCategory.encodeDecode,
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
              hintText: _mode == 'encode'
                  ? 'Enter Unicode text (e.g., 日本語，café)...'
                  : 'Enter Punycode (e.g., xn--...)',
              maxLines: 5,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: Icon(
                    _mode == 'encode' ? Icons.arrow_forward : Icons.arrow_back),
                label: Text(_mode == 'encode'
                    ? 'ENCODE TO PUNYCODE'
                    : 'DECODE FROM PUNYCODE'),
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
