import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class IntegrityReportGeneratorWidget extends ConsumerStatefulWidget {
  const IntegrityReportGeneratorWidget({super.key});

  @override
  ConsumerState<IntegrityReportGeneratorWidget> createState() =>
      _IntegrityReportGeneratorWidgetState();
}

class _IntegrityReportGeneratorWidgetState
    extends ConsumerState<IntegrityReportGeneratorWidget> {
  bool _isGenerating = false;
  String? _reportContent;
  List<Map<String, String>>? _fileHashes;

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
      _reportContent = null;
      _fileHashes = null;
    });

    // Simulate directory scanning and hash generation
    await Future.delayed(const Duration(seconds: 2));

    final simulatedFiles = [
      {'path': '/home/user/documents/report.pdf', 'size': '1.2 MB'},
      {'path': '/home/user/documents/data.xlsx', 'size': '856 KB'},
      {'path': '/home/user/images/photo.jpg', 'size': '3.4 MB'},
      {'path': '/home/user/code/project.zip', 'size': '12.8 MB'},
    ];

    final hashes = <Map<String, String>>[];
    for (var file in simulatedFiles) {
      hashes.add({
        'path': file['path']!,
        'size': file['size']!,
        'sha256': sha256.convert(utf8.encode(file['path']!)).toString(),
      });
    }

    final report = {
      'integrity_report': {
        'generated_at': DateTime.now().toIso8601String(),
        'directory': '/home/user/documents',
        'total_files': hashes.length,
        'files': hashes,
      },
    };

    setState(() {
      _fileHashes = hashes;
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
      title: 'Integrity Report',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Integrity Report Generator',
              subtitle: 'Generate hash reports for directories',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_zip_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a directory to generate\nan integrity report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Creates SHA-256 hashes for all files',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isGenerating ? 'Scanning...' : 'Select Directory',
                      onPressed: _isGenerating ? null : _generateReport,
                      isLoading: _isGenerating,
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
              ),
            ),
            if (_fileHashes != null) ...[
              const SizedBox(height: 24),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.successDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 40, color: AppColors.success),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report Generated',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_fileHashes!.length} files processed',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // File List
              Text(
                'Files & Hashes',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              ..._fileHashes!.map((file) {
                return Card(
                  color: AppColors.bgSurface,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file,
                                size: 18, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                file['path']!,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.infoDim,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                file['size']!,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          file['sha256']!,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            height: 1.4,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Export Options
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Copy JSON Report',
                      onPressed: _copyToClipboard,
                      variant: AppButtonVariant.secondary,
                      icon: Icons.copy,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Full JSON Preview
              Text(
                'JSON Preview',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _reportContent!,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
