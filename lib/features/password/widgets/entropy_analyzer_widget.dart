import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/password_service.dart';

class EntropyAnalyzerWidget extends ConsumerStatefulWidget {
  const EntropyAnalyzerWidget({super.key});

  @override
  ConsumerState<EntropyAnalyzerWidget> createState() => _EntropyAnalyzerWidgetState();
}

class _EntropyAnalyzerWidgetState extends ConsumerState<EntropyAnalyzerWidget> {
  final _controller = TextEditingController();
  double _entropy = 0;
  int _charsetSize = 0;
  Duration? _bruteForce;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze(String text) {
    if (text.isEmpty) {
      setState(() { _entropy = 0; _charsetSize = 0; _bruteForce = null; });
      return;
    }
    final ent = PasswordService.entropy(text);
    final bf = PasswordService.bruteForceDuration(ent);
    setState(() { _entropy = ent; _bruteForce = bf; });
  }

  Color get _strengthColor {
    if (_entropy < 28) return AppColors.danger;
    if (_entropy < 36) return AppColors.warning;
    if (_entropy < 60) return AppColors.info;
    if (_entropy < 80) return AppColors.success;
    return AppColors.accent;
  }

  String get _strengthLabel => _entropy > 0 ? PasswordService.strengthLabel(_entropy) : '—';

  String _formatDuration(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds} seconds';
    if (d.inMinutes < 60) return '${d.inMinutes} minutes';
    if (d.inHours < 24) return '${d.inHours} hours';
    if (d.inDays < 365) return '${d.inDays} days';
    final years = d.inDays / 365;
    if (years < 1e6) return '${years.toStringAsFixed(0)} years';
    if (years < 1e9) return '${(years / 1e6).toStringAsFixed(1)} million years';
    return 'practically forever (> 1 billion years)';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ENTROPY ANALYZER',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Password'),
            const SizedBox(height: 8),
            AppInput(
              controller: _controller,
              hintText: 'Enter password to analyze...',
              onChanged: _analyze,
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
                      onPressed: () { _controller.clear(); _analyze(''); },
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            // Strength meter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _entropy > 0 ? _strengthColor.withValues(alpha: 0.3) : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _strengthLabel,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _entropy > 0 ? _strengthColor : AppColors.textMuted,
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _entropy > 0 ? '${_entropy.toStringAsFixed(1)} bits' : '—',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _entropy > 0 ? _strengthColor : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: LinearProgressIndicator(
                        value: (_entropy / 128).clamp(0.0, 1.0),
                        backgroundColor: AppColors.bgBase,
                        color: _entropy > 0 ? _strengthColor : AppColors.textMuted,
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _StatRow(label: 'Password Length', value: '${_controller.text.length} chars'),
                  const SizedBox(height: 8),
                  _StatRow(label: 'Entropy', value: _entropy > 0 ? '${_entropy.toStringAsFixed(2)} bits' : '—'),
                  const SizedBox(height: 8),
                  _StatRow(label: 'Brute-Force Time', value: _bruteForce != null ? _formatDuration(_bruteForce!) : '—', valueColor: _strengthColor),
                  const SizedBox(height: 8),
                  _StatRow(label: 'Assumption', value: '1 billion guesses/sec (GPU)', valueColor: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('STRENGTH THRESHOLDS', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, color: AppColors.textMuted, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  ...[
                    ['< 28 bits', 'VERY WEAK', AppColors.danger],
                    ['28-36 bits', 'WEAK', AppColors.warning],
                    ['36-60 bits', 'FAIR', AppColors.info],
                    ['60-80 bits', 'STRONG', AppColors.success],
                    ['> 80 bits', 'VERY STRONG', AppColors.accent],
                  ].map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: row[2] as Color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(row[0] as String, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Text(row[1] as String, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: row[2] as Color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}
