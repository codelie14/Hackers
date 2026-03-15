import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/tool_model.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../services/advanced_hash_service.dart';

class AdvancedHashWidget extends ConsumerStatefulWidget {
  const AdvancedHashWidget({super.key});

  @override
  ConsumerState<AdvancedHashWidget> createState() => _AdvancedHashWidgetState();
}

class _AdvancedHashWidgetState extends ConsumerState<AdvancedHashWidget> {
  final _inputController = TextEditingController();
  String _selectedAlgorithm = 'RIPEMD-160';
  String _result = '';

  final List<String> _algorithms = [
    'RIPEMD-160',
    'Keccak-256',
    'Adler-32',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _generateHash() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter input text');
      return;
    }

    try {
      String hash;
      switch (_selectedAlgorithm) {
        case 'RIPEMD-160':
          hash = AdvancedHashService.ripemd160(input);
          break;
        case 'Keccak-256':
          hash = AdvancedHashService.keccak256(input);
          break;
        case 'Adler-32':
          hash = AdvancedHashService.adler32(input);
          break;
        default:
          hash = AdvancedHashService.ripemd160(input);
      }

      setState(() {
        _result = '$_selectedAlgorithm\n\n$hash';
      });
    } catch (e) {
      setState(() => _result = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ADVANCED HASH',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'ALGORITHM'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _algorithms.map((algo) {
                final isSelected = algo == _selectedAlgorithm;
                return ChoiceChip(
                  label: Text(algo),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _selectedAlgorithm = algo;
                    _result = '';
                  }),
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _inputController,
              hintText: 'Enter text to hash...',
              maxLines: 4,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppButton(
                label: 'GENERATE HASH',
                icon: Icons.security,
                onPressed: _generateHash,
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result.split('\n').skip(1).join('\n'),
                label: _result.split('\n').first,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
