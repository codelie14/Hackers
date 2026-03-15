import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class HttpHeadersAnalyzerWidget extends ConsumerStatefulWidget {
  const HttpHeadersAnalyzerWidget({super.key});

  @override
  ConsumerState<HttpHeadersAnalyzerWidget> createState() =>
      _HttpHeadersAnalyzerWidgetState();
}

class _HttpHeadersAnalyzerWidgetState
    extends ConsumerState<HttpHeadersAnalyzerWidget> {
  final _urlController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _analyzeHeaders() async {
    var url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() => _result = 'Please enter a URL');
      return;
    }

    // Add https:// if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final uri = Uri.parse(url);
      final buffer = StringBuffer();

      buffer.writeln('HTTP HEADERS ANALYZER');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln('Target URL: $url\n');
      buffer.writeln(
          'Started: ${DateTime.now().toString().substring(0, 19)}\n\n');
      buffer.writeln('FETCHING HEADERS...\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      // Create HTTP client
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      try {
        final request = await client.getUrl(uri);
        final response = await request.close();

        // Collect all headers
        final headers = <String, String>{};
        response.headers.forEach((name, values) {
          headers[name] = values.join(', ');
        });

        buffer.writeln('RESPONSE HEADERS');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        if (headers.isEmpty) {
          buffer.writeln('No headers returned.\n');
        } else {
          // Security headers section
          buffer.writeln('🔒 SECURITY HEADERS\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

          final securityHeaders = [
            'strict-transport-security',
            'content-security-policy',
            'x-content-type-options',
            'x-frame-options',
            'x-xss-protection',
            'referrer-policy',
            'permissions-policy',
          ];

          for (final header in securityHeaders) {
            if (headers.containsKey(header)) {
              buffer.writeln('✓ $header\n');
              buffer.writeln('  Value: ${headers[header]}\n\n');
            } else {
              buffer.writeln('✗ $header - MISSING\n\n');
            }
          }

          buffer.writeln('\nGENERAL HEADERS\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

          final generalHeaders = [
            'server',
            'date',
            'content-type',
            'content-length',
            'connection',
            'cache-control',
            'expires',
            'last-modified',
            'etag',
          ];

          for (final header in generalHeaders) {
            if (headers.containsKey(header)) {
              buffer.writeln('$header:\n');
              buffer.writeln('  ${headers[header]}\n\n');
            }
          }

          buffer.writeln('\nALL HEADERS (${headers.length})\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

          final sortedHeaders = headers.keys.toList()..sort();
          for (final header in sortedHeaders) {
            buffer.writeln('$header: ${headers[header]}\n');
          }
        }

        // Status information
        buffer.writeln('\n\nCONNECTION INFO');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
        buffer.writeln('Status Code: ${response.statusCode}\n');
        buffer.writeln('Reason: ${response.reasonPhrase}\n');
        buffer.writeln(
            'Protocol: HTTP/${response.persistentConnection ? '1.1' : '1.0'}\n');
        buffer.writeln('Redirects: ${response.redirects.length}\n');

        if (response.redirects.isNotEmpty) {
          buffer.writeln('\nREDIRECTS\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
          for (final redirect in response.redirects) {
            buffer.writeln('${redirect.statusCode} → ${redirect.location}\n');
          }
        }

        // Security analysis
        buffer.writeln('\n\nSECURITY ANALYSIS');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        int present = 0;
        int missing = 0;

        for (final header in securityHeaders) {
          if (headers.containsKey(header)) {
            present++;
          } else {
            missing++;
          }
        }

        final score = ((present / securityHeaders.length) * 100).toInt();

        buffer.writeln('Security Headers Score: $score/100\n\n');
        buffer.writeln('Present: $present/${securityHeaders.length}\n');
        buffer.writeln('Missing: $missing/${securityHeaders.length}\n\n');

        if (score >= 80) {
          buffer.writeln('✓ Good security headers configuration!\n');
        } else if (score >= 50) {
          buffer.writeln('⚠ Some security headers are missing.\n');
        } else {
          buffer.writeln('✗ Poor security headers. Consider adding more.\n');
        }

        buffer.writeln('\nRECOMMENDATIONS\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        if (!headers.containsKey('strict-transport-security')) {
          buffer.writeln('• Add HSTS header for HTTPS enforcement\n');
        }
        if (!headers.containsKey('content-security-policy')) {
          buffer.writeln('• Add CSP to prevent XSS attacks\n');
        }
        if (!headers.containsKey('x-content-type-options')) {
          buffer.writeln('• Add X-Content-Type-Options: nosniff\n');
        }
        if (!headers.containsKey('x-frame-options')) {
          buffer.writeln('• Add X-Frame-Options to prevent clickjacking\n');
        }
        if (!headers.containsKey('referrer-policy')) {
          buffer.writeln('• Add Referrer-Policy for privacy\n');
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
            'Error: ${e.toString()}\n\nPossible causes:\n• Invalid URL\n• Server unreachable\n• CORS restrictions\n• Network timeout';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HTTP HEADERS',
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
              hintText: 'Enter URL (e.g., https://example.com)...',
              onChanged: (_) {
                if (_result.isNotEmpty && !_isLoading)
                  setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeHeaders,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.http),
                label: Text(_isLoading ? 'ANALYZING...' : 'ANALYZE HEADERS'),
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
                label: 'HEADERS ANALYSIS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
