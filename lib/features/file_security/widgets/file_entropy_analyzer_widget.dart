import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class FileEntropyAnalyzerWidget extends ConsumerStatefulWidget {
  const FileEntropyAnalyzerWidget({super.key});

  @override
  ConsumerState<FileEntropyAnalyzerWidget> createState() =>
      _FileEntropyAnalyzerWidgetState();
}

class _FileEntropyAnalyzerWidgetState
    extends ConsumerState<FileEntropyAnalyzerWidget> {
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  double? _entropy;
  String? _analysis;
  List<double>? _entropyBlocks;
  bool _isAnalyzing = false;

  // Calculate Shannon entropy of byte array
  double _calculateShannonEntropy(List<int> bytes) {
    if (bytes.isEmpty) return 0.0;

    // Count frequency of each byte value (0-255)
    final frequencies = Map<int, int>();
    for (var byte in bytes) {
      frequencies[byte] = (frequencies[byte] ?? 0) + 1;
    }

    // Calculate entropy
    double entropy = 0.0;
    final totalBytes = bytes.length;

    for (var count in frequencies.values) {
      if (count > 0) {
        final probability = count / totalBytes;
        entropy -= probability * (log(probability) / ln2);
      }
    }

    return entropy;
  }

  String _getEntropyInterpretation(double entropy) {
    if (entropy > 7.9) {
      return 'Very High - Likely encrypted or compressed (maximum randomness)';
    } else if (entropy > 7.5) {
      return 'High - Appears to be encrypted or compressed';
    } else if (entropy > 6.5) {
      return 'Moderate-High - Mixed content, possible partial encryption';
    } else if (entropy > 5.0) {
      return 'Moderate - Normal file content with some structure';
    } else if (entropy > 3.0) {
      return 'Low-Moderate - Structured data, text, or simple formats';
    } else {
      return 'Low - Highly structured or repetitive data';
    }
  }

  Future<void> _analyzeRealEntropy() async {
    setState(() {
      _isAnalyzing = true;
      _entropy = null;
      _analysis = null;
      _entropyBlocks = null;
    });

    try {
      // Pick a file using file_picker
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isAnalyzing = false);
        return; // User cancelled
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      final fileName = result.files.single.name;

      // Read file bytes (sample first 64KB for performance)
      final randomAccessFile = await file.open();
      final bufferSize = fileSize > 65536 ? 65536 : fileSize.toInt();
      final buffer = Uint8List(bufferSize);
      await randomAccessFile.readInto(buffer, 0, bufferSize);
      await randomAccessFile.close();

      final bytes = buffer.toList();

      // Calculate overall entropy
      final entropy = _calculateShannonEntropy(bytes);

      // Calculate block entropy (divide into 16 blocks)
      final blockSize = (bytes.length / 16).floor();
      final blocks = <double>[];
      for (int i = 0; i < 16; i++) {
        final start = i * blockSize;
        final end = (i == 15) ? bytes.length : start + blockSize;
        final block = bytes.sublist(start, end);
        blocks.add(_calculateShannonEntropy(block));
      }

      setState(() {
        _fileName = fileName;
        _filePath = result.files.single.path;
        _fileSize = fileSize;
        _entropy = entropy;
        _entropyBlocks = blocks;
        _analysis = _getEntropyInterpretation(entropy);
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing file: ${e.toString()}'),
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
      title: 'Entropy Analyzer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'File Entropy Analysis',
              subtitle: 'Analyze randomness to detect encryption',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a file to analyze entropy',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Shannon entropy calculation (0-8 bits)',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isAnalyzing ? 'Analyzing...' : 'Select File',
                      onPressed: _isAnalyzing ? null : _analyzeRealEntropy,
                      isLoading: _isAnalyzing,
                      icon: Icons.file_upload,
                    ),
                  ],
                ),
              ),
            ),
            if (_entropy != null) ...[
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
                    Icon(Icons.insert_drive_file, color: AppColors.info),
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
                            'Size: ${_formatFileSize(_fileSize!)}',
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

              // Entropy Score
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getEntropyColor(_entropy!).withOpacity(0.3),
                      _getEntropyColor(_entropy!).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: _getEntropyColor(_entropy!), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Entropy Score',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: _getEntropyColor(_entropy!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _entropy!.toStringAsFixed(3),
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _getEntropyColor(_entropy!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '/ 8.0',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 24,
                            color: _getEntropyColor(_entropy!).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _analysis!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Entropy Blocks Visualization
              Text(
                'Block-by-Block Analysis (16 blocks)',
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
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _entropyBlocks!.length,
                        itemBuilder: (context, index) {
                          final entropy = _entropyBlocks![index];
                          return Container(
                            decoration: BoxDecoration(
                              color: _getEntropyColor(entropy).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: _getEntropyColor(entropy)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'B${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entropy.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getEntropyColor(entropy),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Each block shows local entropy (higher = more random)',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Educational Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.catCrypto.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.catCrypto),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Understanding Entropy',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.catCrypto,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Shannon entropy measures the randomness in data:\n\n'
                      '• 0.0-3.0: Low entropy (highly structured)\n'
                      '• 3.0-5.0: Moderate entropy (normal files)\n'
                      '• 5.0-7.0: High entropy (compressed/encrypted)\n'
                      '• 7.0-8.0: Maximum entropy (truly random)\n\n'
                      'Use this to detect encryption, compression, or anomalies.',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.5,
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

  Color _getEntropyColor(double entropy) {
    if (entropy > 7.5) return AppColors.danger;
    if (entropy > 6.0) return AppColors.warning;
    return AppColors.success;
  }
}
