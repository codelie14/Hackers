import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final double fontSize;

  const AppBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.fontSize = 10,
  });

  const AppBadge.comingSoon({super.key, this.fontSize = 9})
      : text = 'SOON',
        color = AppColors.bgElevated,
        textColor = AppColors.textMuted;

  const AppBadge.count({super.key, required this.text, this.fontSize = 9})
      : color = AppColors.accentGhost,
        textColor = AppColors.accent;

  const AppBadge.network({super.key, this.fontSize = 9})
      : text = 'NET',
        color = AppColors.infoDim,
        textColor = AppColors.info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? AppColors.accentGhost,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: (textColor ?? AppColors.accent).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor ?? AppColors.accent,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
