import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class IpConverterWidget extends ConsumerStatefulWidget {
  const IpConverterWidget({super.key});

  @override
  ConsumerState<IpConverterWidget> createState() => _IpConverterWidgetState();
}

class _IpConverterWidgetState extends ConsumerState<IpConverterWidget> {
  final _ipController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  void _convertIP() {
    final input = _ipController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter an IP address');
      return;
    }

    try {
      // Parse IPv4
      final parts = input.split('.');
      if (parts.length != 4) {
        setState(() => _result = 'Invalid IPv4 address format');
        return;
      }

      final octets = parts.map(int.parse).toList();
      for (final octet in octets) {
        if (octet < 0 || octet > 255) {
          setState(() => _result = 'Each octet must be between 0 and 255');
          return;
        }
      }

      // Convert to different formats
      final decimal = ((octets[0] & 0xFF) << 24) |
          ((octets[1] & 0xFF) << 16) |
          ((octets[2] & 0xFF) << 8) |
          (octets[3] & 0xFF);

      final hex =
          '0x${decimal.toRadixString(16).toUpperCase().padLeft(8, '0')}';

      final binary =
          octets.map((o) => o.toRadixString(2).padLeft(8, '0')).join('.');

      final octal = octets.map((o) => '0${o.toRadixString(8)}').join('.');

      // IPv6 mapped format
      final ipv6Mapped = '::ffff:${input}';

      final buffer = StringBuffer();
      buffer.writeln('IP ADDRESS CONVERSION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Input (Dotted Decimal): $input\n\n');

      buffer.writeln('CONVERTED FORMATS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Decimal (Integer): $decimal\n');
      buffer.writeln('Hexadecimal: $hex\n');
      buffer.writeln('Binary: $binary\n');
      buffer.writeln('Octal: $octal\n\n');

      buffer.writeln('IPv6 MAPPED FORMAT');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('IPv6 Mapped: $ipv6Mapped\n\n');

      buffer.writeln('BINARY BREAKDOWN');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      for (var i = 0; i < 4; i++) {
        buffer.writeln(
            'Octet ${i + 1}: ${octets[i].toString().padLeft(3)} = ${octets[i].toRadixString(2).padLeft(8, '0')}\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'IP CONVERTER',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'IPV4 ADDRESS'),
            const SizedBox(height: 8),
            AppInput(
              controller: _ipController,
              hintText: 'Enter IPv4 (e.g., 192.168.1.1)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convertIP,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('CONVERT IP ADDRESS'),
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
