import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class VigenereCipherWidget extends ConsumerStatefulWidget {
  const VigenereCipherWidget({super.key});

  @override
  ConsumerState<VigenereCipherWidget> createState() =>
      _VigenereCipherWidgetState();
}

class _VigenereCipherWidgetState extends ConsumerState<VigenereCipherWidget> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController(text: 'KEY');
  String _result = '';
  bool _isEncrypting = true;

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  String _vigenereCipher(String text, String key, {bool encrypt = true}) {
    if (key.isEmpty) return text;

    final keyUpper = key.toUpperCase();
    var keyIndex = 0;

    return String.fromCharCodes(text.codeUnits.map((code) {
      // Only shift alphabetic characters
      if ((code >= 65 && code <= 90) || (code >= 97 && code <= 122)) {
        final isUpper = code >= 65 && code <= 90;
        final base = isUpper ? 65 : 97;

        // Get the shift value from the key
        final keyChar = keyUpper[keyIndex % keyUpper.length];
        final shift = keyChar.codeUnitAt(0) - 65; // A=0, B=1, ..., Z=25

        keyIndex++;

        // Apply shift
        final shifted = encrypt
            ? (code - base + shift) % 26 + base
            : (code - base - shift + 26) % 26 + base;

        return shifted;
      }

      // Non-alphabetic characters remain unchanged and don't consume key
      return code;
    }));
  }

  void _process() {
    setState(() => _result = '');
    try {
      final input = _inputController.text.trim();
      final key = _keyController.text.trim().toUpperCase();

      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to process');
        return;
      }

      if (key.isEmpty) {
        setState(() => _result = 'Please enter a key');
        return;
      }

      final output = _vigenereCipher(input, key, encrypt: _isEncrypting);

      setState(() {
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} TEXT\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$output\n\nKey: $key';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'VIGENÈRE CIPHER',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
                title: 'ABOUT VIGENÈRE CIPHER', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'The Vigenère cipher is a method of encrypting alphabetic text using a polyalphabetic substitution.\n\n'
                'Uses a keyword to determine which Caesar cipher to apply to each letter.\n\n'
                'Considered unbreakable for over 300 years until the Kasiski examination was developed.',
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
            const SectionHeader(title: 'SECRET KEY'),
            const SizedBox(height: 8),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                hintText: 'Enter keyword...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                prefixIcon: const Icon(Icons.vpn_key, color: AppColors.accent),
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() => _result = ''),
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
              label: _isEncrypting
                  ? 'ENCRYPT WITH VIGENÈRE'
                  : 'DECRYPT WITH VIGENÈRE',
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
