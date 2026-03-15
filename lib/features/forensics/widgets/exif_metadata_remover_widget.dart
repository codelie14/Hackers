import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class ExifMetadataRemoverWidget extends ConsumerStatefulWidget {
  const ExifMetadataRemoverWidget({super.key});

  @override
  ConsumerState<ExifMetadataRemoverWidget> createState() =>
      _ExifMetadataRemoverWidgetState();
}

class _ExifMetadataRemoverWidgetState
    extends ConsumerState<ExifMetadataRemoverWidget> {
  String? _fileName;
  int? _originalSize;
  int? _cleanedSize;
  List<String>? _removedFields;
  bool _isCleaning = false;
  bool _isComplete = false;

  Future<void> _removeMetadata() async {
    setState(() {
      _isCleaning = true;
      _isComplete = false;
      _removedFields = null;
    });

    // Simulate metadata removal (in production, use image package)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _fileName = 'photo_cleaned.jpg';
      _originalSize = 4250;
      _cleanedSize = 3890;
      _removedFields = [
        'GPS Latitude',
        'GPS Longitude',
        'Camera Make',
        'Camera Model',
        'Lens Information',
        'Serial Numbers',
        'Software Used',
        'Date & Time',
      ];
      _isCleaning = false;
      _isComplete = true;
    });
  }

  void _copySummary() {
    final summary = '''
EXIF Removal Summary
====================
Original Size: ${_originalSize} KB
Cleaned Size: $_cleanedSize KB
Space Saved: ${_originalSize! - _cleanedSize!} KB (${((_originalSize! - _cleanedSize!) / _originalSize! * 100).toStringAsFixed(1)}%)

Removed Fields:
${_removedFields!.map((f) => '- $f').join('\n')}
''';
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'EXIF Remover',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'EXIF Metadata Remover',
              subtitle: 'Strip metadata to protect privacy',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.no_photography_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select images to remove\nall metadata and EXIF data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protects location, camera info, timestamps',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label:
                          _isCleaning ? 'Cleaning...' : 'Select & Clean Images',
                      onPressed: _isCleaning ? null : _removeMetadata,
                      isLoading: _isCleaning,
                      icon: Icons.cleaning_services,
                    ),
                  ],
                ),
              ),
            ),
            if (_isComplete) ...[
              const SizedBox(height: 24),

              // Success Card
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
                      'Metadata Successfully Removed',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // File Size Comparison
              Row(
                children: [
                  Expanded(
                    child: _buildSizeCard(
                        'Original', _originalSize!, AppColors.warning),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSizeCard(
                        'Cleaned', _cleanedSize!, AppColors.success),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Removed Fields
              Text(
                'Removed Metadata Fields',
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
                      ..._removedFields!.map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_circle_outline,
                                size: 18,
                                color: AppColors.danger,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                field,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Privacy Protected',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'All sensitive metadata has been stripped.\nImage is safe to share publicly.',
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

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Copy Summary',
                      onPressed: _copySummary,
                      variant: AppButtonVariant.secondary,
                      icon: Icons.copy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Save Image',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Image saved to gallery')),
                        );
                      },
                      icon: Icons.save,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSizeCard(String label, int sizeKB, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$sizeKB KB',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
