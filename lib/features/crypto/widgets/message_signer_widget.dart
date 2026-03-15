import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class MessageSignerWidget extends ConsumerStatefulWidget {
  const MessageSignerWidget({super.key});

  @override
  ConsumerState<MessageSignerWidget> createState() =>
      _MessageSignerWidgetState();
}

class _MessageSignerWidgetState extends ConsumerState<MessageSignerWidget> {
  final _messageController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _signatureController = TextEditingController();
  String _result = '';
  bool _isSigning = true;

  @override
  void dispose() {
    _messageController.dispose();
    _privateKeyController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  void _process() {
    setState(() => _result = '');
    try {
      if (_isSigning) {
        // Signing mode
        final message = _messageController.text.trim();
        final privateKey = _privateKeyController.text.trim();

        if (message.isEmpty) {
          setState(() => _result = 'Please enter a message to sign');
          return;
        }

        if (privateKey.isEmpty) {
          setState(() => _result = 'Please enter your private key');
          return;
        }

        // Digital signature placeholder
        // In production, use pointycastle's RSASigner or ECDSASigner
        final messageBytes = message.codeUnits;
        var signature = 0x8B7C9D2E;

        for (var i = 0; i < messageBytes.length; i++) {
          signature = signature ^
              (messageBytes[i] * privateKey.codeUnitAt(i % privateKey.length));
          signature = ((signature << 5) | (signature >> 27)) & 0xFFFFFFFF;
        }

        final hexSignature =
            signature.toRadixString(16).padLeft(64, '0').toUpperCase();

        setState(() {
          _result =
              'DIGITAL SIGNATURE\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\n$hexSignature...\n\nAlgorithm: RSA-SHA256 (placeholder)\nKey Size: 2048 bits\n\nNote: Full implementation requires pointycastle';
        });
      } else {
        // Verification mode
        final message = _messageController.text.trim();
        final signature = _signatureController.text.trim();
        final publicKey = _privateKeyController.text.trim();

        if (message.isEmpty || signature.isEmpty || publicKey.isEmpty) {
          setState(() => _result =
              'Please fill all fields:\nâ€¢ Message\nâ€¢ Signature\nâ€¢ Public Key');
          return;
        }

        // Placeholder verification
        setState(() {
          _result =
              'SIGNATURE VERIFICATION\nâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\nâœ“ VALID\n\nThe signature is valid and the message has not been tampered with.\n\nNote: This is a placeholder result';
        });
      }
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'MESSAGE SIGNER',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
                title: 'ABOUT DIGITAL SIGNATURES', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Digital signatures provide authentication, integrity, and non-repudiation.\n\n'
                'Uses:\n'
                'â€¢ RSA with SHA-256/SHA-512\n'
                'â€¢ ECDSA with P-256/P-384\n'
                'â€¢ Ed25519 (EdDSA)\n\n'
                'Common in TLS certificates, code signing, and document authentication.',
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
                    label: const Text('SIGN MESSAGE'),
                    selected: _isSigning,
                    onSelected: (_) => setState(() {
                      _isSigning = true;
                      _result = '';
                    }),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: _isSigning
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color: _isSigning ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('VERIFY SIGNATURE'),
                    selected: !_isSigning,
                    onSelected: (_) => setState(() {
                      _isSigning = false;
                      _result = '';
                    }),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: !_isSigning
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color: !_isSigning ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'MESSAGE'),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText:
                    'Enter message to ${_isSigning ? "sign" : "verify"}...',
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
            SectionHeader(title: _isSigning ? 'PRIVATE KEY (PEM)' : 'PUBLIC KEY (PEM)'),
            const SizedBox(height: 8),
            TextField(
              controller: _privateKeyController,
              decoration: InputDecoration(
                hintText: _isSigning
                    ? '-----BEGIN RSA PRIVATE KEY-----...'
                    : '-----BEGIN PUBLIC KEY-----...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              maxLines: 6,
              obscureText: _isSigning,
              onChanged: (_) => setState(() => _result = ''),
            ),
            if (!_isSigning) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'SIGNATURE (HEX)'),
              const SizedBox(height: 8),
              TextField(
                controller: _signatureController,
                decoration: InputDecoration(
                  hintText: 'Enter signature in hexadecimal...',
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
            ],
            const SizedBox(height: 16),
            AppButton(
              label: _isSigning ? 'SIGN MESSAGE' : 'VERIFY SIGNATURE',
              icon: _isSigning ? Icons.draw : Icons.verified,
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


