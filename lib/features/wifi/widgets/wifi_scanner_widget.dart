import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class WifiScannerWidget extends ConsumerStatefulWidget {
  const WifiScannerWidget({super.key});

  @override
  ConsumerState<WifiScannerWidget> createState() => _WifiScannerWidgetState();
}

class _WifiScannerWidgetState extends ConsumerState<WifiScannerWidget> {
  bool _isScanning = false;
  List<Map<String, String>> _networks = [];

  void _startScan() {
    setState(() {
      _isScanning = true;
      _networks = [];
    });

    // Simulate scan (in production, use platform channels for native WiFi API)
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      setState(() {
        _networks = [
          {
            'ssid': 'HomeWiFi_5G',
            'security': 'WPA3',
            'signal': '85%',
            'channel': '36'
          },
          {
            'ssid': 'Guest_Network',
            'security': 'WPA2',
            'signal': '72%',
            'channel': '11'
          },
          {
            'ssid': 'Office_5GHz',
            'security': 'WPA3-Enterprise',
            'signal': '68%',
            'channel': '149'
          },
          {
            'ssid': 'IoT_Devices',
            'security': 'WPA2',
            'signal': '45%',
            'channel': '6'
          },
          {
            'ssid': 'Neighbor_WiFi',
            'security': 'WEP',
            'signal': '32%',
            'channel': '1'
          },
        ];
        _isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WI-FI SCANNER',
      activeCategory: ToolCategory.wifi,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                border: Border.all(color: AppColors.warning),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'WiFi scanning requires native platform APIs. This is a demo showing UI capabilities.',
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
            const SizedBox(height: 24),

            Center(
              child: AppButton(
                label: _isScanning ? 'SCANNING...' : 'START SCAN',
                icon: _isScanning ? Icons.refresh : Icons.wifi,
                onPressed: _isScanning ? null : _startScan,
              ),
            ),
            const SizedBox(height: 24),

            if (_isScanning) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Scanning for networks...',
                        style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_networks.isNotEmpty) ...[
              const SectionHeader(title: 'AVAILABLE NETWORKS'),
              const SizedBox(height: 12),
              ..._networks.map((network) {
                final signalStrength =
                    int.parse(network['signal']!.replaceAll('%', ''));
                IconData signalIcon;
                Color signalColor;

                if (signalStrength >= 70) {
                  signalIcon = Icons.signal_cellular_4_bar;
                  signalColor = AppColors.success;
                } else if (signalStrength >= 40) {
                  signalIcon = Icons.signal_cellular_alt;
                  signalColor = AppColors.warning;
                } else {
                  signalIcon = Icons.signal_cellular_null;
                  signalColor = AppColors.danger;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(signalIcon, color: signalColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              network['ssid']!,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${network['security']} • Channel ${network['channel']}',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        network['signal']!,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: signalColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            if (!_isScanning && _networks.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.wifi_off,
                          size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 16),
                      const Text(
                        'No networks scanned yet',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap START SCAN to discover WiFi networks',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
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
