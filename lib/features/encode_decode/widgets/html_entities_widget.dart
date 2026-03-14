import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class HtmlEntitiesWidget extends ConsumerStatefulWidget {
  const HtmlEntitiesWidget({super.key});

  @override
  ConsumerState<HtmlEntitiesWidget> createState() => _HtmlEntitiesWidgetState();
}

class _HtmlEntitiesWidgetState extends ConsumerState<HtmlEntitiesWidget> {
  final _controller = TextEditingController();
  String _result = '';
  String _error = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _encode(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll('\'', '&#39;')
        .replaceAll(' ', '&nbsp;');
  }

  String _decode(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', '\'')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&copy;', '©')
        .replaceAll('&reg;', '®')
        .replaceAll('&trade;', '™')
        .replaceAll('&euro;', '€')
        .replaceAll('&pound;', '£')
        .replaceAll('&yen;', '¥')
        .replaceAll('&micro;', 'µ')
        .replaceAll('&bull;', '•')
        .replaceAll('&hellip;', '…')
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—');
  }

  void _process() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final text = _controller.text;
      if (text.isEmpty) return;

      // Auto-detect: if contains &, decode; otherwise encode
      final isEncoded = text.contains('&');
      final result = isEncoded ? _decode(text) : _encode(text);

      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HTML ENTITIES',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _controller,
              hintText: 'Enter text to encode/decode HTML entities...',
              minLines: 3,
              maxLines: 8,
              onChanged: (_) => setState(() {
                _result = '';
                _error = '';
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'ENCODE / DECODE',
              icon: Icons.swap_horiz,
              onPressed: _process,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(content: _error, isError: true),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'RESULT',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
