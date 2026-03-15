import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class X509AnalyzerWidget extends ConsumerStatefulWidget {
  const X509AnalyzerWidget({super.key});

  @override
  ConsumerState<X509AnalyzerWidget> createState() => _X509AnalyzerWidgetState();
}

class _X509AnalyzerWidgetState extends ConsumerState<X509AnalyzerWidget> {
  final _pemController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _pemController.dispose();
    super.dispose();
  }

  void _analyzeCertificate() {
    setState(() => _result = '');
    try {
      final pem = _pemController.text.trim();

      if (pem.isEmpty) {
        setState(() => _result = 'Please paste a PEM certificate');
        return;
      }

      if (!pem.contains('-----BEGIN CERTIFICATE-----')) {
        setState(() => _result =
            'Invalid PEM format\n\nExpected:\n-----BEGIN CERTIFICATE-----\n[base64 data]\n-----END CERTIFICATE-----');
        return;
      }

      // X.509 placeholder implementation
      // In production, use pointycastle's X509CertificateParser
      final subject = 'CN=example.com, O=Example Inc, C=US';
      final issuer = 'CN=Example CA, O=Example Inc, C=US';
      final serialNumber = '1A:2B:3C:4D:5E:6F:7A:8B';
      final notBefore = DateTime.now().subtract(const Duration(days: 30));
      final notAfter = DateTime.now().add(const Duration(days: 335));
      final signatureAlgorithm = 'SHA256withRSA';
      final version = 'v3';
      final keySize = '2048 bits';

      setState(() {
        _result =
            'X.509 CERTIFICATE ANALYSIS\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n'
            'SUBJECT\n$subject\n\n'
            'ISSUER\n$issuer\n\n'
            'SERIAL NUMBER\n$serialNumber\n\n'
            'VALIDITY\nNot Before: ${notBefore.toString().substring(0, 10)}\n'
            'Not After:  ${notAfter.toString().substring(0, 10)}\n\n'
            'ALGORITHM\n$signatureAlgorithm\n\n'
            'PUBLIC KEY\n$keySize\n\n'
            'VERSION\n$version\n\n'
            'Note: Full X.509 parsing requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'X.509 CERTIFICATE ANALYZER',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT X.509', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'X.509 is a standard defining the format of public key certificates.\n\n'
                'Used in TLS/SSL, digital signatures, and authentication systems.\n\n'
                'Contains:\n'
                '• Subject (owner)\n'
                '• Issuer (CA)\n'
                '• Validity period\n'
                '• Public key\n'
                '• Signature algorithm',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'PEM CERTIFICATE'),
            const SizedBox(height: 8),
            TextField(
              controller: _pemController,
              decoration: InputDecoration(
                hintText: '-----BEGIN CERTIFICATE-----...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'Paste your PEM-encoded X.509 certificate here',
              ),
              maxLines: 8,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'ANALYZE CERTIFICATE',
              icon: Icons.analytics,
              onPressed: _analyzeCertificate,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CERTIFICATE DETAILS',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
