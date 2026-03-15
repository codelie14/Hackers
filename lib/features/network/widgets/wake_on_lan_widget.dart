import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class WakeOnLanWidget extends ConsumerStatefulWidget {
  const WakeOnLanWidget({super.key});

  @override
  ConsumerState<WakeOnLanWidget> createState() => _WakeOnLanWidgetState();
}

class _WakeOnLanWidgetState extends ConsumerState<WakeOnLanWidget> {
  final _macController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _macController.dispose();
    super.dispose();
  }

  Uint8List _createMagicPacket(String macAddress) {
    // Remove separators and convert to uppercase
    final cleanMac = macAddress.replaceAll(RegExp(r'[:\-]'), '').toUpperCase();

    // Create magic packet: 6 bytes of 0xFF + 16 repetitions of MAC address
    final packet = BytesBuilder();

    // Add 6 bytes of 0xFF (sync stream)
    for (var i = 0; i < 6; i++) {
      packet.addByte(0xFF);
    }

    // Add 16 repetitions of the MAC address
    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < cleanMac.length; j += 2) {
        final hexByte = cleanMac.substring(j, j + 2);
        packet.addByte(int.parse(hexByte, radix: 16));
      }
    }

    return packet.toBytes();
  }

  void _generateMagicPacket() {
    final mac = _macController.text.trim();
    if (mac.isEmpty) {
      setState(() => _result = 'Please enter a MAC address');
      return;
    }

    try {
      // Validate MAC address format
      final cleanMac = mac.replaceAll(RegExp(r'[:\-]'), '');
      if (cleanMac.length != 12) {
        setState(() =>
            _result = 'Invalid MAC address. Must be 12 hexadecimal digits');
        return;
      }

      // Generate magic packet
      final packet = _createMagicPacket(mac);

      // Convert to hex string for display
      final hexString = packet
          .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(' ');

      // Format for readability
      final syncStream = hexString.substring(0, 17); // 6 bytes * 3 chars - 1

      final buffer = StringBuffer();
      buffer.writeln('WAKE-ON-LAN MAGIC PACKET');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Target MAC Address: ${mac.toUpperCase()}\n\n');

      buffer.writeln('MAGIC PACKET STRUCTURE');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Sync Stream (6 bytes): $syncStream\n\n');
      buffer.writeln('MAC Address Repetitions (16x):\n');

      // Show first 3 repetitions, then ellipsis, then last repetition
      for (var i = 0; i < 3 && i < 16; i++) {
        final start = 6 + (i * 6);
        final segment = packet.sublist(start, start + 6);
        final hexSegment = segment
            .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
            .join(':');
        buffer.writeln('  Repetition ${i + 1}: $hexSegment\n');
      }
      buffer.writeln('  ...\n');
      final lastStart = 6 + (15 * 6);
      final lastSegment = packet.sublist(lastStart, lastStart + 6);
      final lastHex = lastSegment
          .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(':');
      buffer.writeln('  Repetition 16: $lastHex\n\n');

      buffer.writeln('PACKET DETAILS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Total Size: ${packet.length} bytes\n');
      buffer.writeln('Sync Stream: 6 bytes (0xFF)\n');
      buffer.writeln('MAC Repetitions: 16 x 6 bytes = 96 bytes\n\n');

      buffer.writeln('BROADCAST INFORMATION');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Destination IP: 255.255.255.255\n');
      buffer.writeln('Destination Port: 9 (Discard Protocol)\n');
      buffer.writeln('Protocol: UDP\n\n');

      buffer.writeln('USAGE INSTRUCTIONS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('1. Ensure Wake-on-LAN is enabled in BIOS/UEFI\n');
      buffer.writeln('2. Target device must be connected to power\n');
      buffer.writeln('3. Network adapter must support WoL\n');
      buffer.writeln('4. Send this packet to broadcast address\n');
      buffer.writeln('5. Works on LAN or via directed broadcast\n');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WAKE-ON-LAN',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'MAC ADDRESS'),
            const SizedBox(height: 8),
            AppInput(
              controller: _macController,
              hintText: 'Enter MAC (e.g., 00:1A:2B:3C:4D:5E)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateMagicPacket,
                icon: const Icon(Icons.power_settings_new),
                label: const Text('GENERATE MAGIC PACKET'),
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
                label: 'MAGIC PACKET DETAILS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
