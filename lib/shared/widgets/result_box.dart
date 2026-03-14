import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/clipboard_utils.dart';
import 'package:share_plus/share_plus.dart';

class ResultBox extends StatelessWidget {
  final String content;
  final String label;
  final bool isError;
  final bool monospace;
  final int? maxLines;

  const ResultBox({
    super.key,
    required this.content,
    this.label = 'OUTPUT',
    this.isError = false,
    this.monospace = true,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isError ? AppColors.danger : AppColors.border;
    final labelColor = isError ? AppColors.danger : AppColors.accent;

    return AnimatedOpacity(
      opacity: content.isEmpty ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isError ? AppColors.danger : AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  if (!isError && content.isNotEmpty) ...[
                    _ActionButton(
                      icon: Icons.copy_outlined,
                      tooltip: 'Copy',
                      onTap: () => ClipboardUtils.copy(context, content),
                    ),
                    const SizedBox(width: 4),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      tooltip: 'Share',
                      onTap: () => Share.share(content),
                    ),
                  ],
                ],
              ),
            ),
            // Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: SelectableText(
                content,
                maxLines: maxLines,
                style: TextStyle(
                  fontFamily: monospace ? 'JetBrainsMono' : null,
                  fontSize: 12,
                  color: isError ? AppColors.danger : AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 15, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
