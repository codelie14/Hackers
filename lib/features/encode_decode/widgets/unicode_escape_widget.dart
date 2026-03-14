import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class UnicodeEscapeWidget extends ConsumerStatefulWidget {
  const UnicodeEscapeWidget({super.key});

  @override
  ConsumerState<UnicodeEscapeWidget> createState() =>
      _UnicodeEscapeWidgetState();
}

class _UnicodeEscapeWidgetState extends ConsumerState<UnicodeEscapeWidget> {
  final _controller = TextEditingController();
  String _result = '';
  String _error = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _encode(String input) {
    final buffer = StringBuffer();
    for (final unit in input.runes) {
      if (unit < 128) {
        buffer.writeCharCode(unit);
      } else {
        buffer.write('\\u${unit.toRadixString(16).padLeft(4, '0')}');
      }
    }
    return buffer.toString();
  }

  String _decode(String input) {
    return input.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );
  }

  void _process() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final text = _controller.text;
      if (text.isEmpty) return;

      final isEncoded = text.contains('\\u');
      final result = isEncoded ? _decode(text) : _encode(text);

      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'UNICODE ESCAPE',
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
              hintText: 'Enter text to encode/decode Unicode escapes...',
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
              ResultBox(content: _result, label: 'RESULT'),
            ],
          ],
        ),
      ),
    );
  }
}
