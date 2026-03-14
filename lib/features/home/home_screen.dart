import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import '../../shared/widgets/search_overlay.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: CustomScrollView(
        slivers: [
          // Header / Hero
          SliverToBoxAdapter(child: _HeroSection()),
          // Category grid
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 40 : 20,
              vertical: 24,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 4 : 2,
                mainAxisExtent: 160,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = ToolCategory.values[index];
                  return _CategoryCard(category: category);
                },
                childCount: ToolCategory.values.length,
              ),
            ),
          ),
          // Stats bar
          SliverToBoxAdapter(
            child: _StatsBar(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 24,
        vertical: isWide ? 48 : 32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Logo
                SvgPicture.asset(
                  'assets/images/hackers_logo.svg',
                  height: 56,
                  width: 80,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HACKERS',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: 4,
                        ),
                      ),
                      const Text(
                        'OFFLINE SECURITY TOOLKIT',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search button
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    barrierColor: Colors.black.withValues(alpha: 0.7),
                    builder: (_) => const SearchOverlay(),
                  ),
                  icon:
                      const Icon(Icons.search, color: AppColors.textSecondary),
                  tooltip: 'Search tools',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '┌─ welcome ──────────────────────────────┐',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '│  350+ offline cybersecurity tools       │',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const Text(
            '│  15 categories  ·  no internet required │',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const Text(
            '└──────────────────────────────────────────┘',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final ToolCategory category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final color = cat.color;
    final count = ToolsRegistry.countByCategory(cat);
    final availableCount = ToolsRegistry.countAvailableByCategory(cat);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _hovered ? color.withValues(alpha: 0.1) : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? color.withValues(alpha: 0.6) : AppColors.border,
            width: _hovered ? 1.5 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.go('/category/${cat.name}'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(cat.icon, size: 20, color: color),
                      ),
                      const Spacer(),
                      Text(
                        '$availableCount/$count',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          color: _hovered ? color : AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
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
                  const Spacer(),
                  // Color accent bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 2,
                    width: _hovered ? double.infinity : 24,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: _hovered ? 0.8 : 0.4),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalTools = ToolsRegistry.all.length;
    final availableTools = ToolsRegistry.available().length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(value: '$totalTools', label: 'TOTAL TOOLS'),
          const _Divider(),
          _Stat(
              value: '$availableTools',
              label: 'AVAILABLE',
              color: AppColors.accent),
          const _Divider(),
          _Stat(value: '${ToolCategory.values.length}', label: 'CATEGORIES'),
          const _Divider(),
          const _Stat(
              value: 'OFFLINE', label: 'MODE', color: AppColors.success),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _Stat({required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 9,
            color: AppColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.border,
    );
  }
}
