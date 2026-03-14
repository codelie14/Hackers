import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class CaesarCipherWidget extends ConsumerStatefulWidget {
  const CaesarCipherWidget({super.key});

  @override
  ConsumerState<CaesarCipherWidget> createState() => _CaesarCipherWidgetState();
}

class _CaesarCipherWidgetState extends ConsumerState<CaesarCipherWidget> {
  final _inputController = TextEditingController();
  int _shift = 3;
  String _result = '';
  bool _isEncrypting = true;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _caesarCipher(String text, int shift, {bool encrypt = true}) {
    if (!encrypt) shift = -shift;

    return String.fromCharCodes(text.codeUnits.map((code) {
      // Handle uppercase letters (A-Z: 65-90)
      if (code >= 65 && code <= 90) {
        return ((code - 65 + shift) % 26 + 26) % 26 + 65;
      }
      // Handle lowercase letters (a-z: 97-122)
      else if (code >= 97 && code <= 122) {
        return ((code - 97 + shift) % 26 + 26) % 26 + 97;
      }
      // Keep non-alphabetic characters unchanged
      return code;
    }));
  }

  void _process() {
    setState(() => _result = '');
    try {
      final input = _inputController.text.trim();
      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to process');
        return;
      }

      final output = _caesarCipher(input, _shift, encrypt: _isEncrypting);

      setState(() {
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} TEXT\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$output\n\nShift: $_shift positions';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CAESAR CIPHER',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
                title: 'ABOUT CAESAR CIPHER', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'The Caesar cipher is one of the simplest and most widely known encryption techniques.\n\n'
                'Each letter in the plaintext is shifted a certain number of places down the alphabet.\n\n'
                'Named after Julius Caesar, who used it for confidential communication.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'MODE'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('ENCRYPT'),
                    selected: _isEncrypting,
                    onSelected: (_) => setState(() {
                      _isEncrypting = true;
                      _result = '';
                    }),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: _isEncrypting
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color:
                          _isEncrypting ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('DECRYPT'),
                    selected: !_isEncrypting,
                    onSelected: (_) => setState(() {
                      _isEncrypting = false;
                      _result = '';
                    }),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: !_isEncrypting
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color:
                          !_isEncrypting ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'SHIFT VALUE'),
            const SizedBox(height: 8),
            Slider(
              value: _shift.toDouble(),
              min: 1,
              max: 25,
              divisions: 24,
              label: 'Shift: $_shift',
              activeColor: AppColors.accent,
              onChanged: (value) => setState(() {
                _shift = value.toInt();
                _result = '';
              }),
            ),
            Center(
              child: Text(
                'Shift each letter by $_shift position${_shift > 1 ? 's' : ''} in the alphabet',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT TEXT'),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText:
                    'Enter text to ${_isEncrypting ? "encrypt" : "decrypt"}...',
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
              label: _isEncrypting ? 'ENCRYPT TEXT' : 'DECRYPT TEXT',
              icon: _isEncrypting ? Icons.lock : Icons.lock_open,
              onPressed: _process,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'OUTPUT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
