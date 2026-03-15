import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class AtbashCipherWidget extends ConsumerStatefulWidget {
  const AtbashCipherWidget({super.key});

  @override
  ConsumerState<AtbashCipherWidget> createState() => _AtbashCipherWidgetState();
}

class _AtbashCipherWidgetState extends ConsumerState<AtbashCipherWidget> {
  final _inputController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _atbash(String input) {
    try {
      final buffer = StringBuffer();

      for (var i = 0; i < input.length; i++) {
        final char = input[i];
        final code = input.codeUnitAt(i);

        // Check if uppercase letter (A-Z: 65-90)
        if (code >= 65 && code <= 90) {
          // A ↔ Z, B ↔ Y, C ↔ X, etc.
          final mirrored = 90 - (code - 65);
          buffer.writeCharCode(mirrored);
        }
        // Check if lowercase letter (a-z: 97-122)
        else if (code >= 97 && code <= 122) {
          // a ↔ z, b ↔ y, c ↔ x, etc.
          final mirrored = 122 - (code - 97);
          buffer.writeCharCode(mirrored);
        }
        // Keep numbers and special characters unchanged
        else {
          buffer.write(char);
        }
      }

      return buffer.toString();
    } catch (e) {
      throw Exception('Encryption failed: ${e.toString()}');
    }
  }

  void _transform() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter text to transform');
      return;
    }

    try {
      final output = _atbash(input);

      final buffer = StringBuffer();
      buffer.writeln('ATBASH CIPHER');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      buffer.writeln('INPUT (Original Text)');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('$input\n\n');

      buffer.writeln('OUTPUT (Atbash Encoded)');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('$output\n\n');

      buffer.writeln('HOW IT WORKS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('The Atbash cipher is a simple substitution cipher\n');
      buffer.writeln('where each letter is replaced by its opposite\n');
      buffer.writeln('letter in the alphabet:\n\n');
      buffer.writeln('A ↔ Z, B ↔ Y, C ↔ X, D ↔ W, E ↔ V, F ↔ U,\n');
      buffer.writeln('G ↔ T, H ↔ S, I ↔ R, J ↔ Q, K ↔ P,\n');
      buffer.writeln('L ↔ O, M ↔ N\n\n');

      buffer.writeln('EXAMPLES');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('HELLO → SVOOL\n');
      buffer.writeln('WORLD → DLIOW\n');
      buffer.writeln('SECRET → HVXIVG\n\n');

      buffer.writeln('HISTORY');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('• Originated in the Middle East (~600 BC)\n');
      buffer.writeln('• Used in Hebrew Bible (Book of Jeremiah)\n');
      buffer.writeln('• One of the oldest known ciphers\n');
      buffer.writeln('• Name comes from Hebrew letters:\n');
      buffer.writeln('  Aleph ↔ Tav, Beth ↔ Shin\n\n');

      buffer.writeln('PROPERTIES');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('✓ Symmetric (encryption = decryption)\n');
      buffer.writeln('✓ No key required\n');
      buffer.writeln('✗ Very weak security (no key space)\n');
      buffer.writeln('✗ Easily recognizable pattern\n');
      buffer.writeln('✗ Preserves letter frequency\n\n');

      buffer.writeln('USAGE');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('• Educational purposes\n');
      buffer.writeln('• Cryptography demonstrations\n');
      buffer.writeln('• Historical cipher studies\n');
      buffer.writeln('• Puzzle games and riddles\n');
      buffer.writeln('• Not suitable for real security!\n');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ATBASH CIPHER',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'TEXT INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _inputController,
              hintText: 'Enter text to encode/decode...',
              maxLines: 5,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _transform,
                icon: const Icon(Icons.lock_outline),
                label: const Text('ENCODE / DECODE'),
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
                label: 'TRANSFORMATION RESULT',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
