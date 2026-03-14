import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/code_display.dart';
import '../../../data/models/tool_model.dart';
import '../services/rsa_service.dart';

class RsaToolWidget extends ConsumerStatefulWidget {
  const RsaToolWidget({super.key});

  @override
  ConsumerState<RsaToolWidget> createState() => _RsaToolWidgetState();
}

class _RsaToolWidgetState extends ConsumerState<RsaToolWidget> {
  int _keySize = 2048;
  String _publicKey = '';
  String _privateKey = '';
  bool _isLoading = false;
  String? _error;

  Future<void> _generateKeys() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      // Run on isolate to avoid UI jank - but for simplicity use Future
      await Future(() {
        final pair = RsaService.generateKeyPair(_keySize);
        final pub = RsaService.publicKeyToPem(pair.publicKey);
        final priv = RsaService.privateKeyToPem(pair.privateKey);
        setState(() {
          _publicKey = pub;
          _privateKey = priv;
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'RSA KEY GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Key Size'),
            const SizedBox(height: 8),
            Row(
              children: [2048, 4096].map((size) {
                final selected = _keySize == size;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() { _keySize = size; _publicKey = ''; _privateKey = ''; }),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accentGhost : AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: selected ? AppColors.accent : AppColors.border),
                      ),
                      child: Text(
                        '$size bits',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 13,
                          color: selected ? AppColors.accent : AppColors.textSecondary,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _keySize == 4096
                          ? '4096-bit generation may take 10-30 seconds...'
                          : '2048-bit generation takes a few seconds.',
                      style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE RSA KEY PAIR',
              icon: Icons.vpn_key,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _generateKeys,
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: AppColors.danger, fontFamily: 'JetBrainsMono', fontSize: 12)),
            ],
            if (_publicKey.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Public Key'),
              const SizedBox(height: 8),
              CodeDisplay(code: _publicKey, language: 'text', label: 'PUBLIC KEY · PEM'),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Private Key'),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 8, top: 8),
                decoration: BoxDecoration(
                  color: AppColors.dangerDim,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.danger, size: 14),
                    SizedBox(width: 8),
                    Expanded(child: Text('Never share your private key!', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: AppColors.danger))),
                  ],
                ),
              ),
              CodeDisplay(code: _privateKey, language: 'text', label: 'PRIVATE KEY · PEM'),
            ],
          ],
        ),
      ),
    );
  }
}
