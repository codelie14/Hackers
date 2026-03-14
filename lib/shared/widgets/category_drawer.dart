import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import 'app_badge.dart';

class CategoryDrawer extends StatelessWidget {
  final ToolCategory? activeCategory;

  const CategoryDrawer({super.key, this.activeCategory});

  @override
  Widget build(BuildContext context) {
    // On wide screens the drawer is used inline (not pushed/popped),
    // so we return a plain Container. On narrow screens it's inside a
    // Scaffold Drawer and we want Navigator.pop() to work — wrap in Drawer.
    final isInline = MediaQuery.of(context).size.width >= 900;
    final content = Container(
      width: 280,
      color: AppColors.bgSurface,
      child: Column(
        children: [
          // Header
          _DrawerHeader(),
          // Divider
          const Divider(height: 1),
          // Category list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: ToolCategory.values.map((category) {
                return _CategoryTile(
                  category: category,
                  isActive: activeCategory == category,
                  onTap: () {
                    if (!isInline) Navigator.of(context).pop();
                    context.go('/category/${category.name}');
                  },
                );
              }).toList(),
            ),
          ),
          // Footer
          const _DrawerFooter(),
        ],
      ),
    );

    if (isInline) return content;
    return Drawer(width: 280, backgroundColor: AppColors.bgSurface, child: content);
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentGhost,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentDim.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.security, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'HACKERS',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.accent,
                    letterSpacing: 3,
                  ),
                ),
                const Text(
                  'OFFLINE SECURITY TOOLKIT',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8,
                    color: AppColors.textMuted,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ToolCategory category;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = ToolsRegistry.countByCategory(category);
    final availableCount = ToolsRegistry.countAvailableByCategory(category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: isActive ? AppColors.accentGhost : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: isActive
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  category.icon,
                  size: 18,
                  color: isActive ? category.color : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.displayName,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                // Available / total badge
                Text(
                  '$availableCount/$count',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: isActive ? category.color : AppColors.textMuted,
                    letterSpacing: 0.5,
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

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 8),
            const Text(
              'v1.0  ·  IndraLabs',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.successDim,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'OFFLINE',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 8,
                  color: AppColors.success,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
