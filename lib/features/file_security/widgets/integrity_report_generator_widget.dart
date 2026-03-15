import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
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
  String? _selectedDirectory;
  int? _totalFiles;
  int? _totalSize;
  String? _reportContent;
  List<Map<String, dynamic>>? _fileHashes;

  Future<void> _generateRealReport() async {
    setState(() {
      _isGenerating = true;
      _reportContent = null;
      _fileHashes = null;
    });

    try {
      // Pick a directory using file_picker
      final directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath == null) {
        setState(() => _isGenerating = false);
        return; // User cancelled
      }

      final directory = Directory(directoryPath);

      // Get all files in directory (non-recursive for now)
      final files = <File>[];
      int totalSize = 0;

      await for (final entity in directory.list()) {
        if (entity is File) {
          files.add(entity);
          totalSize += await entity.length();
        }
      }

      // Calculate hashes for all files
      final hashes = <Map<String, dynamic>>[];

      for (final file in files) {
        try {
          final fileBytes = await file.readAsBytes();
          final sha256Hash = sha256.convert(fileBytes).toString();
          final fileSize = await file.length();

          hashes.add({
            'path': file.path,
            'name': path.basename(file.path),
            'size': fileSize,
            'sha256': sha256Hash,
          });
        } catch (e) {
          // Skip files that can't be read
          print('Error reading ${file.path}: $e');
        }
      }

      // Generate JSON report
      final report = {
        'integrity_report': {
          'generated_at': DateTime.now().toIso8601String(),
          'directory': directoryPath,
          'total_files': hashes.length,
          'total_size': totalSize,
          'algorithm': 'SHA-256',
          'files': hashes
              .map((h) => {
                    'name': h['name'],
                    'path': h['path'],
                    'size': h['size'],
                    'size_formatted': _formatFileSize(h['size']),
                    'sha256': h['sha256'],
                  })
              .toList(),
        },
      };

      setState(() {
        _selectedDirectory = directoryPath;
        _totalFiles = hashes.length;
        _totalSize = totalSize;
        _fileHashes = hashes;
        _reportContent = const JsonEncoder.withIndent('  ').convert(report);
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
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
                      onPressed: _isGenerating ? null : _generateRealReport,
                      isLoading: _isGenerating,
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
              ),
            ),
            if (_fileHashes != null && _fileHashes!.isNotEmpty) ...[
              const SizedBox(height: 24),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.successDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 48, color: AppColors.success),
                    const SizedBox(height: 16),
                    Text(
                      'Report Generated Successfully',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryStat(
                            'Files', '$_totalFiles', AppColors.info),
                        _buildSummaryStat('Total Size',
                            _formatFileSize(_totalSize!), AppColors.accent),
                        _buildSummaryStat(
                            'Algorithm', 'SHA-256', AppColors.success),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Directory Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    Icon(Icons.folder, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Directory',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            _selectedDirectory!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                'Files (${_fileHashes!.length})',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              ..._fileHashes!.take(10).map((file) {
                return Card(
                  color: AppColors.bgSurface,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                file['name']!,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _formatFileSize(file['size']),
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.catCrypto.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            file['sha256']!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 9,
                              color: AppColors.catCrypto,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              if (_fileHashes!.length > 10) ...[
                const SizedBox(height: 8),
                Text(
                  '... and ${_fileHashes!.length - 10} more files (see full report)',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Export Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Copy JSON',
                      onPressed: _copyToClipboard,
                      variant: AppButtonVariant.primary,
                      icon: Icons.copy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.save_alt),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Report export feature coming soon')),
                      );
                    },
                    color: AppColors.accent,
                    tooltip: 'Export',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Full JSON Report
              Text(
                'Full JSON Report',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      _reportContent!,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                      ),
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

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard() {
    if (_reportContent != null) {
      Clipboard.setData(ClipboardData(text: _reportContent!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report copied to clipboard')),
      );
    }
  }
}
