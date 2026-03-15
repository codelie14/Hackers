import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../data/models/tool_model.dart';

class NetworkInformationWidget extends ConsumerStatefulWidget {
  const NetworkInformationWidget({super.key});

  @override
  ConsumerState<NetworkInformationWidget> createState() =>
      _NetworkInformationWidgetState();
}

class _NetworkInformationWidgetState
    extends ConsumerState<NetworkInformationWidget> {
  Map<String, dynamic>? _networkInfo;

  @override
  void initState() {
    super.initState();
    _loadNetworkInfo();
  }

  Future<void> _loadNetworkInfo() async {
    // Simulated network information for cross-platform compatibility
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _networkInfo = {
        'hostname': 'hackers-device',
        'interfaces': [
          {
            'name': 'wlan0',
            'type': 'WiFi',
            'ip': '192.168.1.105',
            'netmask': '255.255.255.0',
            'mac': 'AA:BB:CC:DD:EE:FF',
            'status': 'UP',
          },
          {
            'name': 'eth0',
            'type': 'Ethernet',
            'ip': '192.168.1.100',
            'netmask': '255.255.255.0',
            'mac': '11:22:33:44:55:66',
            'status': 'DOWN',
          },
          {
            'name': 'lo',
            'type': 'Loopback',
            'ip': '127.0.0.1',
            'netmask': '255.0.0.0',
            'mac': '00:00:00:00:00:00',
            'status': 'UP',
          },
        ],
        'dns': ['8.8.8.8', '8.8.4.4'],
        'gateway': '192.168.1.1',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Network Information',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Network Information',
              subtitle: 'Network interfaces and configuration',
            ),
            const SizedBox(height: 24),
            if (_networkInfo == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              // General Info
              _buildInfoCard(
                title: 'General Configuration',
                items: [
                  ('Hostname', _networkInfo!['hostname'] as String),
                  ('Default Gateway', _networkInfo!['gateway'] as String),
                  ('DNS Servers', (_networkInfo!['dns'] as List).join(', ')),
                ],
              ),
              const SizedBox(height: 20),

              // Network Interfaces
              Text(
                'Network Interfaces',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              ...(_networkInfo!['interfaces'] as List).map((iface) {
                final data = iface as Map<String, dynamic>;
                return _buildInterfaceCard(data);
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<(String, String)> items,
  }) {
    return Card(
      color: AppColors.bgSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 24),
            ...items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Text(
                              item.$1,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SelectableText(
                              item.$2,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInterfaceCard(Map<String, dynamic> data) {
    final isUp = data['status'] == 'UP';

    return Card(
      color: AppColors.bgSurface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      data['type'] == 'WiFi'
                          ? Icons.wifi
                          : data['type'] == 'Ethernet'
                              ? Icons.lan
                              : Icons.loop,
                      color: isUp ? AppColors.success : AppColors.textMuted,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${data['name']} (${data['type']})',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isUp ? AppColors.success : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUp
                        ? AppColors.successDim
                        : AppColors.textMuted.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data['status'],
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: isUp ? AppColors.success : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildDetailRow('IP Address', data['ip'] as String),
            const SizedBox(height: 8),
            _buildDetailRow('Netmask', data['netmask'] as String),
            const SizedBox(height: 8),
            _buildDetailRow('MAC Address', data['mac'] as String),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
