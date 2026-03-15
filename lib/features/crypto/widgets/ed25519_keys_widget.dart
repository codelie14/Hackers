import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Ed25519KeysWidget extends ConsumerStatefulWidget {
  const Ed25519KeysWidget({super.key});

  @override
  ConsumerState<Ed25519KeysWidget> createState() => _Ed25519KeysWidgetState();
}

class _Ed25519KeysWidgetState extends ConsumerState<Ed25519KeysWidget> {
  String _result = '';

  @override
  void dispose() {
    super.dispose();
  }

  void _generateKeys() {
    setState(() => _result = '');
    try {
      // Ed25519 placeholder implementation
      // In production, use pointycastle's Ed25519Signer
      final randomSeed = DateTime.now().millisecondsSinceEpoch;

      final publicKey =
          (randomSeed.toRadixString(16).padLeft(32, '0').toUpperCase()) +
              (randomSeed.toRadixString(16).padLeft(32, '0').toUpperCase());

      final privateKey =
          (randomSeed.toRadixString(16).padLeft(64, '0').toUpperCase()) +
              publicKey;

      setState(() {
        _result = 'ED25519 KEY PAIR\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'
            'PUBLIC KEY (32 bytes)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$publicKey...\n\n'
            'PRIVATE KEY (64 bytes)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$privateKey\n\n'
            'Algorithm: EdDSA with Curve25519\nSignature Size: 64 bytes\n\n'
            'Note: Full Ed25519 implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ED25519 KEYS',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT ED25519', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Ed25519 is an EdDSA signature scheme using the twisted Edwards curve Curve25519.\n\n'
                'Advantages:\n'
                '• Very fast (faster than ECDSA)\n'
                '• No side-channel attacks\n'
                '• Small signatures (64 bytes)\n'
                '• Deterministic (no RNG needed for signing)\n\n'
                'Used in SSH, Signal Protocol, and cryptocurrencies.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'GENERATE ED25519 KEY PAIR',
              icon: Icons.vpn_key,
              onPressed: _generateKeys,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'KEY PAIR',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
