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

class FileHashCalculatorWidget extends ConsumerStatefulWidget {
  const FileHashCalculatorWidget({super.key});

  @override
  ConsumerState<FileHashCalculatorWidget> createState() =>
      _FileHashCalculatorWidgetState();
}

class _FileHashCalculatorWidgetState
    extends ConsumerState<FileHashCalculatorWidget> {
  String? _fileName;
  String? _fileSize;
  Map<String, String>? _hashes;
  bool _isCalculating = false;

  Future<void> _calculateHashes() async {
    setState(() {
      _isCalculating = true;
      _hashes = null;
    });

    // Simulate file hash calculation (in production, use file_picker and actual file reading)
    await Future.delayed(const Duration(seconds: 2));

    // Simulated file data for demonstration
    final simulatedContent = utf8
        .encode('Simulated file content for hash calculation demonstration');

    setState(() {
      _fileName = 'example_file.txt';
      _fileSize = '1.2 KB';
      _hashes = {
        'MD5': md5.convert(simulatedContent).toString(),
        'SHA-1': sha1.convert(simulatedContent).toString(),
        'SHA-256': sha256.convert(simulatedContent).toString(),
        'SHA-512': sha512.convert(simulatedContent).toString(),
      };
      _isCalculating = false;
    });
  }

  void _copyHash(String algorithm, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('$algorithm hash copied to clipboard'),
          duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'File Hash Calculator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'File Hash Calculator',
              subtitle: 'Compute MD5, SHA1, SHA256, SHA512 hashes',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a file to calculate its hash',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Supports MD5, SHA-1, SHA-256, SHA-512',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isCalculating ? 'Calculating...' : 'Select File',
                      onPressed: _isCalculating ? null : _calculateHashes,
                      isLoading: _isCalculating,
                      icon: Icons.file_upload,
                    ),
                  ],
                ),
              ),
            ),
            if (_hashes != null) ...[
              const SizedBox(height: 24),

              // File Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileName!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Size: $_fileSize',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hash Results
              Text(
                'Hash Values',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _buildHashCard('MD5', _hashes!['MD5']!, AppColors.catPassword),
              const SizedBox(height: 12),
              _buildHashCard('SHA-1', _hashes!['SHA-1']!, AppColors.accent),
              const SizedBox(height: 12),
              _buildHashCard(
                  'SHA-256', _hashes!['SHA-256']!, AppColors.catCrypto),
              const SizedBox(height: 12),
              _buildHashCard(
                  'SHA-512', _hashes!['SHA-512']!, AppColors.catDeveloper),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHashCard(String algorithm, String hash, Color color) {
    return Card(
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
                  algorithm,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyHash(algorithm, hash),
                  tooltip: 'Copy hash',
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SelectableText(
              hash,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
