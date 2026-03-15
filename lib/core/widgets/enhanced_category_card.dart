import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/animations/button_animations.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import '../utils/category_icon_helper.dart';

/// Enhanced category card with animations, gradients, and custom SVG icons
class EnhancedCategoryCard extends StatefulWidget {
  final ToolCategory category;

  const EnhancedCategoryCard({
    super.key,
    required this.category,
  });

  @override
  State<EnhancedCategoryCard> createState() => _EnhancedCategoryCardState();
}

class _EnhancedCategoryCardState extends State<EnhancedCategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final color = cat.color;
    final count = ToolsRegistry.countByCategory(cat);
    final availableCount = ToolsRegistry.countAvailableByCategory(cat);
    final hasCustomIcon = CategoryIconHelper.hasCustomIcon(cat);

    return PressScaleAnimation(
      onTap: () => context.go('/category/${cat.name}'),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppGradients.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? color.withValues(alpha: 0.8) : AppColors.border,
              width: _hovered ? 2 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    AppGradients.neonGlow(color: color),
                  ]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon row
                Row(
                  children: [
                    // Custom SVG icon or fallback to Material Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: _hovered
                            ? LinearGradient(
                                colors: [color, color.withValues(alpha: 0.7)],
                              )
                            : null,
                        color: !_hovered ? color.withValues(alpha: 0.12) : null,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _hovered
                            ? [AppGradients.neonGlow(color: color)]
                            : [],
                      ),
                      child: hasCustomIcon
                          ? SvgPicture.asset(
                              CategoryIconHelper.getIconPath(cat),
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            )
                          : Icon(
                              cat.icon,
                              size: 20,
                              color: _hovered ? Colors.white : color,
                            ),
                    ),
                    const Spacer(),
                    // Count badge
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _hovered
                            ? color.withValues(alpha: 0.2)
                            : AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _hovered
                              ? color.withValues(alpha: 0.5)
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        '$availableCount/$count',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _hovered ? color : AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category name
                Expanded(
                  child: Text(
                    cat.displayName,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _hovered
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),

                // Animated accent bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: _hovered ? double.infinity : 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow:
                        _hovered ? [AppGradients.neonGlow(color: color)] : [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
