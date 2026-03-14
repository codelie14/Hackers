import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class QrGeneratorWidget extends ConsumerStatefulWidget {
  const QrGeneratorWidget({super.key});

  @override
  ConsumerState<QrGeneratorWidget> createState() => _QrGeneratorWidgetState();
}

class _QrGeneratorWidgetState extends ConsumerState<QrGeneratorWidget> {
  final _ctrl = TextEditingController();
  String _data = '';
  int _errorCorrection = QrErrorCorrectLevel.M;
  int _size = 280;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    const ecLevels = {'L': QrErrorCorrectLevel.L, 'M': QrErrorCorrectLevel.M, 'Q': QrErrorCorrectLevel.Q, 'H': QrErrorCorrectLevel.H};

    return AppScaffold(
      title: 'QR CODE GENERATOR',
      activeCategory: ToolCategory.qrBarcode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Data / URL'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _ctrl,
              hintText: 'Enter text, URL, or any data to encode...',
              minLines: 2,
              maxLines: 5,
              onChanged: (_) => setState(() => _data = ''),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SectionHeader(title: 'Error Correction'),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, children: ecLevels.entries.map((e) {
                    final sel = _errorCorrection == e.value;
                    return InkWell(
                      onTap: () => setState(() { _errorCorrection = e.value; }),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.accentGhost : AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: sel ? AppColors.accent : AppColors.border),
                        ),
                        child: Text(e.key, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: sel ? AppColors.accent : AppColors.textSecondary, fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                      ),
                    );
                  }).toList()),
                ])),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SectionHeader(title: 'Size: ${_size}px'),
                  Slider(value: _size.toDouble(), min: 150, max: 400, divisions: 5, label: '${_size}px',
                    onChanged: (v) => setState(() => _size = v.round())),
                ])),
              ],
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE QR CODE',
              icon: Icons.qr_code_2,
              fullWidth: true,
              onPressed: () {
                if (_ctrl.text.trim().isEmpty) return;
                setState(() => _data = _ctrl.text.trim());
              },
            ),
            if (_data.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'QR Code'),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: QrImageView(
                    data: _data,
                    version: QrVersions.auto,
                    size: _size.toDouble(),
                    errorCorrectionLevel: _errorCorrection,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(color: Colors.black),
                    dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                  child: Text(
                    _data.length > 60 ? '${_data.substring(0, 60)}...' : _data,
                    style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
