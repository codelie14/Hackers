import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/animations/button_animations.dart';

/// Cyberpunk-style bottom navigation bar with fixed items
class BottomNavBar extends StatefulWidget {
  final String? currentRoute;

  const BottomNavBar({
    super.key,
    this.currentRoute,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.surfaceBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'HOME',
                isActive:
                    widget.currentRoute == '/' || widget.currentRoute == null,
                onTap: () => context.go('/'),
              ),

              // Search
              _buildNavItem(
                icon: Icons.search_rounded,
                label: 'SEARCH',
                isActive: false, // TODO: Add search route
                onTap: () {
                  // TODO: Navigate to search
                },
              ),

              // Settings
              _buildNavItem(
                icon: Icons.settings_rounded,
                label: 'SETTINGS',
                isActive: widget.currentRoute == '/settings',
                onTap: () {
                  // TODO: Navigate to settings
                },
              ),

              // Help
              _buildNavItem(
                icon: Icons.help_outline_rounded,
                label: 'HELP',
                isActive: widget.currentRoute == '/help',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return PressScaleAnimation(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.2),
                      AppColors.accent.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? AppColors.accent.withValues(alpha: 0.6)
                  : AppColors.border.withValues(alpha: 0.3),
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accent.withValues(alpha: 0.2)
                      : AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),

              // Label
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.accent : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
