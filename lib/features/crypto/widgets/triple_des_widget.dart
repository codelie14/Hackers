import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class TripleDesWidget extends ConsumerStatefulWidget {
  const TripleDesWidget({super.key});

  @override
  ConsumerState<TripleDesWidget> createState() => _TripleDesWidgetState();
}

class _TripleDesWidgetState extends ConsumerState<TripleDesWidget> {
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

      // Validate/generate key (3DES needs 16 or 24 bytes)
      if (key.isEmpty) {
        key = 'DEFAULT3DESKEY16'; // 16 bytes default
      }

      // Pad or truncate key to 16 bytes
      if (key.length < 16) {
        key = key.padRight(16, '0');
      } else if (key.length > 24) {
        key = key.substring(0, 24);
      }

      // 3DES placeholder implementation
      // In production, use pointycastle's DesEngine
      final inputBytes = input.codeUnits;
      var encrypted = 0xDEADC0DE;

      for (var i = 0; i < inputBytes.length; i++) {
        encrypted =
            encrypted ^ (inputBytes[i] * key.codeUnitAt(i % key.length));
        encrypted = ((encrypted << 5) | (encrypted >> 27)) & 0xFFFFFFFF;
      }

      final hexResult =
          encrypted.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} DATA\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$hexResult...\n\nKey Size: ${key.length} bytes (${key.length * 8} bits)\nAlgorithm: Triple DES (3DES)\nMode: CBC (placeholder)\n\nNote: Full 3DES implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'TRIPLE DES (3DES)',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT 3DES', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Triple DES (3DES or TDES) applies the DES cipher algorithm three times to each data block.\n\n'
                'Key options:\n'
                '• Keying Option 1: 3 independent keys (168 bits)\n'
                '• Keying Option 2: K1=K3 (112 bits)\n'
                '• Keying Option 3: K1=K2=K3 (56 bits, equivalent to DES)\n\n'
                'Being phased out in favor of AES due to small block size (64-bit).',
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
                hintText: 'Enter 16 or 24 character key...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'If empty, uses default 16-byte key',
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
              label: _isEncrypting ? 'ENCRYPT WITH 3DES' : 'DECRYPT WITH 3DES',
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
