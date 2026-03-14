import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class CustomQrDesignerWidget extends ConsumerStatefulWidget {
  const CustomQrDesignerWidget({super.key});

  @override
  ConsumerState<CustomQrDesignerWidget> createState() =>
      _CustomQrDesignerWidgetState();
}

class _CustomQrDesignerWidgetState
    extends ConsumerState<CustomQrDesignerWidget> {
  final _controller = TextEditingController();
  Color _foregroundColor = Colors.black;
  Color _backgroundColor = Colors.white;
  double _size = 300;
  int _errorCorrection = 1; // M

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CUSTOM QR DESIGNER',
      activeCategory: ToolCategory.qrBarcode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'QR CODE DATA'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _controller,
              hintText:
                  'Enter URL or text for QR code...\nNote: Full customization requires qr_flutter package',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'COLORS'),
            const SizedBox(height: 12),

            // Foreground Color
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Foreground:',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _foregroundColor,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final color = await showDialog<Color>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.bgSurface,
                                title: const Text('Choose Color',
                                    style:
                                        TextStyle(fontFamily: 'JetBrainsMono')),
                                content: SingleChildScrollView(
                                  child: _SimpleColorPicker(
                                    initialColor: _foregroundColor,
                                    onColorSelected: (color) =>
                                        Navigator.pop(context, color),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: AppColors.textSecondary)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(
                                        context, _foregroundColor),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            if (color != null)
                              setState(() => _foregroundColor = color);
                          },
                          child: const Text('Pick Color',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Background Color
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Background:',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final color = await showDialog<Color>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.bgSurface,
                                title: const Text('Choose Color',
                                    style:
                                        TextStyle(fontFamily: 'JetBrainsMono')),
                                content: SingleChildScrollView(
                                  child: _SimpleColorPicker(
                                    initialColor: _backgroundColor,
                                    onColorSelected: (color) =>
                                        Navigator.pop(context, color),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            color: AppColors.textSecondary)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(
                                        context, _backgroundColor),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            if (color != null)
                              setState(() => _backgroundColor = color);
                          },
                          child: const Text('Pick Color',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMono', fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'SIZE'),
            const SizedBox(height: 8),
            Slider(
              value: _size,
              min: 100,
              max: 500,
              divisions: 8,
              label: '${_size.toInt()}px',
              activeColor: AppColors.accent,
              onChanged: (value) => setState(() => _size = value),
            ),
            Center(
              child: Text(
                '${_size.toInt()} × ${_size.toInt()} pixels',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'ERROR CORRECTION'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                {'level': 'L', 'value': 0, 'desc': '7%'},
                {'level': 'M', 'value': 1, 'desc': '15%'},
                {'level': 'Q', 'value': 2, 'desc': '25%'},
                {'level': 'H', 'value': 3, 'desc': '30%'},
              ].map((item) {
                final isSelected = _errorCorrection == item['value'];
                return ChoiceChip(
                  label: Text('${item['level']} (${item['desc']})'),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _errorCorrection = item['value'] as int),
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
            const SizedBox(height: 24),

            // Preview Placeholder
            const SectionHeader(title: 'PREVIEW'),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: _size,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code,
                        size: 64, color: _foregroundColor.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'QR Code Preview',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: _foregroundColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add qr_flutter package to enable generation',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                border: Border.all(color: AppColors.info),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.info, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'To enable full QR code generation, add the qr_flutter package to pubspec.yaml',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const _SimpleColorPicker({
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<_SimpleColorPicker> createState() => _SimpleColorPickerState();
}

class _SimpleColorPickerState extends State<_SimpleColorPicker> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: Colors.primaries.length,
          itemBuilder: (context, index) {
            final color = Colors.primaries[index];
            final isSelected = _selectedColor.value == color.value;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedColor = color);
                widget.onColorSelected(color);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Hex Color',
            hintText: '#000000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            prefixText: '#',
          ),
          onChanged: (value) {
            try {
              var colorString = value.replaceAll('#', '');
              if (colorString.length == 6) {
                colorString = 'FF$colorString';
              }
              final color = Color(int.parse(colorString, radix: 16));
              setState(() => _selectedColor = color);
              widget.onColorSelected(color);
            } catch (e) {
              // Invalid hex, ignore
            }
          },
        ),
      ],
    );
  }
}
