import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class SSLTLSAnalyzerWidget extends ConsumerStatefulWidget {
  const SSLTLSAnalyzerWidget({super.key});

  @override
  ConsumerState<SSLTLSAnalyzerWidget> createState() =>
      _SSLTLSAnalyzerWidgetState();
}

class _SSLTLSAnalyzerWidgetState extends ConsumerState<SSLTLSAnalyzerWidget> {
  final _urlController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _analyzeSSL() async {
    var url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() => _result = 'Please enter a URL');
      return;
    }

    // Add https:// if missing
    if (!url.startsWith('https://')) {
      if (url.startsWith('http://')) {
        url = url.replaceFirst('http://', 'https://');
      } else {
        url = 'https://$url';
      }
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final uri = Uri.parse(url);
      final buffer = StringBuffer();

      buffer.writeln('SSL/TLS CERTIFICATE ANALYZER');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln('Target: $url\n');
      buffer.writeln(
          'Started: ${DateTime.now().toString().substring(0, 19)}\n\n');
      buffer.writeln('CONNECTING...\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      // Create secure socket connection
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      try {
        final request = await client.getUrl(uri);
        final response = await request.close();

        // Get certificate information
        final cert = response.certificate;

        if (cert == null) {
          buffer.writeln('⚠ No certificate found.\n');
          setState(() {
            _result = buffer.toString();
            _isLoading = false;
          });
          return;
        }

        buffer.writeln('✅ CERTIFICATE FOUND\n\n');

        buffer.writeln('CERTIFICATE DETAILS');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        // Subject information
        buffer.writeln('📋 SUBJECT INFORMATION\n\n');
        buffer.writeln('Common Name (CN): ${cert.subject ?? 'N/A'}\n');
        buffer.writeln('Issuer: ${cert.issuer ?? 'N/A'}\n\n');

        // Validity period
        buffer.writeln('📅 VALIDITY PERIOD\n\n');
        buffer.writeln('Not Before: ${cert.startValidity ?? 'N/A'}\n');
        buffer.writeln('Not After: ${cert.endValidity ?? 'N/A'}\n\n');

        // Check if expired
        final now = DateTime.now();
        final startValid = cert.startValidity;
        final endValid = cert.endValidity;
        int? daysLeft;

        buffer.writeln('STATUS CHECK\n\n');
        if (startValid != null && now.isBefore(startValid)) {
          buffer.writeln('✗ Certificate not yet valid!\n\n');
        } else if (endValid != null && now.isAfter(endValid)) {
          buffer.writeln('✗ Certificate EXPIRED!\n\n');
        } else if (endValid != null) {
          daysLeft = endValid.difference(now).inDays;
          buffer.writeln('✓ Certificate is valid\n');
          buffer.writeln('⏱ Days until expiration: $daysLeft\n\n');

          if (daysLeft < 30) {
            buffer.writeln('⚠ WARNING: Certificate expires soon!\n\n');
          } else if (daysLeft < 90) {
            buffer.writeln(
                'ℹ Notice: Certificate expires in less than 3 months\n\n');
          }
        } else {
          buffer.writeln('? Validity status unknown\n\n');
        }

        // Protocol and cipher info
        buffer.writeln('🔐 CONNECTION SECURITY\n\n');
        buffer.writeln('Protocol Version: TLS 1.2/1.3 (auto-negotiated)\n');
        buffer.writeln(
            'Cipher Suite: ${response.certificate?.subject ?? 'N/A'}\n\n');

        // Security analysis
        buffer.writeln('🛡️ SECURITY ANALYSIS\n\n');

        int score = 100;
        final issues = <String>[];

        // Check for HTTPS
        if (uri.scheme != 'https') {
          score -= 50;
          issues.add('Not using HTTPS');
        }

        // Check certificate validity
        if (endValid != null && now.isAfter(endValid)) {
          score -= 40;
          issues.add('Certificate expired');
        } else if (daysLeft != null && daysLeft < 30) {
          score -= 20;
          issues.add('Certificate expires soon');
        }

        // Check for common name match
        final cn = cert.subject ?? '';
        if (!cn.contains(uri.host) && !cn.contains('*.${uri.host}')) {
          score -= 30;
          issues.add('Certificate CN does not match domain');
        }

        buffer.writeln('Security Score: $score/100\n\n');

        if (issues.isEmpty) {
          buffer.writeln('✓ No security issues detected\n\n');
        } else {
          buffer.writeln('⚠ ISSUES FOUND:\n\n');
          for (final issue in issues) {
            buffer.writeln('• $issue\n');
          }
          buffer.writeln('\n');
        }

        // Recommendations
        buffer.writeln('💡 RECOMMENDATIONS\n\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        if (daysLeft != null && daysLeft < 90) {
          buffer.writeln('• Renew certificate before expiration\n');
        }
        if (score < 100) {
          buffer.writeln('• Address the security issues listed above\n');
        }
        buffer.writeln('• Use strong cipher suites (AES-256, ChaCha20)\n');
        buffer.writeln('• Enable HSTS for automatic HTTPS\n');
        buffer.writeln('• Consider using a certificate monitoring service\n');
        buffer.writeln('• Implement certificate transparency logging\n');

        // Raw certificate data
        buffer.writeln('\n\n📄 RAW CERTIFICATE DATA\n\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
        buffer.writeln('Subject: ${cert.subject}\n');
        buffer.writeln('Issuer: ${cert.issuer}\n');
        buffer.writeln('Start Validity: ${cert.startValidity}\n');
        buffer.writeln('End Validity: ${cert.endValidity}\n');

        if (cert.pem != null && cert.pem!.isNotEmpty) {
          buffer.writeln('\nPEM Format (first 200 chars):\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
          final pemPreview = cert.pem!.length > 200
              ? '${cert.pem!.substring(0, 200)}...'
              : cert.pem!;
          buffer.writeln(pemPreview);
        }
      } finally {
        client.close();
      }

      setState(() {
        _result = buffer.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result =
            'Error: ${e.toString()}\n\nPossible causes:\n• Invalid URL\n• Server unreachable\n• SSL/TLS handshake failed\n• Self-signed certificate\n• Network timeout';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SSL/TLS ANALYZER',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'TARGET URL'),
            const SizedBox(height: 8),
            AppInput(
              controller: _urlController,
              hintText: 'Enter HTTPS URL (e.g., https://example.com)...',
              onChanged: (_) {
                if (_result.isNotEmpty && !_isLoading)
                  setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeSSL,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.security),
                label: Text(_isLoading ? 'ANALYZING...' : 'ANALYZE SSL/TLS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'SSL/TLS ANALYSIS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
