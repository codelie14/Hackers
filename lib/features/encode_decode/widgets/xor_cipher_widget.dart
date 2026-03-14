import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class XorCipherWidget extends ConsumerStatefulWidget {
  const XorCipherWidget({super.key});

  @override
  ConsumerState<XorCipherWidget> createState() => _XorCipherWidgetState();
}

class _XorCipherWidgetState extends ConsumerState<XorCipherWidget> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';
  String _error = '';

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  String _xor(String input, String key) {
    if (key.isEmpty) throw Exception('Key cannot be empty');

    final inputBytes = input.codeUnits;
    final keyBytes = key.codeUnits;
    final result = <int>[];

    for (var i = 0; i < inputBytes.length; i++) {
      result.add(inputBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return String.fromCharCodes(result);
  }

  String _toHex(String input) {
    return input.codeUnits
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join(' ');
  }

  String _fromHex(String hex) {
    final bytes = hex.split(' ').where((s) => s.isNotEmpty);
    return String.fromCharCodes(bytes.map((s) => int.parse(s, radix: 16)));
  }

  void _process() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final input = _inputController.text;
      final key = _keyController.text;

      if (input.isEmpty || key.isEmpty) {
        setState(() => _error = 'Input and key are required');
        return;
      }

      // XOR operation is symmetric - same function for encode/decode
      final result = _xor(input, key);

      // Check if result is printable, otherwise show as hex
      final isPrintable = result.codeUnits.every((b) => b >= 32 && b <= 126);
      setState(() {
        _result = isPrintable ? result : 'Hex: ${_toHex(result)}';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'XOR CIPHER',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: 'Enter text to encrypt/decrypt...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => setState(() {
                _result = '';
                _error = '';
              }),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'ENCRYPTION KEY'),
            const SizedBox(height: 8),
            AppInput(
              controller: _keyController,
              hintText: 'Enter encryption key...',
              onChanged: (_) => setState(() {
                _result = '';
                _error = '';
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'ENCRYPT / DECRYPT',
              icon: Icons.lock_outline,
              onPressed: _process,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(content: _error, isError: true),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'RESULT',
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ℹ️ INFO',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'XOR cipher uses the same operation for both encryption and decryption. Enter encrypted text and the same key to decrypt.',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
