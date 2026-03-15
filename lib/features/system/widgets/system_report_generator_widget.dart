import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class SystemReportGeneratorWidget extends ConsumerStatefulWidget {
  const SystemReportGeneratorWidget({super.key});

  @override
  ConsumerState<SystemReportGeneratorWidget> createState() =>
      _SystemReportGeneratorWidgetState();
}

class _SystemReportGeneratorWidgetState
    extends ConsumerState<SystemReportGeneratorWidget> {
  bool _isGenerating = false;
  String? _reportContent;

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
      _reportContent = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    final report = {
      'system_report': {
        'generated_at': DateTime.now().toIso8601String(),
        'hostname': 'hackers-device',
        'os': {
          'platform': 'Platform',
          'version': 'OS Version',
          'architecture': 'x86_64',
        },
        'hardware': {
          'cpu_cores': 8,
          'total_ram_gb': 16.0,
          'storage_total_gb': 512,
          'storage_free_gb': 256,
        },
        'network': {
          'interfaces': [
            {'name': 'wlan0', 'ip': '192.168.1.105', 'type': 'WiFi'},
            {'name': 'lo', 'ip': '127.0.0.1', 'type': 'Loopback'},
          ],
        },
        'security': {
          'firewall_enabled': true,
          'last_update_check': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'pending_updates': 5,
        },
      },
    };

    setState(() {
      _reportContent = const JsonEncoder.withIndent('  ').convert(report);
      _isGenerating = false;
    });
  }

  void _copyToClipboard() {
    if (_reportContent != null) {
      Clipboard.setData(ClipboardData(text: _reportContent!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'System Report',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'System Report Generator',
              subtitle: 'Generate comprehensive system information',
            ),
            const SizedBox(height: 24),
            AppButton(
              label: _isGenerating ? 'Generating...' : 'Generate Report',
              onPressed: _isGenerating ? null : _generateReport,
              isLoading: _isGenerating,
            ),
            if (_reportContent != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Copy JSON',
                      onPressed: _copyToClipboard,
                      variant: AppButtonVariant.secondary,
                      icon: Icons.copy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'system_report.json',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copyToClipboard,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      SelectableText(
                        _reportContent!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (!_isGenerating && _reportContent == null) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.summarize_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Generate a comprehensive\nsystem report in JSON format',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
