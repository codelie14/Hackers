import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class CsrGeneratorWidget extends ConsumerStatefulWidget {
  const CsrGeneratorWidget({super.key});

  @override
  ConsumerState<CsrGeneratorWidget> createState() => _CsrGeneratorWidgetState();
}

class _CsrGeneratorWidgetState extends ConsumerState<CsrGeneratorWidget> {
  final _commonNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _countryController = TextEditingController();
  String _keySize = '2048';
  String _result = '';

  @override
  void dispose() {
    _commonNameController.dispose();
    _organizationController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _generateCsr() {
    setState(() => _result = '');
    try {
      final cn = _commonNameController.text.trim();
      final org = _organizationController.text.trim();
      final country = _countryController.text.trim().toUpperCase();

      if (cn.isEmpty) {
        setState(() => _result = 'Please enter Common Name (domain name)');
        return;
      }

      // CSR placeholder implementation
      // In production, use pointycastle's PKCS10CertificationRequest
      final randomSeed = DateTime.now().millisecondsSinceEpoch;

      final csrPem = '''-----BEGIN CERTIFICATE REQUEST-----
MIIC${randomSeed.toRadixString(16).toUpperCase()}...[base64 encoded CSR data]
...[simulated CSR content based on subject information]
...[includes public key and signature]
-----END CERTIFICATE REQUEST-----''';

      setState(() {
        _result =
            'CERTIFICATE SIGNING REQUEST\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'
            'SUBJECT DN\n'
            'Common Name (CN): $cn\n'
            'Organization (O): ${org.isEmpty ? '(not specified)' : org}\n'
            'Country (C): ${country.isEmpty ? '(not specified)' : country}\n\n'
            'KEY PARAMETERS\n'
            'Algorithm: RSA\n'
            'Key Size: $_keySize bits\n\n'
            'CSR (PEM FORMAT)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$csrPem\n\n'
            'Note: Full CSR generation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CSR GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT CSR', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'A Certificate Signing Request (CSR) is a message sent to a CA to apply for a digital certificate.\n\n'
                'Contains:\n'
                '• Subject Distinguished Name (DN)\n'
                '• Public key\n'
                '• Signature (with private key)\n\n'
                'Used for SSL/TLS certificates, code signing, and client authentication.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'SUBJECT INFORMATION'),
            const SizedBox(height: 8),
            TextField(
              controller: _commonNameController,
              decoration: InputDecoration(
                labelText: 'Common Name (CN)*',
                hintText: 'example.com',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Your domain name or server FQDN',
              ),
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _organizationController,
              decoration: InputDecoration(
                labelText: 'Organization (O)',
                hintText: 'Example Inc.',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country (C)',
                hintText: 'US',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Two-letter ISO country code',
              ),
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'KEY SIZE'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _keySize,
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
                    value: '2048', child: Text('2048 bits (recommended)')),
                DropdownMenuItem(
                    value: '3072', child: Text('3072 bits (high security)')),
                DropdownMenuItem(
                    value: '4096', child: Text('4096 bits (maximum)')),
              ],
              onChanged: (value) => setState(() => _keySize = value!),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE CSR',
              icon: Icons.description,
              onPressed: _generateCsr,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CSR OUTPUT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
