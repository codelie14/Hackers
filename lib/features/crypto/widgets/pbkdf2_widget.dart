import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointycastle/export.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';

class Pbkdf2Widget extends ConsumerStatefulWidget {
  const Pbkdf2Widget({super.key});

  @override
  ConsumerState<Pbkdf2Widget> createState() => _Pbkdf2WidgetState();
}

class _Pbkdf2WidgetState extends ConsumerState<Pbkdf2Widget> {
  final _passwordController = TextEditingController();
  final _saltController = TextEditingController();
  int _iterations = 100000;
  int _keyLength = 32;
  String _prf = 'HMAC-SHA256';
  String _result = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _saltController.dispose();
    super.dispose();
  }

  static Uint8List _pbkdf2(String password, String salt, int iterations, int keyLength, String prf) {
    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(salt);
    final mac = prf == 'HMAC-SHA512'
        ? HMac(SHA512Digest(), 128)
        : HMac(SHA256Digest(), 64);
    final pbkdf2 = PBKDF2KeyDerivator(mac);
    pbkdf2.init(Pbkdf2Parameters(Uint8List.fromList(saltBytes), iterations, keyLength));
    return pbkdf2.process(Uint8List.fromList(passwordBytes));
  }

  Future<void> _derive() async {
    if (_passwordController.text.isEmpty || _saltController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      final bytes = _pbkdf2(_passwordController.text, _saltController.text, _iterations, _keyLength, _prf);
      final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      setState(() { _result = hex; _isLoading = false; });
    } catch (e) {
      setState(() { _result = 'Error: $e'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'PBKDF2 KEY DERIVATION',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Password'),
            const SizedBox(height: 8),
            AppInput(controller: _passwordController, hintText: 'Enter password...', onChanged: (_) => setState(() => _result = '')),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Salt'),
            const SizedBox(height: 8),
            AppInput(controller: _saltController, hintText: 'Enter salt value...', onChanged: (_) => setState(() => _result = '')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'PRF'),
                      const SizedBox(height: 8),
                      _buildDropdown(['HMAC-SHA256', 'HMAC-SHA512'], _prf, (v) => setState(() { _prf = v!; _result = ''; })),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Key Length (bytes)'),
                      const SizedBox(height: 8),
                      _buildDropdown(['16', '24', '32', '48', '64'], '$_keyLength', (v) => setState(() { _keyLength = int.parse(v!); _result = ''; })),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionHeader(title: 'Iterations: $_iterations'),
            Slider(
              value: _iterations.toDouble(),
              min: 1000,
              max: 600000,
              divisions: 599,
              label: _iterations.toString(),
              onChanged: (v) => setState(() { _iterations = v.round(); _result = ''; }),
            ),
            const SizedBox(height: 12),
            AppButton(label: 'DERIVE KEY', icon: Icons.key, isLoading: _isLoading, fullWidth: true, onPressed: _derive),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionHeader(title: 'Derived Key (Hex)'),
              const SizedBox(height: 8),
              ResultBox(content: _result, label: 'PBKDF2 OUTPUT'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      dropdownColor: AppColors.bgElevated,
      style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: AppColors.textPrimary),
      decoration: const InputDecoration(
        filled: true,
        fillColor: AppColors.bgElevated,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
