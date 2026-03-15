import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class CidrCalculatorWidget extends ConsumerStatefulWidget {
  const CidrCalculatorWidget({super.key});

  @override
  ConsumerState<CidrCalculatorWidget> createState() =>
      _CidrCalculatorWidgetState();
}

class _CidrCalculatorWidgetState extends ConsumerState<CidrCalculatorWidget> {
  final _ipController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  void _calculateNetwork() {
    final input = _ipController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter an IP address with CIDR notation');
      return;
    }

    try {
      // Parse IP and CIDR
      final parts = input.split('/');
      if (parts.length != 2) {
        setState(() => _result = 'Invalid format. Use: 192.168.1.0/24');
        return;
      }

      final ipParts = parts[0].split('.').map(int.parse).toList();
      if (ipParts.length != 4) {
        setState(() => _result = 'Invalid IP address format');
        return;
      }

      final cidr = int.parse(parts[1]);
      if (cidr < 0 || cidr > 32) {
        setState(() => _result = 'CIDR must be between 0 and 32');
        return;
      }

      // Calculate network information
      final ipInt = ((ipParts[0] & 0xFF) << 24) |
          ((ipParts[1] & 0xFF) << 16) |
          ((ipParts[2] & 0xFF) << 8) |
          (ipParts[3] & 0xFF);

      final maskInt = cidr == 0 ? 0 : (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
      final networkInt = ipInt & maskInt;
      final broadcastInt = networkInt | (~maskInt & 0xFFFFFFFF);
      final firstHostInt = networkInt + 1;
      final lastHostInt = broadcastInt - 1;
      final hostCount = cidr >= 31 ? 0 : (1 << (32 - cidr)) - 2;

      // Convert to IP strings
      String intToIp(int value) {
        return '${(value >> 24) & 0xFF}.${(value >> 16) & 0xFF}.${(value >> 8) & 0xFF}.${value & 0xFF}';
      }

      final buffer = StringBuffer();
      buffer.writeln('NETWORK INFORMATION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Input: $input\n');
      buffer.writeln('IP Address: ${intToIp(ipInt)}\n');
      buffer.writeln('CIDR Notation: /$cidr\n');
      buffer.writeln('Subnet Mask: ${intToIp(maskInt)}\n\n');

      buffer.writeln('NETWORK DETAILS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Network Address: ${intToIp(networkInt)}\n');
      buffer.writeln('Broadcast Address: ${intToIp(broadcastInt)}\n');
      buffer.writeln('First Usable Host: ${intToIp(firstHostInt)}\n');
      buffer.writeln('Last Usable Host: ${intToIp(lastHostInt)}\n');
      buffer.writeln('Total Usable Hosts: $hostCount\n\n');

      buffer.writeln('BINARY REPRESENTATION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('IP:       ${ipInt.toRadixString(2).padLeft(32, '0')}\n');
      buffer
          .writeln('Mask:     ${maskInt.toRadixString(2).padLeft(32, '0')}\n');
      buffer.writeln(
          'Network:  ${networkInt.toRadixString(2).padLeft(32, '0')}\n');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'CIDR CALCULATOR',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'IP ADDRESS / CIDR'),
            const SizedBox(height: 8),
            AppInput(
              controller: _ipController,
              hintText: 'Enter IP/CIDR (e.g., 192.168.1.0/24)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _result = '');
                  _ipController.clear();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: _calculateNetwork,
                icon: const Icon(Icons.calculate),
                label: const Text('CALCULATE NETWORK'),
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
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CALCULATION RESULTS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
