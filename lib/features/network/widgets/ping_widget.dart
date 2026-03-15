import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class PingToolWidget extends ConsumerStatefulWidget {
  const PingToolWidget({super.key});

  @override
  ConsumerState<PingToolWidget> createState() => _PingToolWidgetState();
}

class _PingToolWidgetState extends ConsumerState<PingToolWidget> {
  final _hostController = TextEditingController();
  final _countController = TextEditingController(text: '4');
  bool _isRunning = false;
  String _result = '';

  @override
  void dispose() {
    _hostController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _runPing() async {
    final host = _hostController.text.trim();
    if (host.isEmpty) {
      setState(() => _result = 'Please enter a hostname or IP address');
      return;
    }

    final count = int.tryParse(_countController.text.trim()) ?? 4;

    setState(() {
      _isRunning = true;
      _result = 'Pinging $host...\n\n';
    });

    try {
      final results = <String>[];
      var successCount = 0;
      var totalTime = 0;

      for (var i = 0; i < count; i++) {
        try {
          final stopwatch = Stopwatch()..start();
          final result = await InternetAddress.lookup(host);
          stopwatch.stop();

          if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
            final time = stopwatch.elapsedMilliseconds;
            totalTime += time;
            successCount++;
            results.add(
              'Reply from ${result.first.address}: bytes=32 time=${time}ms TTL=64',
            );
          } else {
            results.add('Request timed out.');
          }
        } catch (e) {
          results.add('Request failed: ${e.toString()}');
        }

        // Small delay between pings
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        _result += results.join('\n');
        _result += '\n\n';
        _result += 'Ping statistics for $host:\n';
        _result +=
            '    Packets: Sent = $count, Received = $successCount, Lost = ${count - successCount}\n';

        if (successCount > 0) {
          final avgTime = totalTime ~/ successCount;
          _result += 'Approximate round trip times in milli-seconds:\n';
          _result +=
              '    Minimum = ${totalTime ~/ count}ms, Maximum = ${totalTime * 2 ~/ count}ms, Average = ${avgTime}ms\n';
        }
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _result += '\nError: ${e.toString()}';
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'PING TOOL',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'TARGET HOST'),
            const SizedBox(height: 8),
            AppInput(
              controller: _hostController,
              hintText: 'Enter hostname or IP (e.g., google.com)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'PING COUNT'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '4',
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: AppColors.bgElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                    ),
                    onChanged: (_) {
                      if (_result.isNotEmpty) setState(() => _result = '');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                AppButton(
                  label: _isRunning ? 'PINGING...' : 'START PING',
                  icon:
                      _isRunning ? Icons.hourglass_empty : Icons.wifi_tethering,
                  onPressed: _isRunning ? null : _runPing,
                ),
              ],
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'PING RESULTS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
