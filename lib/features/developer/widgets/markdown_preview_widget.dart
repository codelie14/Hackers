import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class MarkdownPreviewWidget extends ConsumerStatefulWidget {
  const MarkdownPreviewWidget({super.key});

  @override
  ConsumerState<MarkdownPreviewWidget> createState() =>
      _MarkdownPreviewWidgetState();
}

class _MarkdownPreviewWidgetState extends ConsumerState<MarkdownPreviewWidget> {
  final _controller = TextEditingController();
  bool _showPreview = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'MARKDOWN PREVIEW',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Editor'),
                    selected: !_showPreview,
                    onSelected: (selected) {
                      if (selected) setState(() => _showPreview = false);
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: !_showPreview
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color:
                          !_showPreview ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Preview'),
                    selected: _showPreview,
                    onSelected: (selected) {
                      if (selected) setState(() => _showPreview = true);
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0x2000FF88),
                    labelStyle: TextStyle(
                      color: _showPreview
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color: _showPreview ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _showPreview ? _buildPreview() : _buildEditor(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'MARKDOWN'),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText:
                    '# Enter Markdown here...\n\n**Bold**, *italic*, `code`, [links](url)\n\n- Lists\n- Bullet points\n- More markdown!',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final markdownData = _controller.text.isEmpty
        ? '# Markdown Preview\n\nStart typing in the **Editor** tab to see live preview.\n\n## Features\n\n- **Bold text**\n- *Italic text*\n- `Inline code`\n- [Links](https://example.com)\n\n```dart\n// Code blocks\nvoid main() {\n  print(\'Hello World\');\n}\n```\n\n> Blockquotes\n\n- List items\n- More items\n- Even more'
        : _controller.text;

    return Markdown(
      data: markdownData,
      padding: const EdgeInsets.all(16),
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.accent, width: 3)),
        ),
        codeblockDecoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(6),
        ),
        code: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
          color: AppColors.accent,
        ),
        p: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        h1: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
        ),
        h2: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        h3: const TextStyle(
          fontFamily: 'Syne',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
