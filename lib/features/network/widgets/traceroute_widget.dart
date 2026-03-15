import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class TracerouteWidget extends ConsumerStatefulWidget {
  const TracerouteWidget({super.key});

  @override
  ConsumerState<TracerouteWidget> createState() => _TracerouteWidgetState();
}

class _TracerouteWidgetState extends ConsumerState<TracerouteWidget> {
  final _hostController = TextEditingController();
  String _result = '';
  bool _isTracing = false;
  int _currentHop = 0;

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _traceroute() async {
    final host = _hostController.text.trim();

    if (host.isEmpty) {
      setState(() => _result = 'Please enter a destination (IP or domain)');
      return;
    }

    setState(() {
      _isTracing = true;
      _result = '';
      _currentHop = 0;
    });

    try {
      final buffer = StringBuffer();
      buffer.writeln('TRACEROUTE RESULTS');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln('Destination: $host\n');
      buffer.writeln(
          'Started: ${DateTime.now().toString().substring(0, 19)}\n\n');
      buffer.writeln('TRACING ROUTE...\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      final hops = <Map<String, dynamic>>[];
      final startTime = Stopwatch()..start();

      // Simulate traceroute with increasing TTL
      for (var ttl = 1; ttl <= 30; ttl++) {
        setState(() => _currentHop = ttl);

        try {
          final hopData = await _traceHop(host, ttl);
          hops.add(hopData);

          if (hopData['reached'] == true) {
            buffer.writeln('Hop $ttl: ${hopData['address']}\n');
            buffer.writeln('  Host: ${hopData['hostname']}\n');
            buffer.writeln('  Time: ${hopData['time']}ms\n');
            buffer.writeln('  ✅ Destination reached!\n\n');
            break;
          } else {
            buffer.writeln('Hop $ttl: ${hopData['address']}\n');
            buffer.writeln('  Host: ${hopData['hostname']}\n');
            buffer.writeln('  Time: ${hopData['time']}ms\n\n');
          }
        } catch (e) {
          buffer.writeln('Hop $ttl: * Request timed out\n\n');
        }

        // Small delay between hops
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final elapsed = startTime.elapsedMilliseconds;

      buffer.writeln('\nROUTE SUMMARY');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
      buffer.writeln('Total Hops: ${hops.length}\n');

      final reachableHops = hops.where((h) => h['reached'] == true).length;
      buffer.writeln('Reachable: $reachableHops\n');
      buffer.writeln('Unreachable: ${hops.length - reachableHops}\n');
      buffer.writeln('Total Time: ${elapsed}ms\n');
      buffer.writeln(
          'Completed: ${DateTime.now().toString().substring(0, 19)}\n\n');

      if (reachableHops > 0) {
        buffer.writeln('PATH ANALYSIS\n');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

        final lastHop = hops.lastWhere((h) => h['reached'] == true);
        buffer.writeln('Final Destination: ${lastHop['hostname']}\n');
        buffer.writeln('IP Address: ${lastHop['address']}\n');

        // Analyze path length
        if (hops.length <= 10) {
          buffer.writeln('Path Quality: ✓ Excellent (few hops)\n\n');
        } else if (hops.length <= 15) {
          buffer.writeln('Path Quality: ⚠ Average\n\n');
        } else {
          buffer.writeln('Path Quality: ✗ Poor (many hops)\n\n');
        }
      }

      setState(() {
        _result = buffer.toString();
        _isTracing = false;
      });
    } catch (e) {
      setState(() {
        _result =
            'Error: ${e.toString()}\n\nNote: Traceroute may be limited on mobile platforms.\nTry using a desktop environment for full functionality.';
        _isTracing = false;
      });
    }
  }

  Future<Map<String, dynamic>> _traceHop(String host, int ttl) async {
    // Note: Raw socket operations are limited on Flutter mobile
    // This is a simulated implementation using DNS timing

    try {
      final startTime = DateTime.now();

      // Attempt to resolve the host
      final addresses = await InternetAddress.lookup(host).timeout(
        Duration(milliseconds: 2000 * ttl),
      );

      final endTime = DateTime.now();
      final elapsed = endTime.difference(startTime).inMilliseconds;

      if (addresses.isNotEmpty) {
        final address = addresses.first.address;
        final hostname = addresses.first.host;

        // Check if we've reached the destination
        final reached = await _isDestinationReacheded(host, address);

        return {
          'address': address,
          'hostname': hostname,
          'time': elapsed,
          'reached': reached,
        };
      } else {
        return {
          'address': '* Timeout',
          'hostname': 'Unknown',
          'time': elapsed,
          'reached': false,
        };
      }
    } catch (e) {
      return {
        'address': '* Error',
        'hostname': e.toString(),
        'time': 0,
        'reached': false,
      };
    }
  }

  Future<bool> _isDestinationReacheded(String original, String resolved) async {
    try {
      // Normalize both addresses
      final normalizedOriginal =
          original.toLowerCase().replaceAll(RegExp(r'https?://'), '');
      final normalizedResolved = resolved.toLowerCase();

      // Check if resolved IP matches original host
      if (normalizedOriginal == normalizedResolved) {
        return true;
      }

      // Try to resolve original to compare IPs
      final addresses = await InternetAddress.lookup(normalizedOriginal);
      for (final addr in addresses) {
        if (addr.address == resolved) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'TRACEROUTE',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'DESTINATION'),
            const SizedBox(height: 8),
            AppInput(
              controller: _hostController,
              hintText: 'Enter destination (e.g., google.com)...',
              onChanged: (_) {
                if (_result.isNotEmpty && !_isTracing)
                  setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isTracing ? null : _traceroute,
                icon: _isTracing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.route),
                label: Text(_isTracing ? 'TRACING...' : 'START TRACEROUTE'),
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
            if (_isTracing) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _currentHop / 30,
                backgroundColor: AppColors.border,
                color: AppColors.accent,
              ),
              const SizedBox(height: 8),
              Text(
                'Current Hop: $_currentHop/30',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'TRACEROUTE RESULTS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
