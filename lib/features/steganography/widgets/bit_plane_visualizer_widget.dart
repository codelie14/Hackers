import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class BitPlaneVisualizerWidget extends ConsumerStatefulWidget {
  const BitPlaneVisualizerWidget({super.key});

  @override
  ConsumerState<BitPlaneVisualizerWidget> createState() =>
      _BitPlaneVisualizerWidgetState();
}

class _BitPlaneVisualizerWidgetState
    extends ConsumerState<BitPlaneVisualizerWidget> {
  String? _imageName;
  int? _selectedBitPlane;
  bool _isAnalyzing = false;

  void _analyzeImage() async {
    if (_imageName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _selectedBitPlane = 0; // Start with bit plane 0
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Bit Plane Visualizer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Bit Plane Visualizer',
              subtitle: 'Analyze individual bit planes of images',
            ),
            const SizedBox(height: 24),

            // Image Selection
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.layers_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _imageName ?? 'Select an image to analyze',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: _imageName != null
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Select Image',
                      onPressed: () {
                        setState(() {
                          _imageName = 'sample_image.png';
                        });
                      },
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

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
                          'Understanding Bit Planes',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 13,
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Each pixel has 8 bits. Viewing individual\nbit planes reveals hidden patterns and data.',
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

            AppButton(
              label: _isAnalyzing ? 'Analyzing...' : 'Analyze Bit Planes',
              onPressed:
                  _isAnalyzing || _imageName == null ? null : _analyzeImage,
              isLoading: _isAnalyzing,
              icon: Icons.analytics_outlined,
            ),

            if (_selectedBitPlane != null) ...[
              const SizedBox(height: 24),

              // Bit Plane Selector
              Text(
                'Select Bit Plane',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(8, (index) {
                  final isSelected = _selectedBitPlane == index;
                  return ChoiceChip(
                    label: Text('Bit $index'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedBitPlane = index);
                      }
                    },
                    selectedColor: AppColors.accent,
                    labelStyle: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Visualization Display
              Text(
                'Bit Plane ${_selectedBitPlane} Visualization',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.bgSurface,
                      AppColors.border.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: AppColors.accent.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bit Plane ${_selectedBitPlane}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Significance: ${_getSignificance(_selectedBitPlane!)}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Information Cards
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Most Significant',
                      'Bits 7-6',
                      'Contains most important\nimage information',
                      AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Middle Bits',
                      'Bits 5-4',
                      'Contains detail\ninformation',
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Least Significant',
                      'Bits 3-0',
                      'Used for LSB\nsteganography',
                      AppColors.success,
                    ),
                  ),
                ],
              ),
            ],

            if (_selectedBitPlane == null && !_isAnalyzing) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.layers_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Analyze bit planes to detect\nsteganography or understand image structure',
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

  String _getSignificance(int bitPlane) {
    if (bitPlane >= 7) return 'Very High - Image structure';
    if (bitPlane >= 5) return 'High - Major details';
    if (bitPlane >= 3) return 'Medium - Fine details';
    return 'Low - Hidden data potential';
  }

  Widget _buildInfoCard(
      String title, String range, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            range,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
