import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class CrcChecksumWidget extends ConsumerStatefulWidget {
  const CrcChecksumWidget({super.key});

  @override
  ConsumerState<CrcChecksumWidget> createState() => _CrcChecksumWidgetState();
}

class _CrcChecksumWidgetState extends ConsumerState<CrcChecksumWidget> {
  final _controller = TextEditingController();
  String _result = '';
  String _selectedType = 'CRC32';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _crc16(String input) {
    var crc = 0xFFFF;
    for (var i = 0; i < input.length; i++) {
      crc ^= input.codeUnitAt(i);
      for (var j = 0; j < 8; j++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ 0xA001;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc & 0xFFFF;
  }

  int _crc32(String input) {
    var crc = 0xFFFFFFFF;
    for (var i = 0; i < input.length; i++) {
      crc ^= input.codeUnitAt(i);
      for (var j = 0; j < 8; j++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ 0xEDB88320;
        } else {
          crc >>= 1;
        }
      }
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }

  int _crc64(String input) {
    var crc = BigInt.from(0xFFFFFFFFFFFFFFFF);
    final poly = BigInt.from(0xC96C5795D7870F42);

    for (var i = 0; i < input.length; i++) {
      crc ^= BigInt.from(input.codeUnitAt(i));
      for (var j = 0; j < 8; j++) {
        if ((crc & BigInt.one) != BigInt.zero) {
          crc = (crc >> 1) ^ poly;
        } else {
          crc >>= 1;
        }
      }
    }
    return (crc ^ BigInt.from(0xFFFFFFFFFFFFFFFF)).toUnsigned(64).toInt();
  }

  void _calculate() {
    setState(() {
      _result = '';
    });

    try {
      final text = _controller.text;
      if (text.isEmpty) {
        setState(() => _result = 'Please enter text');
        return;
      }

      int crcValue;
      switch (_selectedType) {
        case 'CRC16':
          crcValue = _crc16(text);
          break;
        case 'CRC64':
          crcValue = _crc64(text);
          break;
        default:
          crcValue = _crc32(text);
      }

      final hexValue = crcValue.toRadixString(16).toUpperCase().padLeft(
            _selectedType == 'CRC16' ? 4 : (_selectedType == 'CRC64' ? 16 : 8),
            '0',
          );

      setState(() {
        _result = '$_selectedType: 0x$hexValue\nDecimal: $crcValue';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CRC CHECKSUM',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'CRC TYPE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['CRC16', 'CRC32', 'CRC64'].map((type) {
                final isSelected = type == _selectedType;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedType = type),
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
            AppTextArea(
              controller: _controller,
              hintText: 'Enter text to calculate CRC checksum...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => setState(() {
                _result = '';
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'CALCULATE CRC',
              icon: Icons.calculate,
              onPressed: _calculate,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CHECKSUM',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
