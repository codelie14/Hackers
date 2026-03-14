import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/tool_model.dart';
import '../../data/tools_registry.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final _controller = TextEditingController();
  List<ToolModel> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _results = ToolsRegistry.search(query);
    });
  }

  void _openTool(ToolModel tool) {
    Navigator.of(context).pop();
    if (tool.routePath != null && tool.isAvailable) {
      context.go(tool.routePath!);
    } else {
      context.go('/category/${tool.category.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 560),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.accent, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: _search,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search tools, categories, tags...',
                        hintStyle: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            // Results
            Expanded(
              child: _results.isEmpty
                  ? _EmptyState(hasQuery: _controller.text.isNotEmpty)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _results.length,
                      itemBuilder: (ctx, i) {
                        final tool = _results[i];
                        return _SearchResultTile(
                          tool: tool,
                          onTap: () => _openTool(tool),
                        );
                      },
                    ),
            ),
            // Footer hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  _KbdHint(text: '↑↓'),
                  const Text(' navigate  ', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'JetBrainsMono')),
                  _KbdHint(text: '↵'),
                  const Text(' open  ', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'JetBrainsMono')),
                  _KbdHint(text: 'ESC'),
                  const Text(' close', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'JetBrainsMono')),
                  const Spacer(),
                  Text(
                    '${_results.length} result${_results.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasQuery;
  const _EmptyState({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasQuery ? Icons.search_off : Icons.search,
            size: 40,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            hasQuery ? 'No tools found' : 'Start typing to search...',
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onTap;

  const _SearchResultTile({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tool.category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(tool.icon, size: 16, color: tool.category.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tool.name,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!tool.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'SOON',
                            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 8, color: AppColors.textMuted),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tool.category.displayName,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: tool.category.color.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              tool.isAvailable ? Icons.arrow_forward_ios : Icons.lock_outline,
              size: 13,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _KbdHint extends StatelessWidget {
  final String text;
  const _KbdHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
