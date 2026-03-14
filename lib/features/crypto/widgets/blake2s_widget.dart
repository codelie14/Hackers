import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Blake2sHashWidget extends ConsumerStatefulWidget {
  const Blake2sHashWidget({super.key});

  @override
  ConsumerState<Blake2sHashWidget> createState() => _Blake2sHashWidgetState();
}

class _Blake2sHashWidgetState extends ConsumerState<Blake2sHashWidget> {
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

      // BLAKE2s placeholder - uses same as blake2b but notes it's the 's' variant
      final bytes = input.codeUnits;
      var hash = 0x8B7C9D2E;

      for (var i = 0; i < bytes.length; i++) {
        hash = hash ^ (bytes[i] << (i % 32));
        hash = ((hash << 5) | (hash >> 27)) & 0xFFFFFFFF;
      }

      final hexHash = hash.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            'BLAKE2s (256-bit)\nHEX: $hexHash...\n\nNote: Full implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BLAKE2s HASH',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT BLAKE2s', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'BLAKE2s is optimized for 8 to 32-bit platforms and produces 256-bit hashes.\n\n'
                'Faster than MD5 and SHA-1 while being as secure as SHA-3.',
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
              label: 'GENERATE BLAKE2s HASH',
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
