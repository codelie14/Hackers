import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/advanced_encoding_service.dart';

class MultiEncoderWidget extends ConsumerStatefulWidget {
  const MultiEncoderWidget({super.key});

  @override
  ConsumerState<MultiEncoderWidget> createState() => _MultiEncoderWidgetState();
}

class _MultiEncoderWidgetState extends ConsumerState<MultiEncoderWidget> {
  String _selectedEncoding = 'html';
  final _inputController = TextEditingController();
  bool _isLoading = false;
  String _result = '';

  final Map<String, String> _encodings = {
    'html': 'HTML Entities',
    'unicode': 'Unicode Escape',
    'xor': 'XOR Cipher',
    'base58': 'Base58',
    'nato': 'NATO Phonetic',
  };

  final _xorKeyController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _xorKeyController.dispose();
    super.dispose();
  }

  void _process() {
    final input = _inputController.text;
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter input text')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        String output;

        switch (_selectedEncoding) {
          case 'html':
            output = AdvancedEncodingService.htmlEncode(input);
            break;
          case 'unicode':
            output = AdvancedEncodingService.unicodeEscape(input);
            break;
          case 'xor':
            final key = _xorKeyController.text.trim();
            if (key.isEmpty) {
              throw ArgumentError('XOR key is required');
            }
            output = AdvancedEncodingService.xorEncode(input, key);
            break;
          case 'base58':
            final bytes = utf8.encode(input);
            output = AdvancedEncodingService.base58Encode(bytes);
            break;
          case 'nato':
            output = AdvancedEncodingService.toNato(input);
            break;
          default:
            throw Exception('Unknown encoding');
        }

        setState(() {
          _result = output;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '${_encodings[_selectedEncoding]?.toUpperCase()} ENCODER',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encoding selector
            const SectionHeader(title: 'Select Encoding'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _encodings.entries.map((entry) {
                final isSelected = _selectedEncoding == entry.key;
                return InkWell(
                  onTap: () => setState(() {
                    _selectedEncoding = entry.key;
                    _result = '';
                  }),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : AppColors.border,
                      ),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.5,
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Input Text'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: 'Enter text to encode...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),

            // XOR Key input
            if (_selectedEncoding == 'xor') ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'XOR Key'),
              const SizedBox(height: 8),
              AppInput(
                controller: _xorKeyController,
                hintText: 'Enter secret key for XOR encryption...',
                maxLines: 1,
                obscureText: true,
              ),
            ],

            const SizedBox(height: 20),
            AppButton(
              label: 'ENCODE ▶',
              icon: Icons.lock,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _process,
            ),

            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Encoded Result',
                subtitle: _encodings[_selectedEncoding],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGhost,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _selectedEncoding.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CopyButton(text: _result),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _result,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_result.length} characters | ${((_result.length / (_inputController.text.length > 0 ? _inputController.text.length : 1)) * 100).toStringAsFixed(1)}% expansion',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
