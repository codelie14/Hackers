import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import 'category_drawer.dart';
import 'search_overlay.dart';

const kMobileBreakpoint = 600.0;
const kTabletBreakpoint = 900.0;
const kDesktopBreakpoint = 1200.0;

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final ToolCategory? activeCategory;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'HACKERS',
    this.activeCategory,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useDesktopLayout = width >= kDesktopBreakpoint;
    final useTabletLayout = width >= kTabletBreakpoint && !useDesktopLayout;

    if (useDesktopLayout || useTabletLayout) {
      return _DesktopLayout(
        title: title,
        body: body,
        activeCategory: activeCategory,
        actions: actions,
        floatingActionButton: floatingActionButton,
        showBackButton: showBackButton,
        compact: useTabletLayout,
      );
    }

    return _MobileLayout(
      title: title,
      body: body,
      activeCategory: activeCategory,
      actions: actions,
      floatingActionButton: floatingActionButton,
      showBackButton: showBackButton,
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final ToolCategory? activeCategory;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const _MobileLayout({
    required this.body,
    required this.title,
    this.activeCategory,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => context.pop(),
              )
            : Builder(builder: (ctx) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              }),
        title: Text(title),
        actions: [
          ...(actions ?? []),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: CategoryDrawer(activeCategory: activeCategory),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final ToolCategory? activeCategory;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool compact;

  const _DesktopLayout({
    required this.body,
    required this.title,
    this.activeCategory,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          CategoryDrawer(activeCategory: activeCategory),
          const VerticalDivider(width: 1),
          // Main content
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                leading: showBackButton
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => context.pop(),
                      )
                    : null,
                automaticallyImplyLeading: false,
                title: Text(title),
                actions: [
                  ...(actions ?? []),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _showSearch(context),
                    tooltip: 'Search tools',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      ),
    );
  }
}

void _showSearch(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (_) => const SearchOverlay(),
  );
}
