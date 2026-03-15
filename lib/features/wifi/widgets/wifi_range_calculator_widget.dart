import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../data/models/tool_model.dart';

class WiFiRangeCalculatorWidget extends ConsumerStatefulWidget {
  const WiFiRangeCalculatorWidget({super.key});

  @override
  ConsumerState<WiFiRangeCalculatorWidget> createState() =>
      _WiFiRangeCalculatorWidgetState();
}

class _WiFiRangeCalculatorWidgetState
    extends ConsumerState<WiFiRangeCalculatorWidget> {
  double _frequency = 2.4;
  double _txPower = 20;
  double _rxSensitivity = -70;
  double _antennaGain = 2;
  double? _estimatedRange;

  void _calculateRange() {
    // Friis transmission equation (simplified)
    // Range = 10^((Pt + Gr + Gt - Rs - 20log10(f) - 27.55) / 20)
    final wavelength = 300 / (_frequency * 1000); // in meters
    final pathLossExponent = 2.0; // Free space

    final totalGain = _txPower + (2 * _antennaGain) - _rxSensitivity;
    final frequencyLoss = 20 * log10(_frequency * 1000);
    final rangeMeters =
        pow(10, (totalGain - frequencyLoss - 27.55) / 20).toDouble();

    setState(() => _estimatedRange = rangeMeters);
  }

  double log10(double x) => log(x) / ln10;
  double log(double x) => x > 0 ? _naturalLog(x) : double.negativeInfinity;

  double _naturalLog(double x) {
    if (x <= 0) return double.negativeInfinity;
    double result = 0.0;
    double term = (x - 1) / (x + 1);
    double termSquared = term * term;
    for (int i = 1; i <= 50; i += 2) {
      result += term / i;
      term *= termSquared;
    }
    return 2 * result;
  }

  static const ln10 = 2.302585092994046;
  double pow(double base, double exponent) {
    if (exponent == 0) return 1;
    if (base == 0) return 0;
    return exp(exponent * log(base));
  }

  double exp(double x) {
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 50; i++) {
      term *= x / i;
      result += term;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WiFi Range Calculator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'WiFi Range Calculator',
              subtitle: 'Estimate coverage using Friis model',
            ),
            const SizedBox(height: 24),
            _buildSlider(
              label: 'Frequency (GHz)',
              value: _frequency,
              min: 2.4,
              max: 6.0,
              divisions: 3,
              format: (v) => '${v.toStringAsFixed(1)} GHz',
              onChanged: (v) => setState(() => _frequency = v),
            ),
            _buildSlider(
              label: 'Transmit Power (dBm)',
              value: _txPower,
              min: 0,
              max: 30,
              divisions: 30,
              format: (v) => '${v.toInt()} dBm',
              onChanged: (v) => setState(() => _txPower = v),
            ),
            _buildSlider(
              label: 'RX Sensitivity (dBm)',
              value: _rxSensitivity,
              min: -90,
              max: -50,
              divisions: 40,
              format: (v) => '${v.toInt()} dBm',
              onChanged: (v) => setState(() => _rxSensitivity = v),
            ),
            _buildSlider(
              label: 'Antenna Gain (dBi)',
              value: _antennaGain,
              min: 0,
              max: 10,
              divisions: 20,
              format: (v) => '${v.toStringAsFixed(1)} dBi',
              onChanged: (v) => setState(() => _antennaGain = v),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateRange,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculate Range'),
            ),
            if (_estimatedRange != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentDark, AppColors.bgSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent),
                ),
                child: Column(
                  children: [
                    Icon(Icons.signal_cellular_alt,
                        size: 48, color: AppColors.accent),
                    const SizedBox(height: 16),
                    Text(
                      'Estimated Range',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_estimatedRange! / 100).toStringAsFixed(2)} km',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 36,
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_estimatedRange!.toStringAsFixed(1)} meters',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Based on Friis transmission model\nActual range may vary due to obstacles',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
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

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String Function(double) format,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'JetBrainsMono')),
              Text(format(value),
                  style: TextStyle(
                      color: AppColors.accent, fontFamily: 'JetBrainsMono')),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
