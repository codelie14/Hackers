import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/salt_generator_service.dart';

class SaltGeneratorWidget extends ConsumerStatefulWidget {
  const SaltGeneratorWidget({super.key});

  @override
  ConsumerState<SaltGeneratorWidget> createState() => _SaltGeneratorWidgetState();
}

class _SaltGeneratorWidgetState extends ConsumerState<SaltGeneratorWidget> {
  int _saltLength = 32;
  bool _hexOutput = true;
  int _batchCount = 1;
  List<String> _salts = [];
  bool _isLoading = false;

  void _generateSalts() {
    setState(() {
      _isLoading = true;
      _salts = [];
    });

    // Small delay for UX
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        final salts = _batchCount == 1
            ? [SaltGeneratorService.generateSalt(length: _saltLength, hexOutput: _hexOutput)]
            : SaltGeneratorService.generateMultipleSalts(
                count: _batchCount,
                length: _saltLength,
                hexOutput: _hexOutput,
              );

        setState(() {
          _salts = salts;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SALT GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Configuration'),
            const SizedBox(height: 8),

            // Length slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Salt Length (bytes)',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$_saltLength bytes',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.accent,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.accent,
                      overlayColor: AppColors.accentGhost,
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: _saltLength.toDouble(),
                      min: 8,
                      max: 128,
                      divisions: 24,
                      label: '$_saltLength',
                      onChanged: (value) {
                        setState(() {
                          _saltLength = value.toInt();
                          _salts = [];
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min: 8',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        'Max: 128',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Output format toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Output Format',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() {
                            _hexOutput = true;
                            _salts = [];
                          }),
                          borderRadius: BorderRadius.circular(6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _hexOutput ? AppColors.accent : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _hexOutput ? AppColors.accent : AppColors.border,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'HEX',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: _hexOutput ? Colors.black : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() {
                            _hexOutput = false;
                            _salts = [];
                          }),
                          borderRadius: BorderRadius.circular(6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_hexOutput ? AppColors.accent : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: !_hexOutput ? AppColors.accent : AppColors.border,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'BASE64',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: !_hexOutput ? Colors.black : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Batch count
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Batch Count',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$_batchCount salt${_batchCount > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [1, 3, 5, 10, 20].map((count) {
                      final isSelected = _batchCount == count;
                      return InkWell(
                        onTap: () => setState(() {
                          _batchCount = count;
                          _salts = [];
                        }),
                        borderRadius: BorderRadius.circular(6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accent : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? AppColors.accent : AppColors.border,
                            ),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.black : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            AppButton(
              label: _batchCount == 1 ? 'GENERATE SALT ▶' : 'GENERATE ${_batchCount} SALTS ▶',
              icon: Icons.casino,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _generateSalts,
            ),

            if (_salts.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: _batchCount == 1 ? 'Generated Salt' : 'Generated Salts',
                subtitle: '${_saltLength * 8}-bit | ${_hexOutput ? "HEX" : "Base64"}',
              ),
              const SizedBox(height: 8),
              ..._salts.asMap().entries.map((entry) {
                final index = entry.key;
                final salt = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentGhost,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                _batchCount > 1 ? '#${index + 1}' : 'SALT',
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CopyButton(text: salt),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          salt,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${salt.length} characters | ${_saltLength * 8} bits of entropy',
                          style: const TextStyle(
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
            ],
          ],
        ),
      ),
    );
  }
}
