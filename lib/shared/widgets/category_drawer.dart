import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';
import '../../core/services/history_service.dart';
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
              children: [
                // History section (if history exists)
                FutureBuilder<List<HistoryEntry>>(
                  future: HistoryService.getHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return _HistorySection(history: snapshot.data!);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Categories
                ...ToolCategory.values.map((category) {
                  return _CategoryTile(
                    category: category,
                    isActive: activeCategory == category,
                    onTap: () {
                      if (!isInline) Navigator.of(context).pop();
                      context.go('/category/${category.name}');
                    },
                  );
                }),
              ],
            ),
          ),
          // Footer
          const _DrawerFooter(),
        ],
      ),
    );

    if (isInline) return content;
    return Drawer(
        width: 280, backgroundColor: AppColors.bgSurface, child: content);
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
                border: Border.all(
                    color: AppColors.accentDim.withValues(alpha: 0.4)),
              ),
              child:
                  const Icon(Icons.security, color: AppColors.accent, size: 20),
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
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
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
            const Icon(Icons.info_outline,
                size: 14, color: AppColors.textMuted),
            const SizedBox(width: 8),
            const Text(
              'v1.1.0  ·  IndraLabs',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.help_outline,
                  size: 18, color: AppColors.textSecondary),
              onPressed: () => _showHelpDialog(context),
              tooltip: 'Help',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  size: 18, color: AppColors.textSecondary),
              onPressed: () => _showSettingsDialog(context),
              tooltip: 'Settings',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline,
                  size: 18, color: AppColors.textSecondary),
              onPressed: () => _showAboutDialog(context),
              tooltip: 'About',
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '💡 HELP & GUIDE',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
            letterSpacing: 1,
          ),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🚀 GETTING STARTED',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Browse categories from the home screen\n'
                '2. Select a tool to use it\n'
                '3. Recent tools appear in this menu\n'
                '4. All tools work offline - no internet required',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '📚 FEATURES',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• 50+ cybersecurity tools\n'
                '• Password generator with history\n'
                '• Cryptographic hash functions\n'
                '• Encode/decode utilities\n'
                '• QR code analyzer & designer\n'
                '• Developer tools (JSON, SQL, etc.)',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '🔒 PRIVACY',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'All computations are performed locally on your device.\n'
                'No data is sent to external servers.\n'
                'Password history is encrypted using Android Keystore/iOS Keychain.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('GOT IT', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '⚙️ SETTINGS',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
            letterSpacing: 1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'APPEARANCE',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.dark_mode,
                  size: 20, color: AppColors.textSecondary),
              title: const Text(
                'Dark Terminal Theme',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: AppColors.textSecondary),
              ),
              subtitle: const Text(
                'Always on (default theme)',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textMuted),
              ),
              enabled: false,
            ),
            const Divider(height: 24),
            const Text(
              'HISTORY',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.history,
                  size: 20, color: AppColors.textSecondary),
              title: const Text(
                'Clear Recent Tools',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: AppColors.textSecondary),
              ),
              subtitle: const Text(
                'Remove all history entries',
                style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textMuted),
              ),
              onTap: () async {
                await HistoryService.clearHistory();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('History cleared',
                          style: TextStyle(fontFamily: 'JetBrainsMono')),
                      backgroundColor: AppColors.bgElevated,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('CLOSE', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentGhost,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.security, color: AppColors.accent, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HACKERS',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
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
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Version 1.1.0-beta',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A comprehensive collection of 50+ offline cybersecurity and developer tools.',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FEATURES:',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 🔐 Cryptography & Hashing\n'
              '• 🔑 Password Generation\n'
              '• 📝 Encode/Decode\n'
              '• 💻 Developer Tools\n'
              '• 📱 QR Code & Barcode\n'
              '• 🌐 Network Utilities',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                color: AppColors.textSecondary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Built with ❤️ by IndraLabs',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('CLOSE', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
// HISTORY SECTION
// ────────────────────────────────────────────────────────────

class _HistorySection extends StatelessWidget {
  final List<HistoryEntry> history;

  const _HistorySection({required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.history, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 8),
              const Text(
                'RECENT TOOLS',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              if (history.length > 3)
                Text(
                  '${history.length} items',
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        // History items (show max 3-5)
        ...history.take(5).map((entry) => _HistoryTile(entry: entry)),
        // Divider before categories
        const Divider(height: 24),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final HistoryEntry entry;

  const _HistoryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: AppColors.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // Navigate to tool
            final allTools = ToolsRegistry.all;
            final tool = allTools.firstWhere(
              (t) => t.id == entry.toolId,
              orElse: () => throw Exception('Tool not found'),
            );
            if (tool.isAvailable && tool.routePath != null) {
              Navigator.of(context).pop();
              context.go(tool.routePath!);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.history_toggle_off,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.toolName,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Time ago
                Text(
                  _timeAgo(entry.timestamp),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
