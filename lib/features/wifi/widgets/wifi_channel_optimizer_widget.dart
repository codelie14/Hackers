import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../data/models/tool_model.dart';

class WiFiChannelOptimizerWidget extends ConsumerStatefulWidget {
  const WiFiChannelOptimizerWidget({super.key});

  @override
  ConsumerState<WiFiChannelOptimizerWidget> createState() =>
      _WiFiChannelOptimizerWidgetState();
}

class _WiFiChannelOptimizerWidgetState
    extends ConsumerState<WiFiChannelOptimizerWidget> {
  String _selectedBand = '2.4 GHz';
  Map<int, int> _channelUsage = {};
  int? _recommendedChannel;

  void _calculateOptimalChannel() {
    setState(() {
      _channelUsage = _generateSimulatedChannelData();
      _recommendedChannel = _findBestChannel();
    });
  }

  Map<int, int> _generateSimulatedChannelData() {
    final random = Random.secure();
    if (_selectedBand == '2.4 GHz') {
      // Channels 1-11 for 2.4GHz
      return {for (var i = 0; i < 11; i++) i + 1: random.nextInt(100)};
    } else {
      // Common 5GHz channels
      final channels = [36, 40, 44, 48, 149, 153, 157, 161, 165];
      return {for (var ch in channels) ch: random.nextInt(100)};
    }
  }

  int _findBestChannel() {
    if (_channelUsage.isEmpty) return _selectedBand == '2.4 GHz' ? 1 : 36;

    var bestChannel = _channelUsage.entries.reduce((a, b) {
      return a.value < b.value ? a : b;
    }).key;

    return bestChannel;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WiFi Channel Optimizer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'WiFi Channel Optimizer',
              subtitle: 'Find the least congested WiFi channel',
            ),
            const SizedBox(height: 24),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '2.4 GHz', label: Text('2.4 GHz')),
                ButtonSegment(value: '5 GHz', label: Text('5 GHz')),
              ],
              selected: {_selectedBand},
              onSelectionChanged: (Set<String> selected) {
                setState(() {
                  _selectedBand = selected.first;
                  _channelUsage = {};
                  _recommendedChannel = null;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _calculateOptimalChannel,
              icon: const Icon(Icons.tune),
              label: const Text('Analyze Channels'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (_channelUsage.isNotEmpty) ...[
              const SizedBox(height: 32),
              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Channel Analysis',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 16,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._channelUsage.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  'Ch ${entry.key}',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: entry.value / 100,
                                    backgroundColor: AppColors.border,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getUsageColor(entry.value),
                                    ),
                                    minHeight: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  '${entry.value}%',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              if (_recommendedChannel != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.successDim,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Recommended Channel',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Channel $_recommendedChannel',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 32,
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lowest interference detected',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Color _getUsageColor(int usage) {
    if (usage < 30) return AppColors.success;
    if (usage < 60) return AppColors.warning;
    return AppColors.danger;
  }
}
