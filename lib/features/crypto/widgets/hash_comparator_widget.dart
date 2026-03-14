import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/hash_service.dart';

class HashComparatorWidget extends ConsumerStatefulWidget {
  const HashComparatorWidget({super.key});

  @override
  ConsumerState<HashComparatorWidget> createState() => _HashComparatorWidgetState();
}

class _HashComparatorWidgetState extends ConsumerState<HashComparatorWidget> {
  final _hash1Controller = TextEditingController();
  final _hash2Controller = TextEditingController();
  bool? _isMatch;

  @override
  void dispose() {
    _hash1Controller.dispose();
    _hash2Controller.dispose();
    super.dispose();
  }

  void _compare() {
    final h1 = _hash1Controller.text.trim().toLowerCase();
    final h2 = _hash2Controller.text.trim().toLowerCase();
    if (h1.isEmpty || h2.isEmpty) return;
    setState(() {
      _isMatch = HashService.compareHashes(h1, h2);
    });
  }

  void _computeAndCompare() {
    final text = _hash1Controller.text.trim();
    if (text.isEmpty || _hash2Controller.text.trim().isEmpty) return;
    // Try to detect if hash1 looks like a hash already
    final h2 = _hash2Controller.text.trim().toLowerCase();
    final computed = _detectAndHash(text, h2);
    if (computed != null) {
      setState(() => _isMatch = HashService.compareHashes(computed, h2));
    }
  }

  String? _detectAndHash(String text, String referenceHash) {
    if (referenceHash.length == 32) return HashService.hash('md5', text);
    if (referenceHash.length == 40) return HashService.hash('sha1', text);
    if (referenceHash.length == 56) return HashService.hash('sha224', text);
    if (referenceHash.length == 64) return HashService.hash('sha256', text);
    if (referenceHash.length == 96) return HashService.hash('sha384', text);
    if (referenceHash.length == 128) return HashService.hash('sha512', text);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HASH COMPARATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Hash A'),
            const SizedBox(height: 8),
            AppInput(
              controller: _hash1Controller,
              hintText: 'Enter first hash value...',
              onChanged: (_) => setState(() => _isMatch = null),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Hash B'),
            const SizedBox(height: 8),
            AppInput(
              controller: _hash2Controller,
              hintText: 'Enter second hash value...',
              onChanged: (_) => setState(() => _isMatch = null),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'COMPARE',
                    icon: Icons.compare_arrows,
                    onPressed: _compare,
                  ),
                ),
              ],
            ),
            if (_isMatch != null) ...[
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isMatch!
                      ? AppColors.successDim
                      : AppColors.dangerDim,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isMatch! ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isMatch! ? Icons.check_circle : Icons.cancel_outlined,
                      color: _isMatch! ? AppColors.success : AppColors.danger,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isMatch! ? 'HASHES MATCH' : 'HASHES DO NOT MATCH',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _isMatch! ? AppColors.success : AppColors.danger,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Hash A length', value: '${_hash1Controller.text.trim().length} chars'),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Hash B length', value: '${_hash2Controller.text.trim().length} chars'),
                    const SizedBox(height: 6),
                    _InfoRow(
                      label: 'Comparison',
                      value: 'Constant-time (timing-safe)',
                      valueColor: AppColors.info,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
