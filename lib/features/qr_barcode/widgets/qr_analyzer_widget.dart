import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class QrAnalyzerWidget extends ConsumerStatefulWidget {
  const QrAnalyzerWidget({super.key});

  @override
  ConsumerState<QrAnalyzerWidget> createState() => _QrAnalyzerWidgetState();
}

class _QrAnalyzerWidgetState extends ConsumerState<QrAnalyzerWidget> {
  final _controller = TextEditingController();
  String _result = '';
  SafetyLevel _safetyLevel = SafetyLevel.unknown;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyzeContent() {
    setState(() {
      _result = '';
      _safetyLevel = SafetyLevel.unknown;
    });

    try {
      final content = _controller.text.trim();

      if (content.isEmpty) {
        setState(() {
          _result = 'Please enter QR code content to analyze';
          _safetyLevel = SafetyLevel.unknown;
        });
        return;
      }

      final buffer = StringBuffer();
      int riskScore = 0;
      final warnings = <String>[];
      final info = <String>[];

      buffer.writeln('📊 QR CODE CONTENT ANALYSIS\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // Content Type Detection
      buffer.writeln('CONTENT TYPE:');
      if (content.startsWith('http://') || content.startsWith('https://')) {
        buffer.writeln('• Type: URL/Website Link');
        info.add('Contains a web URL');
      } else if (content.startsWith('WIFI:')) {
        buffer.writeln('• Type: WiFi Network Configuration');
        info.add('Contains WiFi credentials');
      } else if (content.startsWith('tel:')) {
        buffer.writeln('• Type: Phone Number');
        info.add('Contains telephone number');
      } else if (content.startsWith('mailto:')) {
        buffer.writeln('• Type: Email Address');
        info.add('Contains email address');
      } else if (content.startsWith('sms:') || content.startsWith('SMSTO:')) {
        buffer.writeln('• Type: SMS Message');
        info.add('Contains SMS message');
      } else if (content.startsWith('BEGIN:VCARD')) {
        buffer.writeln('• Type: Contact Card (vCard)');
        info.add('Contains contact information');
      } else {
        buffer.writeln('• Type: Plain Text');
        info.add('Contains plain text data');
      }
      buffer.writeln();

      // URL Analysis
      if (content.contains('http://') || content.contains('https://')) {
        buffer.writeln('URL SECURITY CHECK:\n');

        // Check for HTTP (insecure)
        if (content.contains('http://')) {
          riskScore += 30;
          warnings.add('⚠️ Uses insecure HTTP protocol (not HTTPS)');
        }

        // Check for IP addresses instead of domains
        final ipRegex = RegExp(r'https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}');
        if (ipRegex.hasMatch(content)) {
          riskScore += 25;
          warnings.add('⚠️ Uses IP address instead of domain name');
        }

        // Check for suspicious TLDs
        final suspiciousTlds = [
          '.xyz',
          '.top',
          '.club',
          '.work',
          '.date',
          '.bid',
          '.stream'
        ];
        for (final tld in suspiciousTlds) {
          if (content.toLowerCase().contains(tld)) {
            riskScore += 15;
            warnings.add('⚠️ Uses suspicious top-level domain: $tld');
            break;
          }
        }

        // Check for URL shorteners
        final shorteners = ['bit.ly', 'goo.gl', 'tinyurl.com', 'ow.ly', 't.co'];
        for (final shortener in shorteners) {
          if (content.toLowerCase().contains(shortener)) {
            riskScore += 20;
            warnings.add('⚠️ Uses URL shortener (hides actual destination)');
            break;
          }
        }

        // Check for typosquatting patterns
        final commonTypos = ['g00gle', 'facebok', 'arnazon', 'micros0ft'];
        for (final typo in commonTypos) {
          if (content.toLowerCase().contains(typo)) {
            riskScore += 40;
            warnings.add('⚠️ Possible typosquatting detected');
            break;
          }
        }

        // Check for @ symbol (credential stuffing)
        if (content.contains('@') &&
            (content.startsWith('http://') || content.startsWith('https://'))) {
          riskScore += 35;
          warnings.add(
              '⚠️ URL contains @ symbol (possible credential theft attempt)');
        }

        // Extract domain
        final domainRegex = RegExp(r'https?://(?:www\.)?([^/]+)');
        final match = domainRegex.firstMatch(content);
        if (match != null) {
          final domain = match.group(1);
          buffer.writeln('• Domain: $domain');
        }

        buffer.writeln();
      }

      // Length Analysis
      if (content.length > 500) {
        riskScore += 10;
        warnings
            .add('⚠️ Unusually long content (${content.length} characters)');
      }

      // Special character analysis
      final specialChars = RegExp(r'[<>{}|\\^`]');
      if (specialChars.hasMatch(content)) {
        riskScore += 15;
        warnings.add('⚠️ Contains potentially dangerous special characters');
      }

      // Display Warnings
      if (warnings.isNotEmpty) {
        buffer.writeln('⚠️ SECURITY WARNINGS:');
        for (final warning in warnings) {
          buffer.writeln(warning);
        }
        buffer.writeln();
      }

      // Display Info
      if (info.isNotEmpty) {
        buffer.writeln('ℹ️ INFORMATION:');
        for (final item in info) {
          buffer.writeln('• $item');
        }
        buffer.writeln();
      }

      // Safety Assessment
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('SAFETY ASSESSMENT:\n');

      SafetyLevel level;
      String assessment;

      if (riskScore == 0) {
        level = SafetyLevel.safe;
        assessment = '✅ SAFE - No security issues detected';
      } else if (riskScore < 20) {
        level = SafetyLevel.low;
        assessment = '🟢 LOW RISK - Minor concerns';
      } else if (riskScore < 50) {
        level = SafetyLevel.medium;
        assessment = '🟡 MEDIUM RISK - Several security concerns';
      } else if (riskScore < 80) {
        level = SafetyLevel.high;
        assessment = '🟠 HIGH RISK - Significant security issues';
      } else {
        level = SafetyLevel.critical;
        assessment = '🔴 CRITICAL RISK - Do not trust this QR code!';
      }

      buffer.writeln(assessment);
      buffer.writeln('Risk Score: $riskScore/100');
      buffer.writeln();

      // Recommendations
      buffer.writeln('RECOMMENDATIONS:\n');
      if (level == SafetyLevel.safe || level == SafetyLevel.low) {
        buffer.writeln('✓ This QR code appears safe to use');
        buffer.writeln(
            '✓ Always verify the destination before entering sensitive information');
      } else if (level == SafetyLevel.medium) {
        buffer.writeln('• Proceed with caution');
        buffer.writeln('• Verify the source of this QR code');
        buffer.writeln(
            '• Do not enter sensitive information without verification');
      } else {
        buffer.writeln('✗ DO NOT TRUST this QR code');
        buffer.writeln('✗ Delete or report this QR code');
        buffer.writeln('✗ Never scan QR codes from untrusted sources');
      }

      setState(() {
        _result = buffer.toString();
        _safetyLevel = level;
      });
    } catch (e) {
      setState(() {
        _result = 'Error analyzing content: ${e.toString()}';
        _safetyLevel = SafetyLevel.unknown;
      });
    }
  }

  Color _getSafetyColor() {
    switch (_safetyLevel) {
      case SafetyLevel.safe:
        return AppColors.success;
      case SafetyLevel.low:
        return AppColors.info;
      case SafetyLevel.medium:
        return AppColors.warning;
      case SafetyLevel.high:
        return const Color(0xFFFF9800);
      case SafetyLevel.critical:
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getSafetyIcon() {
    switch (_safetyLevel) {
      case SafetyLevel.safe:
        return Icons.check_circle;
      case SafetyLevel.low:
        return Icons.info;
      case SafetyLevel.medium:
        return Icons.warning;
      case SafetyLevel.high:
        return Icons.error;
      case SafetyLevel.critical:
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'QR CONTENT ANALYZER',
      activeCategory: ToolCategory.qrBarcode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safety Indicator
            if (_safetyLevel != SafetyLevel.unknown) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getSafetyColor().withOpacity(0.1),
                  border: Border.all(color: _getSafetyColor()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(_getSafetyIcon(), color: _getSafetyColor(), size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _safetyLevel
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _getSafetyColor(),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Security Assessment Complete',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            const SectionHeader(title: 'QR CODE CONTENT'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _controller,
              hintText:
                  'Paste QR code content here to analyze for phishing attempts and security risks...\n\nExample: https://example.com/login',
              minLines: 4,
              maxLines: 8,
              onChanged: (_) => setState(() {
                _result = '';
                _safetyLevel = SafetyLevel.unknown;
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'ANALYZE CONTENT',
              icon: Icons.security,
              onPressed: _analyzeContent,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'ANALYSIS RESULT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum SafetyLevel {
  unknown,
  safe,
  low,
  medium,
  high,
  critical,
}
