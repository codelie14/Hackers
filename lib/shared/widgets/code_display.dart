import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../../core/theme/app_colors.dart';
import 'copy_button.dart';

class CodeDisplay extends StatelessWidget {
  final String code;
  final String language;
  final bool showCopy;
  final String? label;
  final int? maxLines;

  const CodeDisplay({
    super.key,
    required this.code,
    this.language = 'text',
    this.showCopy = true,
    this.label,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Map<String, TextStyle>.from(atomOneDarkTheme);
    // Override background to match our design
    theme['root'] = const TextStyle(
      color: AppColors.textPrimary,
      backgroundColor: AppColors.bgElevated,
      fontFamily: 'JetBrainsMono',
      fontSize: 12,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Traffic light dots
                const _Dot(color: Color(0xFFFF5F57)),
                const SizedBox(width: 4),
                const _Dot(color: Color(0xFFFFBD2E)),
                const SizedBox(width: 4),
                const _Dot(color: Color(0xFF28CA41)),
                const SizedBox(width: 8),
                Text(
                  label ?? language.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: AppColors.textMuted,
                    letterSpacing: 1.5,
                  ),
                ),
                if (showCopy && code.isNotEmpty) ...[
                  const Spacer(),
                  CopyButton(text: code, size: 15),
                ],
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxLines != null
                    ? maxLines! * 20.0
                    : double.infinity,
              ),
              child: HighlightView(
                code,
                language: language,
                theme: theme,
                padding: const EdgeInsets.all(14),
                textStyle: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
