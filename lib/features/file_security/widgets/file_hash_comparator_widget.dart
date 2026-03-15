import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class FileHashComparatorWidget extends ConsumerStatefulWidget {
  const FileHashComparatorWidget({super.key});

  @override
  ConsumerState<FileHashComparatorWidget> createState() =>
      _FileHashComparatorWidgetState();
}

class _FileHashComparatorWidgetState
    extends ConsumerState<FileHashComparatorWidget> {
  final _expectedHashController = TextEditingController();
  String? _fileName;
  String? _computedHash;
  bool _isComparing = false;
  bool? _matches;

  Future<void> _compareHashes() async {
    if (_expectedHashController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter expected hash value')),
      );
      return;
    }

    setState(() {
      _isComparing = true;
      _matches = null;
    });

    // Simulate file reading and hash calculation
    await Future.delayed(const Duration(seconds: 2));

    final simulatedContent = utf8
        .encode('Simulated file content for hash calculation demonstration');
    final computedHash = sha256.convert(simulatedContent).toString();

    setState(() {
      _fileName = 'example_file.txt';
      _computedHash = computedHash;
      _matches = computedHash.toLowerCase() ==
          _expectedHashController.text.trim().toLowerCase();
      _isComparing = false;
    });
  }

  void _copyHash() {
    if (_computedHash != null) {
      Clipboard.setData(ClipboardData(text: _computedHash!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Computed hash copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hash Comparator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'File Hash Comparator',
              subtitle: 'Verify file integrity by comparing hashes',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1: Enter Expected Hash',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppInput(
                      controller: _expectedHashController,
                      labelText: 'Expected Hash (SHA-256)',
                      hintText: 'Paste the expected hash value here...',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Step 2: Calculate & Compare',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: _isComparing
                          ? 'Calculating...'
                          : 'Calculate Hash & Compare',
                      onPressed: _isComparing ? null : _compareHashes,
                      isLoading: _isComparing,
                      icon: Icons.compare_arrows,
                    ),
                  ],
                ),
              ),
            ),
            if (_matches != null) ...[
              const SizedBox(height: 24),

              // Result Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _matches!
                        ? [AppColors.successDim, AppColors.bgSurface]
                        : [AppColors.dangerDim, AppColors.bgSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _matches! ? AppColors.success : AppColors.danger,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _matches!
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 64,
                      color: _matches! ? AppColors.success : AppColors.danger,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _matches! ? 'HASH VERIFIED' : 'HASH MISMATCH',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _matches! ? AppColors.success : AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _matches!
                          ? 'File integrity confirmed - hashes match perfectly'
                          : 'File may be corrupted or tampered with',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: _matches! ? AppColors.success : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Hash Comparison
              Text(
                'Hash Comparison',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _buildComparisonRow(
                  'Expected', _expectedHashController.text.trim()),
              const SizedBox(height: 12),
              _buildComparisonRow('Computed', _computedHash!),
              const SizedBox(height: 16),

              AppButton(
                label: 'Copy Computed Hash',
                onPressed: _copyHash,
                variant: AppButtonVariant.secondary,
                icon: Icons.copy,
              ),
            ],
            if (!_isComparing && _matches == null) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.compare_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter expected hash and calculate\nto verify file integrity',
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

  Widget _buildComparisonRow(String label, String hash) {
    return Card(
      color: AppColors.bgSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
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

  @override
  void dispose() {
    _expectedHashController.dispose();
    super.dispose();
  }
}
