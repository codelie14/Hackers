import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/pronounceable_password_service.dart';

class PronounceablePasswordWidget extends ConsumerStatefulWidget {
  const PronounceablePasswordWidget({super.key});

  @override
  ConsumerState<PronounceablePasswordWidget> createState() => _PronounceablePasswordWidgetState();
}

class _PronounceablePasswordWidgetState extends ConsumerState<PronounceablePasswordWidget> {
  int _passwordLength = 12;
  bool _includeNumbers = true;
  bool _includeSpecial = false;
  bool _capitalize = true;
  int _batchCount = 1;
  
  List<String> _passwords = [];
  bool _isLoading = false;
  double _avgScore = 0;

  void _generatePasswords() {
    setState(() {
      _isLoading = true;
      _passwords = [];
      _avgScore = 0;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        final passwords = PronounceablePasswordService.generateBatch(
          count: _batchCount,
          length: _passwordLength,
          includeNumbers: _includeNumbers,
          includeSpecial: _includeSpecial,
          capitalize: _capitalize,
        );

        // Calculate average pronounceability score
        double totalScore = 0;
        for (final pwd in passwords) {
          totalScore += PronounceablePasswordService.getPronounceabilityScore(pwd);
        }
        _avgScore = totalScore / passwords.length;

        setState(() {
          _passwords = passwords;
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
      title: 'PRONOUNCEABLE PASSWORDS',
      activeCategory: ToolCategory.password,
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
                        'Password Length',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$_passwordLength chars',
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
                      value: _passwordLength.toDouble(),
                      min: 6,
                      max: 32,
                      divisions: 26,
                      label: '$_passwordLength',
                      onChanged: (value) {
                        setState(() {
                          _passwordLength = value.toInt();
                          _passwords = [];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options
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
                    'Character Options',
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
                        child: _OptionToggle(
                          label: 'NUMBERS',
                          value: _includeNumbers,
                          onChanged: (value) {
                            setState(() {
                              _includeNumbers = value;
                              _passwords = [];
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _OptionToggle(
                          label: 'SPECIAL',
                          value: _includeSpecial,
                          onChanged: (value) {
                            setState(() {
                              _includeSpecial = value;
                              _passwords = [];
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _OptionToggle(
                          label: 'CAPS',
                          value: _capitalize,
                          onChanged: (value) {
                            setState(() {
                              _capitalize = value;
                              _passwords = [];
                            });
                          },
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
                        'Generate Count',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$_batchCount password${_batchCount > 1 ? 's' : ''}',
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
                          _passwords = [];
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
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
              label: _batchCount == 1 ? 'GENERATE PASSWORD ▶' : 'GENERATE $_batchCount PASSWORDS ▶',
              icon: Icons.casino,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _generatePasswords,
            ),

            if (_passwords.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: _batchCount == 1 ? 'Generated Password' : 'Generated Passwords',
                subtitle: 'Avg. Pronounceability: ${_avgScore.toStringAsFixed(1)}%',
              ),
              const SizedBox(height: 8),
              ..._passwords.asMap().entries.map((entry) {
                final index = entry.key;
                final password = entry.value;
                final score = PronounceablePasswordService.getPronounceabilityScore(password);
                
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
                            if (_batchCount > 1) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentGhost,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: SelectableText(
                                password,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            CopyButton(text: password),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PRONOUNCEABILITY SCORE',
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 9,
                                      color: AppColors.textMuted,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(
                                      value: score / 100,
                                      backgroundColor: AppColors.border,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getScoreColor(score),
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${score.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _getScoreColor(score),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${password.length} characters | ${_getStrengthLabel(_passwordLength)}',
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

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.info;
    if (score >= 40) return AppColors.warning;
    return AppColors.danger;
  }

  String _getStrengthLabel(int length) {
    if (length < 8) return 'WEAK';
    if (length < 12) return 'MEDIUM';
    if (length < 16) return 'STRONG';
    return 'VERY STRONG';
  }
}

class _OptionToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OptionToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: value ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: value ? Colors.black : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
