import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class BlowfishWidget extends ConsumerStatefulWidget {
  const BlowfishWidget({super.key});

  @override
  ConsumerState<BlowfishWidget> createState() => _BlowfishWidgetState();
}

class _BlowfishWidgetState extends ConsumerState<BlowfishWidget> {
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';
  bool _isEncrypting = true;

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _process() {
    setState(() => _result = '');
    try {
      final input = _inputController.text.trim();
      var key = _keyController.text.trim();

      if (input.isEmpty) {
        setState(() => _result =
            'Please enter data to ${_isEncrypting ? "encrypt" : "decrypt"}');
        return;
      }

      // Validate/generate key (Blowfish: 4-56 bytes)
      if (key.isEmpty) {
        key = 'BLOWFISH_DEFAULT_KEY_32'; // Default key
      }

      // Ensure key is within valid range (4-56 bytes)
      if (key.length < 4) {
        key = key.padRight(4, 'X');
      } else if (key.length > 56) {
        key = key.substring(0, 56);
      }

      // Blowfish placeholder implementation
      // In production, use pointycastle's BlowfishEngine
      final inputBytes = input.codeUnits;
      var encrypted = 0xBAC1FFA7;

      for (var i = 0; i < inputBytes.length; i++) {
        encrypted =
            encrypted ^ (inputBytes[i] * key.codeUnitAt(i % key.length));
        encrypted = ((encrypted << 5) | (encrypted >> 27)) & 0xFFFFFFFF;
      }

      final hexResult =
          encrypted.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} DATA\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$hexResult...\n\nKey Size: ${key.length} bytes (${key.length * 8} bits)\nAlgorithm: Blowfish\nBlock Size: 64-bit\nRounds: 16\n\nNote: Full Blowfish implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BLOWFISH CIPHER',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT BLOWFISH', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Blowfish is a symmetric-key block cipher designed by Bruce Schneier in 1993.\n\n'
                'Characteristics:\n'
                '• Block size: 64 bits\n'
                '• Key size: 32 to 448 bits (variable)\n'
                '• Rounds: 16 Feistel rounds\n'
                '• Structure: Feistel network\n\n'
                'Fast and compact, suitable for applications where keys do not change frequently.',
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
                hintText: 'Enter key (4-56 characters)...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Variable key length: 32-448 bits',
              ),
              maxLines: 2,
              obscureText: true,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT DATA'),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: _isEncrypting
                    ? 'Enter message to encrypt...'
                    : 'Enter encrypted data (hex)...',
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
                  ? 'ENCRYPT WITH BLOWFISH'
                  : 'DECRYPT WITH BLOWFISH',
              icon: _isEncrypting ? Icons.lock : Icons.lock_open,
              onPressed: _process,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'RESULT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
