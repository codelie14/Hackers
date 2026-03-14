import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/password_service.dart';

class PasswordGeneratorWidget extends ConsumerStatefulWidget {
  const PasswordGeneratorWidget({super.key});

  @override
  ConsumerState<PasswordGeneratorWidget> createState() => _PasswordGeneratorWidgetState();
}

class _PasswordGeneratorWidgetState extends ConsumerState<PasswordGeneratorWidget> {
  int _length = 16;
  bool _upperCase = true;
  bool _lowerCase = true;
  bool _digits = true;
  bool _symbols = true;
  bool _excludeAmbiguous = false;
  String _password = '';
  double _entropy = 0;

  void _generate() {
    try {
      final pwd = PasswordService.generate(
        length: _length,
        upperCase: _upperCase,
        lowerCase: _lowerCase,
        digits: _digits,
        symbols: _symbols,
        excludeAmbiguous: _excludeAmbiguous,
      );
      final ent = PasswordService.entropy(pwd);
      setState(() { _password = pwd; _entropy = ent; });
    } catch (e) {
      setState(() { _password = ''; });
    }
  }

  Color _strengthColor() {
    if (_entropy < 28) return AppColors.danger;
    if (_entropy < 36) return AppColors.warning;
    if (_entropy < 60) return AppColors.info;
    if (_entropy < 80) return AppColors.success;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _entropy > 0 ? PasswordService.strengthLabel(_entropy) : '';
    final bfTime = _entropy > 0 ? PasswordService.bruteForceDuration(_entropy) : null;

    return AppScaffold(
      title: 'PASSWORD GENERATOR',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Length: $_length'),
            Slider(
              value: _length.toDouble(),
              min: 4,
              max: 128,
              divisions: 124,
              label: '$_length',
              onChanged: (v) => setState(() => _length = v.round()),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Character Sets'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CheckChip(label: 'A–Z', value: _upperCase, onChanged: (v) => setState(() => _upperCase = v)),
                _CheckChip(label: 'a–z', value: _lowerCase, onChanged: (v) => setState(() => _lowerCase = v)),
                _CheckChip(label: '0–9', value: _digits, onChanged: (v) => setState(() => _digits = v)),
                _CheckChip(label: '!@#\$', value: _symbols, onChanged: (v) => setState(() => _symbols = v)),
                _CheckChip(label: 'No ambiguous (Il1O0)', value: _excludeAmbiguous, isExclusion: true, onChanged: (v) => setState(() => _excludeAmbiguous = v)),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE PASSWORD',
              icon: Icons.password,
              fullWidth: true,
              onPressed: _generate,
            ),
            if (_password.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionHeader(title: 'Generated Password'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _password.isEmpty ? AppColors.border : _strengthColor().withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            _password,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              letterSpacing: 2,
                              height: 1.5,
                            ),
                          ),
                        ),
                        CopyButton(text: _password),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 18, color: AppColors.textSecondary),
                          onPressed: _generate,
                          tooltip: 'Regenerate',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Strength bar
                    Row(
                      children: [
                        const Text('STRENGTH: ', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, color: AppColors.textMuted, letterSpacing: 2)),
                        Text(strength, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, color: _strengthColor(), fontWeight: FontWeight.w700, letterSpacing: 2)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: (_entropy / 128).clamp(0.0, 1.0),
                              backgroundColor: AppColors.bgBase,
                              color: _strengthColor(),
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (bfTime != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '⚡ ~${_entropy.toStringAsFixed(1)} bits  ·  Brute-force: ${_formatDuration(bfTime)}',
                        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds}s';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 365) return '${d.inDays}d';
    final years = d.inDays / 365;
    if (years < 1e6) return '${years.toStringAsFixed(0)}y';
    if (years < 1e9) return '${(years / 1e6).toStringAsFixed(1)}My';
    if (years < 1e12) return '${(years / 1e9).toStringAsFixed(1)}By';
    return '∞';
  }
}

class _CheckChip extends StatelessWidget {
  final String label;
  final bool value;
  final bool isExclusion;
  final ValueChanged<bool> onChanged;

  const _CheckChip({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isExclusion = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isExclusion ? AppColors.warning : AppColors.accent;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: value ? activeColor.withValues(alpha: 0.12) : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: value ? activeColor.withValues(alpha: 0.6) : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 14,
              color: value ? activeColor : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                color: value ? activeColor : AppColors.textSecondary,
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
