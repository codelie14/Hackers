import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';

class BatchPasswordGeneratorWidget extends ConsumerStatefulWidget {
  const BatchPasswordGeneratorWidget({super.key});

  @override
  ConsumerState<BatchPasswordGeneratorWidget> createState() =>
      _BatchPasswordGeneratorWidgetState();
}

class _BatchPasswordGeneratorWidgetState
    extends ConsumerState<BatchPasswordGeneratorWidget> {
  final _countController = TextEditingController(text: '10');
  final _lengthController = TextEditingController(text: '16');
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  List<String> _generatedPasswords = [];

  void _generatePasswords() {
    final count = int.tryParse(_countController.text) ?? 10;
    final length = int.tryParse(_lengthController.text) ?? 16;

    if (count < 1 || count > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Count must be between 1 and 100')),
      );
      return;
    }

    if (length < 4 || length > 128) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Length must be between 4 and 128')),
      );
      return;
    }

    if (!_includeUppercase &&
        !_includeLowercase &&
        !_includeNumbers &&
        !_includeSymbols) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one character type')),
      );
      return;
    }

    String charset = '';
    if (_includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (_includeNumbers) charset += '0123456789';
    if (_includeSymbols) charset += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final random = Random.secure();
    final passwords = <String>[];

    for (int i = 0; i < count; i++) {
      final password = String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => charset.codeUnitAt(random.nextInt(charset.length)),
        ),
      );
      passwords.add(password);
    }

    setState(() {
      _generatedPasswords = passwords;
    });
  }

  void _copyAll() {
    if (_generatedPasswords.isEmpty) return;

    final allPasswords = _generatedPasswords.join('\n');
    Clipboard.setData(ClipboardData(text: allPasswords));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All passwords copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Batch Password Generator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Batch Password Generator',
              subtitle: 'Generate multiple passwords at once',
            ),
            const SizedBox(height: 24),

            // Count input
            AppInput(
              controller: _countController,
              labelText: 'Number of Passwords',
              hintText: 'Enter number (1-100)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Length input
            AppInput(
              controller: _lengthController,
              labelText: 'Password Length',
              hintText: 'Enter length (4-128)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Character type options
            _buildCheckbox(
              'Include Uppercase (A-Z)',
              _includeUppercase,
              (value) => setState(() => _includeUppercase = value ?? false),
            ),
            _buildCheckbox(
              'Include Lowercase (a-z)',
              _includeLowercase,
              (value) => setState(() => _includeLowercase = value ?? false),
            ),
            _buildCheckbox(
              'Include Numbers (0-9)',
              _includeNumbers,
              (value) => setState(() => _includeNumbers = value ?? false),
            ),
            _buildCheckbox(
              'Include Symbols (!@#...)',
              _includeSymbols,
              (value) => setState(() => _includeSymbols = value ?? false),
            ),
            const SizedBox(height: 24),

            // Generate button
            AppButton(
              label: 'Generate Passwords',
              onPressed: _generatePasswords,
            ),

            if (_generatedPasswords.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Generated Passwords:',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_all, size: 20),
                    onPressed: _copyAll,
                    tooltip: 'Copy All',
                    color: AppColors.accent,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _generatedPasswords.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${_generatedPasswords[index]}',
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: _generatedPasswords[index]),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password copied!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            tooltip: 'Copy',
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countController.dispose();
    _lengthController.dispose();
    super.dispose();
  }
}
