import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class ReverseDnsLookupWidget extends ConsumerStatefulWidget {
  const ReverseDnsLookupWidget({super.key});

  @override
  ConsumerState<ReverseDnsLookupWidget> createState() =>
      _ReverseDnsLookupWidgetState();
}

class _ReverseDnsLookupWidgetState
    extends ConsumerState<ReverseDnsLookupWidget> {
  final _ipController = TextEditingController();
  String _result = '';
  bool _isLookingUp = false;

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _lookupReverseDns() async {
    final ip = _ipController.text.trim();

    if (ip.isEmpty) {
      setState(() => _result = 'Please enter an IP address');
      return;
    }

    // Validate IP format
    try {
      InternetAddress.parse(ip);
    } catch (e) {
      setState(() => _result = 'Invalid IP address format');
      return;
    }

    setState(() {
      _isLookingUp = true;
      _result = '';
    });

    try {
      final buffer = StringBuffer();
      buffer.writeln('REVERSE DNS LOOKUP');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln('IP Address: $ip\n');
      buffer.writeln(
          'Started: ${DateTime.now().toString().substring(0, 19)}\n\n');
      buffer.writeln('RESOLVING...\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      final startTime = Stopwatch()..start();

      // Perform reverse DNS lookup
      final addresses =
          await InternetAddress.lookup(ip, type: InternetAddressType.any);

      final elapsed = startTime.elapsedMilliseconds;

      buffer.writeln('RESULT');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      if (addresses.isEmpty) {
        buffer.writeln('⚠ No PTR record found for this IP address.\n');
        buffer.writeln('\nPOSSIBLE REASONS\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
        buffer.writeln('• No PTR record configured\n');
        buffer.writeln('• DNS server timeout\n');
        buffer.writeln('• IP address is private/reserved\n');
        buffer.writeln('• Network connectivity issues\n');
      } else {
        buffer.writeln('✅ PTR Record Found!\n\n');

        for (final addr in addresses) {
          buffer.writeln('Hostname: ${addr.host}\n');
          buffer.writeln(
              'IP Type: ${addr.type == InternetAddressType.IPv4 ? 'IPv4' : 'IPv6'}\n');
          buffer.writeln('Raw Address: ${addr.address}\n\n');
        }

        buffer.writeln('ADDITIONAL INFORMATION\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        final hostname = addresses.first.host;

        // Analyze hostname
        buffer.writeln('Hostname Analysis:\n');
        if (hostname.contains('google')) {
          buffer.writeln('  • Belongs to Google\n');
        } else if (hostname.contains('amazon') || hostname.contains('aws')) {
          buffer.writeln('  • Belongs to Amazon AWS\n');
        } else if (hostname.contains('cloudflare')) {
          buffer.writeln('  • Belongs to Cloudflare\n');
        } else if (hostname.contains('microsoft') ||
            hostname.contains('azure')) {
          buffer.writeln('  • Belongs to Microsoft Azure\n');
        } else {
          buffer.writeln('  • Generic hostname\n');
        }

        buffer.writeln('\nQuery Time: ${elapsed}ms\n');
        buffer.writeln(
            'Completed: ${DateTime.now().toString().substring(0, 19)}\n');
      }

      setState(() {
        _result = buffer.toString();
        _isLookingUp = false;
      });
    } catch (e) {
      setState(() {
        _result =
            'Error: ${e.toString()}\n\nPossible causes:\n• Invalid IP address\n• DNS server unreachable\n• No PTR record exists\n• Network timeout';
        _isLookingUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'REVERSE DNS',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'IP ADDRESS'),
            const SizedBox(height: 8),
            AppInput(
              controller: _ipController,
              hintText: 'Enter IPv4 or IPv6 (e.g., 8.8.8.8)...',
              onChanged: (_) {
                if (_result.isNotEmpty && !_isLookingUp)
                  setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isLookingUp ? null : _lookupReverseDns,
                icon: _isLookingUp
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.find_replace),
                label:
                    Text(_isLookingUp ? 'LOOKING UP...' : 'LOOKUP REVERSE DNS'),
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
                label: 'DNS RESULT',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
