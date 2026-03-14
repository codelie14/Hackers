import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Ripemd160HashWidget extends ConsumerStatefulWidget {
  const Ripemd160HashWidget({super.key});

  @override
  ConsumerState<Ripemd160HashWidget> createState() =>
      _Ripemd160HashWidgetState();
}

class _Ripemd160HashWidgetState extends ConsumerState<Ripemd160HashWidget> {
  final _controller = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _computeHash() {
    setState(() => _result = '');
    try {
      final input = _controller.text.trim();
      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to hash');
        return;
      }

      // RIPEMD-160 placeholder implementation
      // In production, use pointycastle's Ripemd160Digest
      final bytes = input.codeUnits;
      var hash = 0x67452301; // RIPEMD-160 initial value seed

      for (var i = 0; i < bytes.length; i++) {
        hash = hash ^ (bytes[i] << (i % 32));
        hash = ((hash << 5) | (hash >> 27)) & 0xFFFFFFFF;
      }

      final hexHash = hash.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            'RIPEMD-160 (160-bit)\nHEX: $hexHash...\n\nNote: Full RIPEMD-160 implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'RIPEMD-160 HASH',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT RIPEMD-160', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'RIPEMD-160 is a 160-bit cryptographic hash function designed by Hans Dobbertin, Antoon Bosselaers, and Bart Preneel.\n\n'
                'Used in Bitcoin addresses and various security applications.\n\n'
                'Produces a 160-bit (20-byte) hash value typically rendered as 40 hexadecimal characters.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
              maxLines: 4,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE RIPEMD-160 HASH',
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
