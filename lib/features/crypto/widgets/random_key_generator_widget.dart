import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class RandomKeyGeneratorWidget extends ConsumerStatefulWidget {
  const RandomKeyGeneratorWidget({super.key});

  @override
  ConsumerState<RandomKeyGeneratorWidget> createState() =>
      _RandomKeyGeneratorWidgetState();
}

class _RandomKeyGeneratorWidgetState
    extends ConsumerState<RandomKeyGeneratorWidget> {
  String _result = '';
  int _keySize = 256;
  bool _includeHex = true;
  final _random = Random.secure();

  void _generate() {
    setState(() => _result = '');

    try {
      final bytes =
          List<int>.generate(_keySize ~/ 8, (_) => _random.nextInt(256));

      final buffer = StringBuffer();
      buffer.writeln('🔑 RANDOM KEY - $_keySize bits\n');
      buffer.writeln();

      if (_includeHex) {
        buffer.writeln('HEX:');
        buffer.writeln(
            bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(''));
        buffer.writeln();
      }

      buffer.writeln('BASE64:');
      buffer.writeln(_bytesToBase64(bytes));
      buffer.writeln();

      buffer.writeln('BYTES (${bytes.length}):');
      buffer.writeln(bytes.join(', '));

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  String _bytesToBase64(List<int> bytes) {
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    var result = '';
    for (var i = 0; i < bytes.length; i += 3) {
      final b1 = bytes[i];
      final b2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b3 = i + 2 < bytes.length ? bytes[i + 2] : 0;

      result += alphabet[(b1 >> 2) & 0x3F];
      result += alphabet[((b1 & 0x03) << 4) | ((b2 & 0xF0) >> 4)];
      result += i + 1 < bytes.length
          ? alphabet[((b2 & 0x0F) << 2) | ((b3 & 0xC0) >> 6)]
          : '=';
      result += i + 2 < bytes.length ? alphabet[b3 & 0x3F] : '=';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'RANDOM KEY GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'KEY SIZE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [256, 512].map((size) {
                final isSelected = _keySize == size;
                return ChoiceChip(
                  label: Text('$size bits'),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _keySize = size),
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
            const SectionHeader(title: 'FORMATS'),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _includeHex,
                  onChanged: (v) => setState(() => _includeHex = v ?? true),
                ),
                const Text('Include Hex',
                    style: TextStyle(fontFamily: 'JetBrainsMono')),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE KEY',
              icon: Icons.casino,
              onPressed: _generate,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'GENERATED KEY',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
