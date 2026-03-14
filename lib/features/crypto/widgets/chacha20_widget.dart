import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/chacha20_service.dart';

class ChaCha20Widget extends ConsumerStatefulWidget {
  const ChaCha20Widget({super.key});

  @override
  ConsumerState<ChaCha20Widget> createState() => _ChaCha20WidgetState();
}

class _ChaCha20WidgetState extends ConsumerState<ChaCha20Widget> {
  final _plaintextController = TextEditingController();
  final _keyController = TextEditingController();
  final _nonceController = TextEditingController();
  final _ciphertextController = TextEditingController();
  final _macController = TextEditingController();
  
  bool _encryptMode = true;
  bool _isLoading = false;
  String? _error;
  Map<String, String> _result = {};

  @override
  void dispose() {
    _plaintextController.dispose();
    _keyController.dispose();
    _nonceController.dispose();
    _ciphertextController.dispose();
    _macController.dispose();
    super.dispose();
  }

  Future<void> _processChaCha20() async {
    if (_encryptMode) {
      await _encrypt();
    } else {
      await _decrypt();
    }
  }

  Future<void> _encrypt() async {
    final plaintext = _plaintextController.text.trim();
    var key = _keyController.text.trim();
    final nonce = _nonceController.text.trim();

    if (plaintext.isEmpty) {
      setState(() => _error = 'Please enter plaintext');
      return;
    }

    // Generate key if empty
    if (key.isEmpty) {
      key = ChaCha20Service.generateKey();
      _keyController.text = key;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = {};
    });

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final result = await ChaCha20Service.encrypt(plaintext, key, nonceHex: nonce.isNotEmpty ? nonce : null);
      
      if (result['success'] == 'true') {
        setState(() {
          _result = result;
          // Update nonce controller with generated nonce
          if (nonce.isEmpty && result.containsKey('nonce')) {
            _nonceController.text = result['nonce']!;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['error'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _decrypt() async {
    final ciphertext = _ciphertextController.text.trim();
    final key = _keyController.text.trim();
    final nonce = _nonceController.text.trim();
    final mac = _macController.text.trim();

    if (ciphertext.isEmpty || key.isEmpty || nonce.isEmpty || mac.isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = {};
    });

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final result = await ChaCha20Service.decrypt(ciphertext, key, nonce, mac);
      
      if (result['success'] == 'true') {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['error'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _generateKey() {
    final key = ChaCha20Service.generateKey();
    _keyController.text = key;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CHACHA20-POLY1305',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode switcher
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
                        _result = {};
                        _error = null;
                        _ciphertextController.clear();
                        _macController.clear();
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
                        _result = {};
                        _error = null;
                        _plaintextController.clear();
                        _nonceController.clear();
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
            SectionHeader(title: _encryptMode ? 'Encryption' : 'Decryption'),
            const SizedBox(height: 8),

            if (_encryptMode) ...[
              AppTextArea(
                controller: _plaintextController,
                hintText: 'Enter plaintext to encrypt...',
                minLines: 3,
                maxLines: 6,
                onChanged: (_) {
                  if (_result.isNotEmpty || _error != null) {
                    setState(() {
                      _result = {};
                      _error = null;
                    });
                  }
                },
              ),
            ] else ...[
              AppTextArea(
                controller: _ciphertextController,
                hintText: 'Enter ciphertext (hex)...',
                minLines: 3,
                maxLines: 6,
                onChanged: (_) {
                  if (_result.isNotEmpty || _error != null) {
                    setState(() {
                      _result = {};
                      _error = null;
                    });
                  }
                },
              ),
            ],

            const SizedBox(height: 16),
            const SectionHeader(title: 'Secret Key (256-bit / 64 hex chars)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: _keyController,
                    hintText: 'Leave empty to auto-generate',
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'GEN',
                  icon: Icons.refresh,
                  onPressed: _generateKey,
                ),
              ],
            ),

            if (_encryptMode) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Nonce (12 bytes / 24 hex chars)'),
              const SizedBox(height: 8),
              AppInput(
                controller: _nonceController,
                hintText: 'Optional - leave empty for random nonce',
                maxLines: 1,
              ),
            ] else ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Nonce'),
              const SizedBox(height: 8),
              AppInput(
                controller: _nonceController,
                hintText: 'Enter nonce (24 hex chars)',
                maxLines: 1,
              ),
              
              const SizedBox(height: 16),
              const SectionHeader(title: 'MAC (16 bytes / 32 hex chars)'),
              const SizedBox(height: 8),
              AppInput(
                controller: _macController,
                hintText: 'Enter MAC tag (hex)',
                maxLines: 1,
              ),
            ],

            const SizedBox(height: 20),
            AppButton(
              label: _encryptMode ? 'ENCRYPT' : 'DECRYPT',
              icon: _encryptMode ? Icons.lock : Icons.lock_open,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _processChaCha20,
            ),

            if (_error != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dangerDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_encryptMode && _result.isNotEmpty && _result['success'] == 'true') ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Ciphertext'),
              const SizedBox(height: 8),
              _ResultCard(
                label: 'ENCRYPTED DATA',
                content: _result['ciphertext']!,
                onCopy: () {},
              ),
              
              const SizedBox(height: 16),
              const SectionHeader(title: 'Nonce Used'),
              const SizedBox(height: 8),
              _ResultCard(
                label: 'NONCE',
                content: _result['nonce']!,
                onCopy: () {},
              ),
              
              const SizedBox(height: 16),
              const SectionHeader(title: 'Authentication Tag'),
              const SizedBox(height: 8),
              _ResultCard(
                label: 'POLY1305 MAC',
                content: _result['mac']!,
                onCopy: () {},
              ),
            ],

            if (!_encryptMode && _result.isNotEmpty && _result['success'] == 'true') ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Decrypted Plaintext'),
              const SizedBox(height: 8),
              _ResultCard(
                label: 'PLAINTEXT',
                content: _result['plaintext']!,
                onCopy: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String label;
  final String content;
  final VoidCallback onCopy;

  const _ResultCard({
    required this.label,
    required this.content,
    required this.onCopy,
  });

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
                  label,
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
              CopyButton(text: content),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            content,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
