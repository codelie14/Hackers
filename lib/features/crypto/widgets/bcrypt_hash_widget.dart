import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/bcrypt_service.dart';

class BcryptHashWidget extends ConsumerStatefulWidget {
  const BcryptHashWidget({super.key});

  @override
  ConsumerState<BcryptHashWidget> createState() => _BcryptHashWidgetState();
}

class _BcryptHashWidgetState extends ConsumerState<BcryptHashWidget> {
  final _passwordController = TextEditingController();
  final _hashController = TextEditingController();
  int _costFactor = 12;
  String _result = '';
  bool _isLoading = false;
  String? _error;
  bool _verifyMode = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _hashController.dispose();
    super.dispose();
  }

  Future<void> _generateHash() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() => _error = 'Please enter a password');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = '';
    });

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final hash = BcryptService.generateHash(password, cost: _costFactor);
      setState(() {
        _result = hash;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyHash() async {
    final password = _passwordController.text.trim();
    final hash = _hashController.text.trim();
    
    if (password.isEmpty || hash.isEmpty) {
      setState(() => _error = 'Please enter both password and hash');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = '';
    });

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final isValid = BcryptService.verifyHash(password, hash);
      setState(() {
        _result = isValid ? '✓ HASH VERIFIED - Password matches' : '✗ INVALID - Password does not match';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'BCRYPT HASH',
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
                        _verifyMode = false;
                        _result = '';
                        _error = null;
                        _hashController.clear();
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_verifyMode ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            'GENERATE',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: !_verifyMode ? Colors.black : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _verifyMode = true;
                        _result = '';
                        _error = null;
                        _passwordController.clear();
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _verifyMode ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            'VERIFY',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: _verifyMode ? Colors.black : AppColors.textSecondary,
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
            SectionHeader(title: _verifyMode ? 'Verification' : 'Password'),
            const SizedBox(height: 8),
            
            AppInput(
              controller: _passwordController,
              hintText: _verifyMode ? 'Enter password to verify...' : 'Enter password to hash...',
              obscureText: true,
              maxLines: 1,
              onChanged: (_) {
                if (_result.isNotEmpty || _error != null) {
                  setState(() {
                    _result = '';
                    _error = null;
                  });
                }
              },
            ),

            if (_verifyMode) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Bcrypt Hash'),
              const SizedBox(height: 8),
              AppTextArea(
                controller: _hashController,
                hintText: 'Enter bcrypt hash to verify against...',
                minLines: 2,
                maxLines: 3,
                onChanged: (_) {
                  if (_result.isNotEmpty || _error != null) {
                    setState(() {
                      _result = '';
                      _error = null;
                    });
                  }
                },
              ),
            ],

            if (!_verifyMode) ...[
              const SizedBox(height: 16),
              const SectionHeader(title: 'Cost Factor'),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Complexity: $_costFactor',
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          _getCostDescription(_costFactor),
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            color: _getCostColor(_costFactor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                        value: _costFactor.toDouble(),
                        min: 4,
                        max: 14,
                        divisions: 10,
                        label: '$_costFactor',
                        onChanged: (value) {
                          setState(() {
                            _costFactor = value.toInt();
                            _result = '';
                            _error = null;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Higher = more secure but slower. Recommended: 10-12',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            AppButton(
              label: _verifyMode ? 'VERIFY HASH' : 'GENERATE HASH',
              icon: _verifyMode ? Icons.verified_outlined : Icons.fingerprint,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _verifyMode ? _verifyHash : _generateHash,
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

            if (_result.isNotEmpty && !_verifyMode) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Bcrypt Hash'),
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
                          child: const Text(
                            'BCRYPT',
                            style: TextStyle(
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
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cost factor: $_costFactor | Length: ${_result.length} chars',
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

            if (_result.isNotEmpty && _verifyMode) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result.contains('VERIFIED') 
                      ? AppColors.successDim.withValues(alpha: 0.2)
                      : AppColors.dangerDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _result.contains('VERIFIED') 
                        ? AppColors.success 
                        : AppColors.danger,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _result.contains('VERIFIED') 
                          ? Icons.check_circle_outline 
                          : Icons.cancel_outlined,
                      color: _result.contains('VERIFIED') 
                          ? AppColors.success 
                          : AppColors.danger,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _result,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _result.contains('VERIFIED') 
                              ? AppColors.success 
                              : AppColors.danger,
                        ),
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

  String _getCostDescription(int cost) {
    if (cost <= 6) return 'FAST';
    if (cost <= 10) return 'BALANCED';
    if (cost <= 12) return 'SECURE';
    return 'VERY SECURE';
  }

  Color _getCostColor(int cost) {
    if (cost <= 6) return AppColors.warning;
    if (cost <= 10) return AppColors.info;
    if (cost <= 12) return AppColors.success;
    return AppColors.accent;
  }
}
