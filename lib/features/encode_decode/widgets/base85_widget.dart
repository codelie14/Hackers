import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Base85Widget extends ConsumerStatefulWidget {
  const Base85Widget({super.key});

  @override
  ConsumerState<Base85Widget> createState() => _Base85WidgetState();
}

class _Base85WidgetState extends ConsumerState<Base85Widget> {
  final _inputController = TextEditingController();
  String _mode = 'encode';
  String _result = '';

  final List<String> _modes = [
    'Encode → Base85',
    'Decode ← Base85',
  ];

  // Standard Base85 alphabet (RFC 1924)
  static const String _alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#\$%&()*+-.<=>?@^_`{|}~';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Uint8List _stringToBytes(String input) {
    return Uint8List.fromList(utf8.encode(input));
  }

  String _bytesToString(Uint8List bytes) {
    return utf8.decode(bytes);
  }

  String _encodeBase85(String input) {
    try {
      final bytes = _stringToBytes(input);
      final buffer = StringBuffer();

      // Pad to multiple of 4
      var padding = 0;
      if (bytes.length % 4 != 0) {
        padding = 4 - (bytes.length % 4);
      }

      final paddedBytes = Uint8List(bytes.length + padding);
      paddedBytes.setAll(0, bytes);

      // Encode 4 bytes at a time into 5 Base85 characters
      for (var i = 0; i < paddedBytes.length; i += 4) {
        final value = ((paddedBytes[i] & 0xFF) << 24) |
            ((paddedBytes[i + 1] & 0xFF) << 16) |
            ((paddedBytes[i + 2] & 0xFF) << 8) |
            (paddedBytes[i + 3] & 0xFF);

        // Convert to 5 Base85 digits
        for (var j = 4; j >= 0; j--) {
          final index = (value ~/ pow(85, j)) % 85;
          buffer.write(_alphabet[index]);
        }
      }

      // Remove padding characters from output
      var result = buffer.toString();
      if (padding > 0) {
        result = result.substring(0, result.length - padding);
      }

      return result;
    } catch (e) {
      throw Exception('Encoding failed: ${e.toString()}');
    }
  }

  int pow(int base, int exp) {
    var result = 1;
    for (var i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  String _decodeBase85(String input) {
    try {
      final buffer = BytesBuilder();

      // Add padding if needed
      var paddedInput = input;
      final padding = (4 - (input.length % 4)) % 4;
      paddedInput += '~' * padding; // Use last char as padding

      // Decode 5 Base85 characters at a time into 4 bytes
      for (var i = 0; i < paddedInput.length; i += 5) {
        var value = 0;

        for (var j = 0; j < 5; j++) {
          final char = paddedInput[i + j];
          final index = _alphabet.indexOf(char);
          if (index == -1 && char != '~') {
            throw Exception('Invalid Base85 character: $char');
          }
          final digit = index == -1 ? 0 : index;
          value = value * 85 + digit;
        }

        // Extract 4 bytes
        buffer.addByte((value >> 24) & 0xFF);
        buffer.addByte((value >> 16) & 0xFF);
        buffer.addByte((value >> 8) & 0xFF);
        buffer.addByte(value & 0xFF);
      }

      final bytes = buffer.toBytes();

      // Remove padding bytes
      final actualLength = bytes.length - padding;
      final result = bytes.sublist(0, actualLength);

      return _bytesToString(result);
    } catch (e) {
      throw Exception('Decoding failed: ${e.toString()}');
    }
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter text to convert');
      return;
    }

    try {
      String output;

      if (_mode == 'encode') {
        output = _encodeBase85(input);
      } else {
        output = _decodeBase85(input);
      }

      final buffer = StringBuffer();
      buffer.writeln('BASE85 CONVERSION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      if (_mode == 'encode') {
        buffer.writeln('INPUT (Original Text)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n');
        buffer.writeln('Length: ${input.length} characters\n\n');

        buffer.writeln('OUTPUT (Base85 Encoded)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n');
        buffer.writeln('Length: ${output.length} characters\n\n');

        buffer.writeln('COMPRESSION RATIO');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        final ratio = (output.length / input.length) * 100;
        buffer.writeln('${ratio.toStringAsFixed(1)}% of original size\n');
        buffer.writeln('Expansion: +${(ratio - 100).toStringAsFixed(1)}%\n\n');

        buffer.writeln('USAGE');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('• More efficient than Base64 (~25% smaller)\n');
        buffer.writeln('• Used in PDF, PostScript, Git\n');
        buffer.writeln('• Safe for binary data transmission\n');
      } else {
        buffer.writeln('INPUT (Base85 Encoded)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n');
        buffer.writeln('Length: ${input.length} characters\n\n');

        buffer.writeln('OUTPUT (Decoded Text)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n');
        buffer.writeln('Length: ${output.length} characters\n\n');

        buffer.writeln('VALIDATION');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('✓ Valid Base85 format\n');
        buffer.writeln('✓ Successfully decoded\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BASE85 CONVERTER',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'MODE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modes.map((mode) {
                final isSelected = mode == _mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _mode = mode;
                      _result = '';
                      _inputController.clear();
                    });
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _inputController,
              hintText: _mode == 'encode'
                  ? 'Enter text to encode...'
                  : 'Enter Base85 encoded string...',
              maxLines: 5,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: Icon(
                    _mode == 'encode' ? Icons.arrow_forward : Icons.arrow_back),
                label: Text(_mode == 'encode'
                    ? 'ENCODE TO BASE85'
                    : 'DECODE FROM BASE85'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CONVERSION RESULT',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
