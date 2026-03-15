import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../data/models/tool_model.dart';

class CPURAMMonitorWidget extends ConsumerStatefulWidget {
  const CPURAMMonitorWidget({super.key});

  @override
  ConsumerState<CPURAMMonitorWidget> createState() =>
      _CPURAMMonitorWidgetState();
}

class _CPURAMMonitorWidgetState extends ConsumerState<CPURAMMonitorWidget> {
  double _cpuUsage = 0.0;
  double _ramUsage = 0.0;
  double _totalRAM = 0.0;
  List<double> _cpuHistory = List.filled(30, 0);
  List<double> _ramHistory = List.filled(30, 0);
  Timer? _timer;
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  Future<void> _startMonitoring() async {
    setState(() => _isMonitoring = true);

    // Get total RAM (simulated for cross-platform compatibility)
    _totalRAM = 8.0; // Default 8GB

    // Start periodic updates (simulated for cross-platform compatibility)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Simulate realistic CPU/RAM fluctuations
        _cpuUsage = 20 +
            (DateTime.now().second % 30).toDouble() +
            (DateTime.now().millisecond / 100);
        _ramUsage =
            (_totalRAM * 0.4) + ((DateTime.now().minute % 10).toDouble() / 10);

        _cpuHistory.removeAt(0);
        _cpuHistory.add(_cpuUsage);
        _ramHistory.removeAt(0);
        _ramHistory.add(_ramUsage);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CPU & RAM Monitor',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'CPU & RAM Monitor',
              subtitle: 'Real-time system resource monitoring',
            ),
            const SizedBox(height: 24),

            // CPU Usage Card
            _buildResourceCard(
              title: 'CPU Usage',
              icon: Icons.memory,
              currentValue: _cpuUsage,
              max: 100,
              unit: '%',
              history: _cpuHistory,
              color: AppColors.catCrypto,
            ),
            const SizedBox(height: 20),

            // RAM Usage Card
            _buildResourceCard(
              title: 'RAM Usage',
              icon: Icons.dns_outlined,
              currentValue: _ramUsage,
              max: _totalRAM,
              unit: 'GB',
              history: _ramHistory.map((v) => (v / _totalRAM) * 100).toList(),
              color: AppColors.catPassword,
              secondaryText:
                  '${_ramUsage.toStringAsFixed(2)} / ${_totalRAM.toStringAsFixed(2)} GB',
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Real-time Monitoring',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 13,
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Updates every second. Values are simulated for cross-platform compatibility.',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required IconData icon,
    required double currentValue,
    required double max,
    required String unit,
    required List<double> history,
    required Color color,
    String? secondaryText,
  }) {
    final percentage = (currentValue / max) * 100;

    return Card(
      color: AppColors.bgSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentValue.toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            if (secondaryText != null) ...[
              const SizedBox(height: 4),
              Text(
                secondaryText,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 16),

            // History Graph
            SizedBox(
              height: 40,
              child: Row(
                children: history.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value;
                  final barHeight = (value / 100) * 40;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: barHeight.clamp(2, 40),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                'Last 30 seconds',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
