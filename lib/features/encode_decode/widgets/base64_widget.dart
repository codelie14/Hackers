import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';
import '../services/encode_decode_service.dart';

class Base64Widget extends ConsumerStatefulWidget {
  const Base64Widget({super.key});

  @override
  ConsumerState<Base64Widget> createState() => _Base64WidgetState();
}

class _Base64WidgetState extends ConsumerState<Base64Widget> {
  final _controller = TextEditingController();
  bool _urlSafe = false;
  String _encoded = '';
  String _decoded = '';
  String _error = '';

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _encode() {
    setState(() { _error = ''; _decoded = ''; });
    try {
      final r = EncodeDecodeService.encodeBase64(_controller.text, urlSafe: _urlSafe);
      setState(() => _encoded = r);
    } catch (e) { setState(() => _error = e.toString()); }
  }

  void _decode() {
    setState(() { _error = ''; _encoded = ''; });
    try {
      final r = EncodeDecodeService.decodeBase64(_controller.text);
      setState(() => _decoded = r);
    } catch (e) { setState(() => _error = e.toString()); }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BASE64',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SectionHeader(title: 'URL-Safe'),
                const Spacer(),
                Switch(value: _urlSafe, onChanged: (v) => setState(() => _urlSafe = v)),
              ],
            ),
            const SizedBox(height: 8),
            const SectionHeader(title: 'Input'),
            const SizedBox(height: 8),
            AppTextArea(controller: _controller, hintText: 'Enter text or Base64...', minLines: 3, maxLines: 8,
                onChanged: (_) => setState(() { _encoded = ''; _decoded = ''; _error = ''; })),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppButton(label: 'ENCODE', icon: Icons.arrow_downward, onPressed: _encode)),
                const SizedBox(width: 10),
                Expanded(child: AppButton(label: 'DECODE', icon: Icons.arrow_upward, onPressed: _decode, variant: AppButtonVariant.secondary)),
              ],
            ),
            if (_error.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: _error, isError: true)],
            if (_encoded.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: _encoded, label: 'BASE64 ENCODED')],
            if (_decoded.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: _decoded, label: 'DECODED TEXT')],
          ],
        ),
      ),
    );
  }
}
