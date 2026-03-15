import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  double? _entropy;
  String? _analysis;
  List<double>? _entropyBlocks;
  bool _isAnalyzing = false;

  Future<void> _analyzeEntropy() async {
    setState(() {
      _isAnalyzing = true;
      _entropy = null;
      _analysis = null;
      _entropyBlocks = null;
    });

    // Simulate file entropy analysis
    await Future.delayed(const Duration(seconds: 2));

    // Generate simulated entropy data
    final random = Random.secure();
    final baseEntropy = 7.2 + (random.nextDouble() * 0.8);
    final blocks = List.generate(16, (_) => 6.0 + random.nextDouble() * 2.0);

    setState(() {
      _fileName = 'encrypted_data.bin';
      _entropy = baseEntropy;
      _entropyBlocks = blocks;

      if (baseEntropy > 7.5) {
        _analysis =
            'High entropy detected - File appears to be encrypted or compressed';
      } else if (baseEntropy > 6.0) {
        _analysis = 'Moderate entropy - File may contain mixed content';
      } else {
        _analysis = 'Low entropy - File likely contains unencrypted data';
      }

      _isAnalyzing = false;
    });
  }

  Color _getEntropyColor(double entropy) {
    if (entropy > 7.5) return AppColors.danger;
    if (entropy > 6.0) return AppColors.warning;
    return AppColors.success;
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
                      'Detects encrypted/compressed sections',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isAnalyzing ? 'Analyzing...' : 'Select File',
                      onPressed: _isAnalyzing ? null : _analyzeEntropy,
                      isLoading: _isAnalyzing,
                      icon: Icons.file_upload,
                    ),
                  ],
                ),
              ),
            ),
            if (_entropy != null) ...[
              const SizedBox(height: 24),

              // Entropy Score
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_getEntropyColor(_entropy!), AppColors.bgSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getEntropyColor(_entropy!)),
                ),
                child: Column(
                  children: [
                    Icon(
                      _entropy! > 7.5 ? Icons.warning : Icons.info_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Entropy Score',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _entropy!.toStringAsFixed(3),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'bits per byte (max 8.0)',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _analysis!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Block Analysis
              Text(
                'Block-by-Block Entropy',
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
                      SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:
                              _entropyBlocks!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final value = entry.value;
                            final barHeight = (value / 8.0) * 100;

                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: barHeight,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            _getEntropyColor(value),
                                            _getEntropyColor(value)
                                                .withOpacity(0.5)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontSize: 9,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLegend('Low (<6.0)', AppColors.success),
                          _buildLegend('Medium (6.0-7.5)', AppColors.warning),
                          _buildLegend('High (>7.5)', AppColors.danger),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Information Card
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
                            'Understanding Entropy',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Entropy measures randomness (0-8 bits/byte).\nHigh entropy suggests encryption or compression.',
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
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            color: color,
          ),
        ),
      ],
    );
  }
}
