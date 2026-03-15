import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class EcdsaKeysWidget extends ConsumerStatefulWidget {
  const EcdsaKeysWidget({super.key});

  @override
  ConsumerState<EcdsaKeysWidget> createState() => _EcdsaKeysWidgetState();
}

class _EcdsaKeysWidgetState extends ConsumerState<EcdsaKeysWidget> {
  String _result = '';
  String _curve = 'P-256';

  @override
  void dispose() {
    super.dispose();
  }

  void _generateKeys() {
    setState(() => _result = '');
    try {
      // ECDSA placeholder implementation
      // In production, use pointycastle's ECDSASigner
      final randomSeed = DateTime.now().millisecondsSinceEpoch;

      final publicKey = '04' +
          (randomSeed.toRadixString(16).padLeft(32, '0').toUpperCase()) +
          (randomSeed.toRadixString(16).padLeft(32, '0').toUpperCase());

      final privateKey =
          randomSeed.toRadixString(16).padLeft(64, '0').toUpperCase();

      setState(() {
        _result =
            'ECDSA KEY PAIR ($_curve)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'
            'PUBLIC KEY (Uncompressed)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$publicKey...\n\n'
            'PRIVATE KEY\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$privateKey\n\n'
            'Curve: $_curve\nFormat: Raw hex (not PEM)\n\n'
            'Note: Full ECDSA implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ECDSA KEYS',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT ECDSA', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'ECDSA (Elliptic Curve Digital Signature Algorithm) is a variant of DSA using elliptic curves.\n\n'
                'Common curves:\n'
                '• P-256 (secp256r1): 256-bit security\n'
                '• P-384 (secp384r1): 384-bit security\n'
                '• P-521 (secp521r1): 521-bit security\n\n'
                'Used in Bitcoin, TLS certificates, and digital signatures.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'CURVE SELECTION'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _curve,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'P-256', child: Text('P-256 (secp256r1) - 256-bit')),
                DropdownMenuItem(
                    value: 'P-384', child: Text('P-384 (secp384r1) - 384-bit')),
                DropdownMenuItem(
                    value: 'P-521', child: Text('P-521 (secp521r1) - 521-bit')),
              ],
              onChanged: (value) => setState(() => _curve = value!),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE ECDSA KEY PAIR',
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
