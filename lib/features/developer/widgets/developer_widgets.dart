import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/code_display.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';
import '../services/developer_service.dart';

// ── JSON Formatter ────────────────────────────────────────────────────────────

class JsonFormatterWidget extends ConsumerStatefulWidget {
  const JsonFormatterWidget({super.key});

  @override
  ConsumerState<JsonFormatterWidget> createState() => _JsonFormatterWidgetState();
}

class _JsonFormatterWidgetState extends ConsumerState<JsonFormatterWidget> {
  final _ctrl = TextEditingController();
  String _result = '';
  String _error = '';
  int _indent = 2;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _format() {
    setState(() { _error = ''; });
    try {
      final r = DeveloperService.formatJson(_ctrl.text, indent: _indent);
      setState(() => _result = r);
    } catch (e) {
      setState(() { _error = 'Invalid JSON: ${e.toString().replaceFirst('FormatException: ', '')}'; });
    }
  }

  void _minify() {
    setState(() { _error = ''; });
    try {
      final r = DeveloperService.minifyJson(_ctrl.text);
      setState(() => _result = r);
    } catch (e) {
      setState(() { _error = 'Invalid JSON: ${e.toString().replaceFirst('FormatException: ', '')}'; });
    }
  }

  void _validate() {
    try {
      jsonDecode(_ctrl.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ Valid JSON'), backgroundColor: AppColors.success, duration: Duration(seconds: 2)),
      );
    } catch (e) {
      setState(() => _error = 'Invalid: ${e.toString().replaceFirst('FormatException: ', '')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'JSON FORMATTER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const SectionHeader(title: 'Indent'),
              const Spacer(),
              ...([2, 4]).map((n) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () => setState(() => _indent = n),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _indent == n ? AppColors.accentGhost : AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _indent == n ? AppColors.accent : AppColors.border),
                    ),
                    child: Text('$n spaces', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: _indent == n ? AppColors.accent : AppColors.textMuted)),
                  ),
                ),
              )),
            ]),
            const SizedBox(height: 8),
            AppTextArea(controller: _ctrl, hintText: 'Paste JSON here...', minLines: 6, maxLines: 12,
                onChanged: (_) => setState(() { _result = ''; _error = ''; })),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppButton(label: 'FORMAT', icon: Icons.format_align_left, onPressed: _format)),
              const SizedBox(width: 8),
              Expanded(child: AppButton(label: 'MINIFY', icon: Icons.compress, onPressed: _minify, variant: AppButtonVariant.secondary)),
              const SizedBox(width: 8),
              Expanded(child: AppButton(label: 'VALIDATE', icon: Icons.check_circle_outline, onPressed: _validate, variant: AppButtonVariant.ghost)),
            ]),
            if (_error.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: _error, isError: true)],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Result'),
              const SizedBox(height: 8),
              CodeDisplay(code: _result, language: 'json', label: 'JSON'),
            ],
          ],
        ),
      ),
    );
  }
}

// ── UUID Generator ────────────────────────────────────────────────────────────

class UuidGeneratorWidget extends ConsumerStatefulWidget {
  const UuidGeneratorWidget({super.key});

  @override
  ConsumerState<UuidGeneratorWidget> createState() => _UuidGeneratorWidgetState();
}

class _UuidGeneratorWidgetState extends ConsumerState<UuidGeneratorWidget> {
  int _version = 4;
  int _count = 1;
  List<String> _uuids = [];

  void _generate() {
    setState(() {
      _uuids = DeveloperService.generateUuids(_count, version: _version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'UUID GENERATOR',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionHeader(title: 'Version'),
                const SizedBox(height: 8),
                Row(children: [
                  _VerChip(label: 'v1', value: 1, selected: _version == 1, onTap: () => setState(() { _version = 1; _uuids = []; })),
                  const SizedBox(width: 8),
                  _VerChip(label: 'v4', value: 4, selected: _version == 4, onTap: () => setState(() { _version = 4; _uuids = []; })),
                ]),
              ])),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SectionHeader(title: 'Count: $_count'),
                Slider(value: _count.toDouble(), min: 1, max: 20, divisions: 19, label: '$_count',
                  onChanged: (v) => setState(() { _count = v.round(); _uuids = []; })),
              ])),
            ]),
            const SizedBox(height: 12),
            AppButton(label: 'GENERATE UUID${_count > 1 ? 's' : ''}', icon: Icons.generating_tokens, fullWidth: true, onPressed: _generate),
            if (_uuids.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionHeader(title: 'Generated UUIDs'),
              const SizedBox(height: 8),
              ..._uuids.map((uuid) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Expanded(child: SelectableText(uuid, style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, color: AppColors.textPrimary))),
                  CopyButton(text: uuid),
                ]),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _VerChip extends StatelessWidget {
  final String label;
  final int value;
  final bool selected;
  final VoidCallback onTap;
  const _VerChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext c) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(6),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.accentGhost : AppColors.bgElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: selected ? AppColors.accent : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13, color: selected ? AppColors.accent : AppColors.textSecondary, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
    ),
  );
}

// ── Needed import for CopyButton
class CopyButton extends StatefulWidget {
  final String text;
  const CopyButton({super.key, required this.text});
  @override
  State<CopyButton> createState() => _CopyButtonState();
}
class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;
  @override
  Widget build(BuildContext context) => IconButton(
    icon: AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(_copied ? Icons.check : Icons.copy_outlined, key: ValueKey(_copied), size: 18, color: _copied ? AppColors.accent : AppColors.textSecondary),
    ),
    onPressed: () async {
      // Use ClipboardUtils from shared
      setState(() => _copied = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _copied = false);
    },
    padding: const EdgeInsets.all(4),
    constraints: const BoxConstraints(),
  );
}
