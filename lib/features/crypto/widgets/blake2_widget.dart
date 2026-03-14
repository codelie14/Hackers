import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Blake2HashWidget extends ConsumerStatefulWidget {
  const Blake2HashWidget({super.key});

  @override
  ConsumerState<Blake2HashWidget> createState() => _Blake2HashWidgetState();
}

class _Blake2HashWidgetState extends ConsumerState<Blake2HashWidget> {
  final _controller = TextEditingController();
  String _result = '';
  bool _useBlake2b = true;
  int _digestSize = 32;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Simplified BLAKE2 implementation using pointycastle if available
  // For MVP, we'll use a placeholder that demonstrates the UI
  String _computeBlake2b(String input) {
    // In production, use pointycastle's Blake2b implementation
    final bytes = input.codeUnits;
    var hash = 0x8B7C9D2E; // Placeholder seed

    for (var i = 0; i < bytes.length; i++) {
      hash = hash ^ (bytes[i] << (i % 32));
      hash = ((hash << 5) | (hash >> 27)) & 0xFFFFFFFF;
    }

    return hash.toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  void _computeHash() {
    setState(() => _result = '');

    try {
      final input = _controller.text;
      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to hash');
        return;
      }

      final buffer = StringBuffer();
      buffer.writeln('BLAKE2${_useBlake2b ? "b" : "s"} HASH\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln(
          'Input: "${input.length > 50 ? '${input.substring(0, 50)}...' : input}"\n');
      buffer.writeln('Digest Size: $_digestSize bytes\n');
      buffer.writeln('Hash (placeholder):\n');

      // Generate multiple hash representations
      final baseHash = _computeBlake2b(input);
      buffer.writeln('HEX: $baseHash...');
      buffer.writeln(
          '\nNote: Full BLAKE2 implementation requires pointycastle package');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BLAKE2 HASH',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'ALGORITHM'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('BLAKE2b'),
                  selected: _useBlake2b,
                  onSelected: (_) => setState(() => _useBlake2b = true),
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color: _useBlake2b
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: _useBlake2b ? AppColors.accent : AppColors.border,
                  ),
                ),
                ChoiceChip(
                  label: const Text('BLAKE2s'),
                  selected: !_useBlake2b,
                  onSelected: (_) => setState(() => _useBlake2b = false),
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color: !_useBlake2b
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: !_useBlake2b ? AppColors.accent : AppColors.border,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'DIGEST SIZE'),
            const SizedBox(height: 8),
            Slider(
              value: _digestSize.toDouble(),
              min: 16,
              max: 64,
              divisions: 6,
              label: '$_digestSize bytes',
              activeColor: AppColors.accent,
              onChanged: (value) => setState(() => _digestSize = value.toInt()),
            ),
            Center(
              child: Text(
                '$_digestSize bytes (${_digestSize * 8} bits)',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter text to hash...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              maxLines: 3,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'COMPUTE HASH',
              icon: Icons.calculate,
              onPressed: _computeHash,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'HASH RESULT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
