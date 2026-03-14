import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';
import '../services/hash_service.dart';

class HmacGeneratorWidget extends ConsumerStatefulWidget {
  const HmacGeneratorWidget({super.key});

  @override
  ConsumerState<HmacGeneratorWidget> createState() => _HmacGeneratorWidgetState();
}

class _HmacGeneratorWidgetState extends ConsumerState<HmacGeneratorWidget> {
  final _keyController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedAlgorithm = 'HMAC-SHA256';
  String _result = '';
  bool _isLoading = false;

  final _algorithms = ['HMAC-SHA1', 'HMAC-SHA256', 'HMAC-SHA384', 'HMAC-SHA512'];

  @override
  void dispose() {
    _keyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_keyController.text.isEmpty || _messageController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      final r = HashService.hmac(_selectedAlgorithm, _keyController.text, _messageController.text);
      setState(() { _result = r; _isLoading = false; });
    } catch (e) {
      setState(() { _result = 'Error: $e'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HMAC GENERATOR',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Algorithm'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _algorithms.map((algo) {
                final selected = algo == _selectedAlgorithm;
                return InkWell(
                  onTap: () => setState(() {
                    _selectedAlgorithm = algo;
                    _result = '';
                  }),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.accentGhost : AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: selected ? AppColors.accent : AppColors.border,
                      ),
                    ),
                    child: Text(
                      algo,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: selected ? AppColors.accent : AppColors.textSecondary,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Secret Key'),
            const SizedBox(height: 8),
            AppInput(
              controller: _keyController,
              hintText: 'Enter HMAC secret key...',
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Message'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _messageController,
              hintText: 'Enter message to authenticate...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE HMAC',
              icon: Icons.verified_outlined,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _generate,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionHeader(title: 'Result'),
              const SizedBox(height: 8),
              ResultBox(content: _result, label: _selectedAlgorithm),
            ],
          ],
        ),
      ),
    );
  }
}
