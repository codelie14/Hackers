import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/password_service.dart';

class PinGeneratorWidget extends ConsumerStatefulWidget {
  const PinGeneratorWidget({super.key});

  @override
  ConsumerState<PinGeneratorWidget> createState() => _PinGeneratorWidgetState();
}

class _PinGeneratorWidgetState extends ConsumerState<PinGeneratorWidget> {
  int _length = 6;
  List<String> _pins = [];
  int _count = 1;

  void _generate() {
    setState(() {
      _pins = List.generate(_count, (_) => PasswordService.generatePin(_length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'PIN GENERATOR',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'PIN Length: $_length digits'),
            Slider(
              value: _length.toDouble(),
              min: 4,
              max: 12,
              divisions: 8,
              label: '$_length',
              onChanged: (v) => setState(() { _length = v.round(); _pins = []; }),
            ),
            const SizedBox(height: 16),
            SectionHeader(title: 'Count: $_count PIN${_count > 1 ? 's' : ''}'),
            Slider(
              value: _count.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_count',
              onChanged: (v) => setState(() { _count = v.round(); _pins = []; }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE PIN${_count > 1 ? 's' : ''}',
              icon: Icons.pin,
              fullWidth: true,
              onPressed: _generate,
            ),
            if (_pins.isNotEmpty) ...[
              const SizedBox(height: 20),
              const SectionHeader(title: 'Generated PINs'),
              const SizedBox(height: 8),
              ..._pins.asMap().entries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    if (_count > 1) ...[
                      Text('${e.key + 1}.', style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 24, color: AppColors.accent, letterSpacing: 6, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CopyButton(text: e.value),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
