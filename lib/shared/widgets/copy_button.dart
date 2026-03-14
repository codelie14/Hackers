import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/clipboard_utils.dart';

class CopyButton extends StatefulWidget {
  final String text;
  final double size;

  const CopyButton({super.key, required this.text, this.size = 20});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await ClipboardUtils.copy(context, widget.text);
    if (mounted) {
      setState(() => _copied = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _copied ? 'Copied!' : 'Copy to clipboard',
      child: IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _copied ? Icons.check : Icons.copy_outlined,
            key: ValueKey(_copied),
            size: widget.size,
            color: _copied ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
        onPressed: _copy,
        splashRadius: 18,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
