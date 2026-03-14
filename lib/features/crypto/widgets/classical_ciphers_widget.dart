import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/classical_ciphers_service.dart';

class ClassicalCiphersWidget extends ConsumerStatefulWidget {
  const ClassicalCiphersWidget({super.key});

  @override
  ConsumerState<ClassicalCiphersWidget> createState() => _ClassicalCiphersWidgetState();
}

class _ClassicalCiphersWidgetState extends ConsumerState<ClassicalCiphersWidget> {
  String _selectedCipher = 'caesar';
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  int _shiftValue = 3;
  int _affineA = 5;
  int _affineB = 8;
  int _railFenceRails = 3;
  
  String _result = '';
  bool _encryptMode = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _processCipher() {
    final input = _inputController.text.trim();
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
        
        switch (_selectedCipher) {
          case 'caesar':
            output = _encryptMode 
                ? ClassicalCiphersService.caesarEncrypt(input, _shiftValue)
                : ClassicalCiphersService.caesarDecrypt(input, _shiftValue);
            break;
            
          case 'vigenere':
            final key = _keyController.text.trim();
            if (key.isEmpty) {
              throw ArgumentError('Key required for Vigenère cipher');
            }
            output = _encryptMode
                ? ClassicalCiphersService.vigenereEncrypt(input, key)
                : ClassicalCiphersService.vigenereDecrypt(input, key);
            break;
            
          case 'atbash':
            output = ClassicalCiphersService.atbash(input);
            break;
            
          case 'affine':
            output = _encryptMode
                ? ClassicalCiphersService.affineEncrypt(input, _affineA, _affineB)
                : ClassicalCiphersService.affineDecrypt(input, _affineA, _affineB);
            break;
            
          case 'railfence':
            output = _encryptMode
                ? ClassicalCiphersService.railFenceEncrypt(input, _railFenceRails)
                : ClassicalCiphersService.railFenceDecrypt(input, _railFenceRails);
            break;
            
          default:
            throw Exception('Unknown cipher');
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
      title: 'CLASSICAL CIPHERS',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cipher selector
            const SectionHeader(title: 'Select Cipher'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CipherChip(label: 'Caesar', value: 'caesar', selected: _selectedCipher),
                _CipherChip(label: 'Vigenère', value: 'vigenere', selected: _selectedCipher),
                _CipherChip(label: 'Atbash', value: 'atbash', selected: _selectedCipher),
                _CipherChip(label: 'Affine', value: 'affine', selected: _selectedCipher),
                _CipherChip(label: 'Rail Fence', value: 'railfence', selected: _selectedCipher),
              ],
            ),

            const SizedBox(height: 20),

            // Mode toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _encryptMode = true;
                        _result = '';
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _encryptMode ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Center(
                          child: Text(
                            'ENCRYPT',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _encryptMode = false;
                        _result = '';
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_encryptMode ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Center(
                          child: Text(
                            'DECRYPT',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Input Text'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: 'Enter text to process...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),

            // Cipher-specific parameters
            if (_selectedCipher == 'caesar') ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Shift Value'),
              const SizedBox(height: 8),
              _ShiftSlider(
                value: _shiftValue,
                onChanged: (value) {
                  setState(() {
                    _shiftValue = value;
                    _result = '';
                  });
                },
              ),
            ] else if (_selectedCipher == 'vigenere') ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Key'),
              const SizedBox(height: 8),
              AppInput(
                controller: _keyController,
                hintText: 'Enter encryption key (letters only)...',
                maxLines: 1,
                onChanged: (_) {
                  if (_result.isNotEmpty) setState(() => _result = '');
                },
              ),
            ] else if (_selectedCipher == 'affine') ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Affine Parameters'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      hintText: 'a = $_affineA',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        onPressed: () {
                          setState(() {
                            _affineA = [5, 7, 9, 11, 15, 17, 19, 21, 23, 25][DateTime.now().millisecond % 10];
                            _result = '';
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppInput(
                      hintText: 'b = $_affineB',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh, size: 18),
                        onPressed: () {
                          setState(() {
                            _affineB = DateTime.now().second % 26;
                            _result = '';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (_selectedCipher == 'railfence') ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Number of Rails'),
              const SizedBox(height: 8),
              _RailSlider(
                value: _railFenceRails,
                onChanged: (value) {
                  setState(() {
                    _railFenceRails = value;
                    _result = '';
                  });
                },
              ),
            ],

            const SizedBox(height: 20),
            AppButton(
              label: _encryptMode ? 'ENCRYPT ▶' : 'DECRYPT ▶',
              icon: _selectedCipher == 'atbash' ? Icons.sync : (_encryptMode ? Icons.lock : Icons.lock_open),
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _processCipher,
            ),

            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: _encryptMode ? 'Encrypted Result' : 'Decrypted Result',
                subtitle: _selectedCipher.toUpperCase(),
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
                            _selectedCipher.toUpperCase(),
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
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _CipherChip({required String label, required String value, required String selected}) {
    final isSelected = selected == value;
    return InkWell(
      onTap: () => setState(() {
        _selectedCipher = value;
        _result = '';
        _keyController.clear();
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
          label,
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
  }
}

class _ShiftSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _ShiftSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shift:',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.accent,
              overlayColor: AppColors.accentGhost,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 25,
              divisions: 24,
              label: '$value',
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _RailSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rails:',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.accent,
              overlayColor: AppColors.accentGhost,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: '$value',
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
