import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';
import '../services/aes_service.dart';

class AesToolWidget extends ConsumerStatefulWidget {
  const AesToolWidget({super.key});

  @override
  ConsumerState<AesToolWidget> createState() => _AesToolWidgetState();
}

class _AesToolWidgetState extends ConsumerState<AesToolWidget> {
  final _inputController = TextEditingController();
  final _passwordController = TextEditingController();
  String _mode = 'CBC';
  bool _encrypt = true;
  String _result = '';
  String _error = '';
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _execute() async {
    if (_inputController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() { _isLoading = true; _result = ''; _error = ''; });
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      String r;
      if (_encrypt) {
        r = _mode == 'CBC'
            ? AesService.encryptCBC(_inputController.text, _passwordController.text)
            : AesService.encryptGCM(_inputController.text, _passwordController.text);
      } else {
        r = _mode == 'CBC'
            ? AesService.decryptCBC(_inputController.text, _passwordController.text)
            : AesService.decryptGCM(_inputController.text, _passwordController.text);
      }
      setState(() { _result = r; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'AES ENCRYPT / DECRYPT',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode selector
            const SectionHeader(title: 'Mode'),
            const SizedBox(height: 8),
            Row(
              children: [
                _ToggleChip(label: 'CBC', selected: _mode == 'CBC', onTap: () => setState(() { _mode = 'CBC'; _result = ''; _error = ''; })),
                const SizedBox(width: 8),
                _ToggleChip(label: 'GCM', selected: _mode == 'GCM', onTap: () => setState(() { _mode = 'GCM'; _result = ''; _error = ''; })),
              ],
            ),
            const SizedBox(height: 16),
            // Operation
            const SectionHeader(title: 'Operation'),
            const SizedBox(height: 8),
            Row(
              children: [
                _ToggleChip(label: '🔒 ENCRYPT', selected: _encrypt, onTap: () => setState(() { _encrypt = true; _result = ''; _error = ''; })),
                const SizedBox(width: 8),
                _ToggleChip(label: '🔓 DECRYPT', selected: !_encrypt, onTap: () => setState(() { _encrypt = false; _result = ''; _error = ''; })),
              ],
            ),
            const SizedBox(height: 16),
            // Password
            SectionHeader(title: _encrypt ? 'Encryption Password' : 'Decryption Password'),
            const SizedBox(height: 8),
            AppInput(
              controller: _passwordController,
              hintText: 'Enter password...',
              obscureText: !_showPassword,
              onChanged: (_) => setState(() { _result = ''; _error = ''; }),
              suffixIcon: IconButton(
                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, size: 18, color: AppColors.textMuted),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(title: _encrypt ? 'Plaintext' : 'Ciphertext (Base64)'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: _encrypt ? 'Enter text to encrypt...' : 'Enter base64 ciphertext...',
              minLines: 3,
              maxLines: 8,
              onChanged: (_) => setState(() { _result = ''; _error = ''; }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: _encrypt ? 'ENCRYPT' : 'DECRYPT',
              icon: _encrypt ? Icons.lock : Icons.lock_open,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _execute,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(content: _error, label: 'ERROR', isError: true),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Result'),
              const SizedBox(height: 8),
              ResultBox(content: _result, label: _encrypt ? 'CIPHERTEXT (BASE64)' : 'DECRYPTED TEXT'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 13, color: AppColors.info),
                    const SizedBox(width: 8),
                    Text(
                      'AES-256-${_mode} · PBKDF2 key derivation · Random salt + IV',
                      style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: AppColors.textSecondary),
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

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGhost : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: selected ? AppColors.accent : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
