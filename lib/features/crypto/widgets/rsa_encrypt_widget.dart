import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class RsaEncryptWidget extends ConsumerStatefulWidget {
  const RsaEncryptWidget({super.key});

  @override
  ConsumerState<RsaEncryptWidget> createState() => _RsaEncryptWidgetState();
}

class _RsaEncryptWidgetState extends ConsumerState<RsaEncryptWidget> {
  final _messageController = TextEditingController();
  final _publicKeyController = TextEditingController();
  String _result = '';
  bool _isEncrypting = true;

  @override
  void dispose() {
    _messageController.dispose();
    _publicKeyController.dispose();
    super.dispose();
  }

  void _process() {
    setState(() => _result = '');
    try {
      final message = _messageController.text.trim();
      final publicKey = _publicKeyController.text.trim();

      if (message.isEmpty) {
        setState(() => _result =
            'Please enter a message to ${_isEncrypting ? "encrypt" : "decrypt"}');
        return;
      }

      // RSA placeholder implementation
      // In production, use pointycastle's RSA engine
      final messageBytes = message.codeUnits;
      var encrypted = 0x8B7C9D2E;

      for (var i = 0; i < messageBytes.length; i++) {
        encrypted = encrypted ^ (messageBytes[i] << (i % 32));
        encrypted = ((encrypted << 5) | (encrypted >> 27)) & 0xFFFFFFFF;
      }

      final hexResult =
          encrypted.toRadixString(16).padLeft(8, '0').toUpperCase();

      setState(() {
        _result =
            '${_isEncrypting ? 'ENCRYPTED' : 'DECRYPTED'} MESSAGE\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n$hexResult...\n\nNote: Full RSA implementation requires:\nâ€¢ Valid PEM public/private keys\nâ€¢ pointycastle package\nâ€¢ Proper padding (OAEP/PKCS#1)';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'RSA ENCRYPT / DECRYPT',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT RSA', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'RSA (Rivest-Shamir-Adleman) is an asymmetric encryption algorithm.\n\n'
                'Uses a public key for encryption and a private key for decryption.\n\n'
                'Widely used for secure data transmission and digital signatures.\n\n'
                'Common key sizes: 2048, 3072, 4096 bits.',
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
            SectionHeader(
                title:
                    _isEncrypting ? 'PUBLIC KEY (PEM)' : 'PRIVATE KEY (PEM)'),
            const SizedBox(height: 8),
            TextField(
              controller: _publicKeyController,
              decoration: InputDecoration(
                hintText: _isEncrypting
                    ? '-----BEGIN PUBLIC KEY-----...'
                    : '-----BEGIN RSA PRIVATE KEY-----...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Paste your PEM-formatted key here',
              ),
              maxLines: 6,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'MESSAGE'),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: _isEncrypting
                    ? 'Enter message to encrypt...'
                    : 'Enter encrypted message (hex)...',
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
              label: _isEncrypting ? 'ENCRYPT WITH RSA' : 'DECRYPT WITH RSA',
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
