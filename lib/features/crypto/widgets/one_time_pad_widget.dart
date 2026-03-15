import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class OneTimePadWidget extends ConsumerStatefulWidget {
  const OneTimePadWidget({super.key});

  @override
  ConsumerState<OneTimePadWidget> createState() => _OneTimePadWidgetState();
}

class _OneTimePadWidgetState extends ConsumerState<OneTimePadWidget> {
  final _inputController = TextEditingController();
  String _otp = '';
  String _result = '';
  bool _isEncrypting = true;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _generateOTP(int length) {
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => random.nextInt(26) + 65), // A-Z
    );
  }

  String _applyOTP(String text, String otp, {bool encrypt = true}) {
    if (text.length != otp.length)
      return 'Error: Text and OTP must be same length';

    return String.fromCharCodes(text.codeUnits.asMap().entries.map((entry) {
      final index = entry.key;
      final code = entry.value;

      // Only process uppercase letters
      if (code >= 65 && code <= 90) {
        final otpShift = otp.codeUnitAt(index) - 65;
        if (encrypt) {
          return ((code - 65 + otpShift) % 26) + 65;
        } else {
          return ((code - 65 - otpShift + 26) % 26) + 65;
        }
      }
      return code;
    }));
  }

  void _process() {
    setState(() {
      _result = '';
      _otp = '';
    });

    try {
      var input = _inputController.text.trim().toUpperCase();

      if (input.isEmpty) {
        setState(() => _result = 'Please enter text to process');
        return;
      }

      // Remove non-letters for OTP
      input = input.replaceAll(RegExp(r'[^A-Z]'), '');

      if (input.isEmpty) {
        setState(() => _result = 'Please enter at least one letter (A-Z)');
        return;
      }

      // Generate or use existing OTP
      final otp = _generateOTP(input.length);

      // Apply OTP
      final output = _applyOTP(input, otp, encrypt: _isEncrypting);

      setState(() {
        _otp = otp;
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} MESSAGE\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$output\n\nONE-TIME PAD\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$otp\n\n⚠️ SECURITY NOTE:\nOTP must be truly random, kept secret,\nand never reused for perfect secrecy.';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ONE-TIME PAD',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT ONE-TIME PAD', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'The one-time pad (OTP) is the only mathematically unbreakable encryption method when used correctly.\n\n'
                'Requirements for perfect secrecy:\n'
                '• Key must be truly random\n'
                '• Key must be as long as the message\n'
                '• Key must never be reused\n'
                '• Key must be kept completely secret',
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
                      _otp = '';
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
                      _otp = '';
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
            const SectionHeader(title: 'INPUT TEXT'),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: _isEncrypting
                    ? 'Enter message to encrypt...'
                    : 'Enter encrypted message...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Letters will be converted to uppercase',
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() {
                _result = '';
                _otp = '';
              }),
            ),
            const SizedBox(height: 16),
            AppButton(
              label:
                  _isEncrypting ? 'GENERATE OTP & ENCRYPT' : 'DECRYPT WITH OTP',
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
