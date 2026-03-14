import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/tool_card.dart';
import '../../shared/widgets/section_header.dart';

class CategoryScreen extends ConsumerWidget {
  final ToolCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTools = ToolsRegistry.byCategory(category);
    final available = allTools.where((t) => t.isAvailable).toList();
    final comingSoon = allTools.where((t) => !t.isAvailable).toList();
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (width >= kDesktopBreakpoint) {
      crossAxisCount = 3;
    } else if (width >= kTabletBreakpoint) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return AppScaffold(
      title: category.displayName.toUpperCase(),
      activeCategory: category,
      showBackButton: true,
      body: CustomScrollView(
        slivers: [
          // Category hero
          SliverToBoxAdapter(
            child: _CategoryHero(category: category, toolCount: allTools.length, availableCount: available.length),
          ),

          // Available tools
          if (available.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Available',
                  subtitle: '${available.length} tools',
                  color: category.color,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => ToolCard(tool: available[i]),
                  childCount: available.length,
                ),
              ),
            ),
          ],

          // Coming soon
          if (comingSoon.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Coming Soon',
                  subtitle: '${comingSoon.length} tools in development',
                  color: AppColors.textMuted,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => ToolCard(tool: comingSoon[i]),
                  childCount: comingSoon.length,
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _CategoryHero extends StatelessWidget {
  final ToolCategory category;
  final int toolCount;
  final int availableCount;

  const _CategoryHero({
    required this.category,
    required this.toolCount,
    required this.availableCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(category.icon, size: 28, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$availableCount READY',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: color,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$toolCount total tools',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
