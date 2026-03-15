import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Adler32ChecksumWidget extends ConsumerStatefulWidget {
  const Adler32ChecksumWidget({super.key});

  @override
  ConsumerState<Adler32ChecksumWidget> createState() =>
      _Adler32ChecksumWidgetState();
}

class _Adler32ChecksumWidgetState extends ConsumerState<Adler32ChecksumWidget> {
  final _controller = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _computeChecksum() {
    setState(() => _result = '');
    try {
      final input = _controller.text.trim();
      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to compute checksum');
        return;
      }

      // Adler-32 implementation
      // In production, use pointycastle's Adler32
      var a = 1;
      var b = 0;
      final bytes = input.codeUnits;

      for (var byte in bytes) {
        a = (a + byte) % 65521;
        b = (b + a) % 65521;
      }

      final checksum = ((b << 16) | a) & 0xFFFFFFFF;
      final hexChecksum =
          checksum.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            'ADLER-32 CHECKSUM\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\nHEX: 0x$hexChecksum\nDEC: $checksum\n\nFast checksum algorithm used in zlib compression library';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ADLER-32 CHECKSUM',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT ADLER-32', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Adler-32 is a checksum algorithm developed by Mark Adler.\n\n'
                'Faster than CRC-32 but less reliable for error detection.\n\n'
                'Used in the zlib compression library and various file formats.\n\n'
                'Produces a 32-bit value rendered as 8 hexadecimal characters.',
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
                hintText: 'Enter text to compute Adler-32 checksum...',
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
              label: 'COMPUTE ADLER-32',
              icon: Icons.calculate,
              onPressed: _computeChecksum,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CHECKSUM RESULT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
