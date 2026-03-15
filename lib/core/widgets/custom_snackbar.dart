import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/animations/button_animations.dart';

/// Custom snackbar with success/error/warning/info styles
class CustomSnackbar {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      type: SnackbarType.success,
      title: title ?? 'Success',
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context,
      message,
      type: SnackbarType.error,
      title: title ?? 'Error',
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      type: SnackbarType.warning,
      title: title ?? 'Warning',
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context,
      message,
      type: SnackbarType.info,
      title: title ?? 'Info',
      duration: duration,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message, {
    required SnackbarType type,
    required String title,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    final controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: overlay,
    );

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarWidget(
        message: message,
        title: title,
        type: type,
        controller: controller,
        duration: duration,
        onDismiss: () {
          controller.reverse().then((_) => overlayEntry?.remove());
        },
      ),
    );

    overlay.insert(overlayEntry);
    controller.forward();
  }
}

enum SnackbarType { success, error, warning, info }

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final String title;
  final SnackbarType type;
  final AnimationController controller;
  final Duration duration;
  final VoidCallback onDismiss;

  const _SnackbarWidget({
    required this.message,
    required this.title,
    required this.type,
    required this.controller,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Curves.easeOutCubic,
    ));

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        widget.controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getColor(), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: _getColor().withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon
                      Icon(_getIcon(), color: _getColor(), size: 24),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Dismiss button
                      PressScaleAnimation(
                        onTap: widget.onDismiss,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return AppColors.successDim.withValues(alpha: 0.9);
      case SnackbarType.error:
        return AppColors.dangerDim.withValues(alpha: 0.9);
      case SnackbarType.warning:
        return AppColors.warningDim.withValues(alpha: 0.9);
      case SnackbarType.info:
        return AppColors.infoDim.withValues(alpha: 0.9);
    }
  }

  Color _getColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return AppColors.success;
      case SnackbarType.error:
        return AppColors.danger;
      case SnackbarType.warning:
        return AppColors.warning;
      case SnackbarType.info:
        return AppColors.info;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }
}
