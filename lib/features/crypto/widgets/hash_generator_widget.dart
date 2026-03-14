import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/hash_service.dart';

class HashGeneratorWidget extends ConsumerStatefulWidget {
  const HashGeneratorWidget({super.key});

  @override
  ConsumerState<HashGeneratorWidget> createState() => _HashGeneratorWidgetState();
}

class _HashGeneratorWidgetState extends ConsumerState<HashGeneratorWidget> {
  final _inputController = TextEditingController();
  Map<String, String> _hashes = {};
  bool _isLoading = false;
  bool _inputAsHex = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _generateHashes() async {
    final input = _inputController.text;
    if (input.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final hashes = HashService.hashAll(input);
      setState(() {
        _hashes = hashes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HASH GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Input'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: 'Enter text to hash...',
              minLines: 3,
              maxLines: 8,
              onChanged: (_) {
                if (_hashes.isNotEmpty) setState(() => _hashes = {});
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE HASHES',
              icon: Icons.fingerprint,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _generateHashes,
            ),
            if (_hashes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Results'),
              const SizedBox(height: 8),
              ..._hashes.entries.map((entry) => _HashRow(
                algorithm: entry.key,
                hash: entry.value,
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _HashRow extends StatelessWidget {
  final String algorithm;
  final String hash;

  const _HashRow({required this.algorithm, required this.hash});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
                  algorithm,
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
              CopyButton(text: hash),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            hash,
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
