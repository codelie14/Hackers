import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Base58Widget extends ConsumerStatefulWidget {
  const Base58Widget({super.key});

  @override
  ConsumerState<Base58Widget> createState() => _Base58WidgetState();
}

class _Base58WidgetState extends ConsumerState<Base58Widget> {
  final _controller = TextEditingController();
  String _result = '';
  String _error = '';

  static const String _alphabet =
      '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _encode(List<int> data) {
    if (data.isEmpty) return '';

    int zeros = 0;
    while (zeros < data.length && data[zeros] == 0) zeros++;

    var size = ((data.length - zeros) * 138 ~/ 100) + 1;
    var b58 = List<int>.filled(size, 0);

    for (var i = zeros; i < data.length; i++) {
      var carry = data[i];
      for (var j = size - 1; j >= 0; j--) {
        carry += b58[j] << 8;
        b58[j] = carry % 58;
        carry ~/= 58;
      }
    }

    var start = 0;
    while (start < b58.length && b58[start] == 0) start++;

    final buffer = StringBuffer();
    for (var i = 0; i < zeros; i++) buffer.write(_alphabet[0]);
    for (var i = start; i < b58.length; i++) buffer.write(_alphabet[b58[i]]);

    return buffer.toString();
  }

  List<int> _decode(String encoded) {
    if (encoded.isEmpty) return [];

    int zeros = 0;
    while (zeros < encoded.length && encoded[zeros] == '1') zeros++;

    var size = ((encoded.length - zeros) * 733 ~/ 1000) + 1;
    var bytes = List<int>.filled(size, 0);

    for (var i = zeros; i < encoded.length; i++) {
      var idx = _alphabet.indexOf(encoded[i]);
      if (idx < 0) throw FormatException('Invalid Base58 character');

      var carry = idx;
      for (var j = size - 1; j >= 0; j--) {
        carry += bytes[j] * 58;
        bytes[j] = carry & 0xFF;
        carry >>= 8;
      }
    }

    var start = 0;
    while (start < bytes.length && bytes[start] == 0) start++;

    return [for (var i = 0; i < zeros; i++) 0, ...bytes.sublist(start)];
  }

  void _process() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final text = _controller.text.trim();
      if (text.isEmpty) return;

      // Auto-detect: if all chars are in alphabet, decode
      final isEncoded = text.split('').every((c) => _alphabet.contains(c));

      if (isEncoded) {
        final bytes = _decode(text);
        _result = String.fromCharCodes(bytes);
      } else {
        final bytes = text.codeUnits;
        _result = _encode(bytes);
      }

      setState(() {});
    } catch (e) {
      setState(() => _error = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BASE58',
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
              hintText: 'Enter text to encode or Base58 to decode...',
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
