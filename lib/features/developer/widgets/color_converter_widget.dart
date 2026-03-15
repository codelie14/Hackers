import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class ColorConverterWidget extends ConsumerStatefulWidget {
  const ColorConverterWidget({super.key});

  @override
  ConsumerState<ColorConverterWidget> createState() =>
      _ColorConverterWidgetState();
}

class _ColorConverterWidgetState extends ConsumerState<ColorConverterWidget> {
  final _colorController = TextEditingController();
  String _result = '';
  Color? _previewColor;

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  void _convertColor() {
    final input = _colorController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter a color value');
      return;
    }

    try {
      Color? parsedColor;
      String inputFormat = '';

      // Try to parse different formats
      if (input.startsWith('#')) {
        // HEX format
        final hex = input.replaceFirst('#', '');
        if (hex.length == 6 || hex.length == 3) {
          final fullHex =
              hex.length == 3 ? hex.split('').map((c) => c + c).join() : hex;
          parsedColor = Color(int.parse('FF$fullHex', radix: 16));
          inputFormat = 'HEX';
        }
      } else if (input.startsWith('rgb')) {
        // RGB format
        final matches = RegExp(r'rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)')
            .firstMatch(input);
        if (matches != null) {
          final r = int.parse(matches.group(1)!);
          final g = int.parse(matches.group(2)!);
          final b = int.parse(matches.group(3)!);
          parsedColor = Color.fromARGB(255, r, g, b);
          inputFormat = 'RGB';
        }
      } else if (input.startsWith('hsl')) {
        // HSL format - simplified parsing
        final matches =
            RegExp(r'hsl\s*\(\s*(\d+)\s*,\s*(\d+)%?\s*,\s*(\d+)%?\s*\)')
                .firstMatch(input);
        if (matches != null) {
          final h = int.parse(matches.group(1)!);
          final s = int.parse(matches.group(2)!);
          final l = int.parse(matches.group(3)!);
          parsedColor = _hslToColor(h, s, l);
          inputFormat = 'HSL';
        }
      } else {
        // Try plain RGB values
        final parts = input.split(RegExp(r'[\s,]+'));
        if (parts.length == 3) {
          final r = int.tryParse(parts[0]);
          final g = int.tryParse(parts[1]);
          final b = int.tryParse(parts[2]);
          if (r != null && g != null && b != null) {
            parsedColor = Color.fromARGB(255, r, g, b);
            inputFormat = 'RGB';
          }
        }
      }

      if (parsedColor == null) {
        setState(() => _result =
            'Unable to parse color. Try #RRGGBB, rgb(R,G,B), or hsl(H,S%,L%)');
        return;
      }

      setState(() => _previewColor = parsedColor);

      final buffer = StringBuffer();
      buffer.writeln('COLOR CONVERTER');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Input Format: $inputFormat\n');
      buffer.writeln('Input Value: $input\n\n');

      buffer.writeln('CONVERTED FORMATS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      // HEX
      final hex =
          '#${parsedColor.value.toRadixString(16).substring(2).toUpperCase().padLeft(8, '0')}';
      final shortHex = '#${_toShortHex(parsedColor)}';
      buffer.writeln('HEX (8 digits): $hex\n');
      buffer.writeln('HEX (6 digits): ${hex.substring(0, 7)}\n');
      buffer.writeln('HEX (short): $shortHex\n\n');

      // RGB
      buffer.writeln(
          'RGB: rgb(${parsedColor.red}, ${parsedColor.green}, ${parsedColor.blue})\n');
      buffer.writeln(
          'RGBA: rgba(${parsedColor.red}, ${parsedColor.green}, ${parsedColor.blue}, ${(parsedColor.opacity).toStringAsFixed(2)})\n\n');

      // HSL
      final hsl =
          _rgbToHsl(parsedColor.red, parsedColor.green, parsedColor.blue);
      buffer.writeln('HSL: hsl(${hsl[0]}, ${hsl[1]}%, ${hsl[2]}%)\n\n');

      // HSV
      final hsv =
          _rgbToHsv(parsedColor.red, parsedColor.green, parsedColor.blue);
      buffer.writeln('HSV: hsv(${hsv[0]}, ${hsv[1]}%, ${hsv[2]}%)\n\n');

      // CMYK
      final cmyk =
          _rgbToCmyk(parsedColor.red, parsedColor.green, parsedColor.blue);
      buffer.writeln(
          'CMYK: cmyk(${cmyk[0]}%, ${cmyk[1]}%, ${cmyk[2]}%, ${cmyk[3]}%)\n\n');

      // Integer
      buffer.writeln('INTEGER (ARGB): ${parsedColor.value}\n');
      buffer.writeln(
          'INTEGER (RGB): ${((parsedColor.red << 16) | (parsedColor.green << 8) | parsedColor.blue).toRadixString(16).toUpperCase()}\n\n');

      // Color info
      buffer.writeln('COLOR INFORMATION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln(
          'Red: ${parsedColor.red} (${((parsedColor.red / 255) * 100).toStringAsFixed(1)}%)\n');
      buffer.writeln(
          'Green: ${parsedColor.green} (${((parsedColor.green / 255) * 100).toStringAsFixed(1)}%)\n');
      buffer.writeln(
          'Blue: ${parsedColor.blue} (${((parsedColor.blue / 255) * 100).toStringAsFixed(1)}%)\n');
      buffer.writeln(
          'Alpha: ${parsedColor.alpha} (${(parsedColor.opacity * 100).toStringAsFixed(1)}%)\n\n');

      // Luminance
      final luminance = _calculateLuminance(parsedColor);
      buffer.writeln('RELATIVE LUMINANCE: ${luminance.toStringAsFixed(3)}\n');
      buffer.writeln(
          'Contrast on White: ${(_calculateContrast(parsedColor, Colors.white)).toStringAsFixed(2)}:1\n');
      buffer.writeln(
          'Contrast on Black: ${(_calculateContrast(parsedColor, Colors.black)).toStringAsFixed(2)}:1\n');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  String _toShortHex(Color color) {
    final r = color.red ~/ 17;
    final g = color.green ~/ 17;
    final b = color.blue ~/ 17;
    final rHex = r.toRadixString(16);
    final gHex = g.toRadixString(16);
    final bHex = b.toRadixString(16);
    return '#$rHex$gHex$bHex'.toUpperCase();
  }

  List<int> _rgbToHsl(int r, int g, int b) {
    final rd = r / 255;
    final gd = g / 255;
    final bd = b / 255;
    final max = rd > gd && rd > bd
        ? rd
        : gd > bd
            ? gd
            : bd;
    final min = rd < gd && rd < bd
        ? rd
        : gd < bd
            ? gd
            : bd;
    final l = (max + min) / 2;
    double h = 0;
    double s = 0;

    if (max != min) {
      final d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      if (max == rd) {
        h = ((gd - bd) / d + (gd < bd ? 6 : 0)) / 6;
      } else if (max == gd) {
        h = ((bd - rd) / d + 2) / 6;
      } else {
        h = ((rd - gd) / d + 4) / 6;
      }
    }

    return [(h * 360).round(), (s * 100).round(), (l * 100).round()];
  }

  List<int> _rgbToHsv(int r, int g, int b) {
    final rd = r / 255;
    final gd = g / 255;
    final bd = b / 255;
    final max = rd > gd && rd > bd
        ? rd
        : gd > bd
            ? gd
            : bd;
    final min = rd < gd && rd < bd
        ? rd
        : gd < bd
            ? gd
            : bd;
    final v = max;
    final d = max - min;
    final s = max == 0 ? 0 : d / max;
    double h = 0;

    if (max != min) {
      if (max == rd) {
        h = ((gd - bd) / d + (gd < bd ? 6 : 0)) / 6;
      } else if (max == gd) {
        h = ((bd - rd) / d + 2) / 6;
      } else {
        h = ((rd - gd) / d + 4) / 6;
      }
    }

    return [(h * 360).round(), (s * 100).round(), (v * 100).round()];
  }

  List<int> _rgbToCmyk(int r, int g, int b) {
    final rd = r / 255;
    final gd = g / 255;
    final bd = b / 255;
    final k = 1 -
        (rd > gd && rd > bd
            ? rd
            : gd > bd
                ? gd
                : bd);
    if (k == 1) return [0, 0, 0, 100];
    final c = (1 - rd - k) / (1 - k);
    final m = (1 - gd - k) / (1 - k);
    final y = (1 - bd - k) / (1 - k);
    return [
      (c * 100).round(),
      (m * 100).round(),
      (y * 100).round(),
      (k * 100).round()
    ];
  }

  double _calculateLuminance(Color color) {
    final rsRGB = color.red / 255;
    final gsRGB = color.green / 255;
    final bsRGB = color.blue / 255;
    final r = rsRGB <= 0.03928
        ? rsRGB / 12.92
        : math.pow((rsRGB + 0.055) / 1.055, 2.4).toDouble();
    final g = gsRGB <= 0.03928
        ? gsRGB / 12.92
        : math.pow((gsRGB + 0.055) / 1.055, 2.4).toDouble();
    final b = bsRGB <= 0.03928
        ? bsRGB / 12.92
        : math.pow((bsRGB + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _calculateContrast(Color color1, Color color2) {
    final l1 = _calculateLuminance(color1);
    final l2 = _calculateLuminance(color2);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  num pow(num base, num exponent) {
    return math.pow(base, exponent);
  }

  Color _hslToColor(int h, int s, int l) {
    final sd = s / 100;
    final ld = l / 100;
    final c = (1 - (2 * ld - 1).abs()) * sd;
    final x = c * (1 - (((h / 60) % 2) - 1).abs());
    final m = ld - c / 2;

    double r, g, b;
    if (h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    return Color.fromARGB(255, ((r + m) * 255).round(), ((g + m) * 255).round(),
        ((b + m) * 255).round());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'COLOR CONVERTER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'COLOR INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _colorController,
              hintText: '#RRGGBB, rgb(R,G,B), or hsl(H,S%,L%)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convertColor,
                icon: const Icon(Icons.color_lens),
                label: const Text('CONVERT COLOR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_previewColor != null) ...[
              const SizedBox(height: 16),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: _previewColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    'Preview',
                    style: TextStyle(
                      color: _calculateLuminance(_previewColor!) > 0.5
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CONVERSION RESULTS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
