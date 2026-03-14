import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class NetworkToolsWidget extends ConsumerStatefulWidget {
  const NetworkToolsWidget({super.key});

  @override
  ConsumerState<NetworkToolsWidget> createState() => _NetworkToolsWidgetState();
}

class _NetworkToolsWidgetState extends ConsumerState<NetworkToolsWidget> {
  String _selectedTool = 'Ping';
  final _targetController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  void _execute() {
    setState(() => _result = '');

    final target = _targetController.text.trim();
    if (target.isEmpty) {
      setState(() => _result = 'Please enter a target (IP or domain)');
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('$_selectedTool RESULT\n');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    buffer.writeln('Target: $target\n\n');

    if (_selectedTool == 'Ping') {
      buffer.writeln('Pinging $target [192.168.1.1] with 32 bytes of data:\n');
      buffer.writeln('Reply from 192.168.1.1: bytes=32 time=24ms TTL=64\n');
      buffer.writeln('Reply from 192.168.1.1: bytes=32 time=18ms TTL=64\n');
      buffer.writeln('Reply from 192.168.1.1: bytes=32 time=21ms TTL=64\n');
      buffer.writeln('Reply from 192.168.1.1: bytes=32 time=19ms TTL=64\n\n');
      buffer.writeln('Ping statistics for 192.168.1.1:\n');
      buffer.writeln(
          '    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),\n');
      buffer.writeln('Approximate round trip times in milli-seconds:\n');
      buffer.writeln('    Minimum = 18ms, Maximum = 24ms, Average = 20ms\n');
    } else if (_selectedTool == 'DNS Lookup') {
      buffer.writeln('Server:  dns.google\n');
      buffer.writeln('Address:  8.8.8.8\n\n');
      buffer.writeln('Non-authoritative answer:\n');
      buffer.writeln('Name:    $target\n');
      buffer.writeln('Address: 93.184.216.34\n');
    }

    buffer.writeln('\nNote: Real implementation requires platform channels');

    setState(() => _result = buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'NETWORK TOOLS',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'SELECT TOOL'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Ping', 'DNS Lookup'].map((tool) {
                final isSelected = tool == _selectedTool;
                return ChoiceChip(
                  label: Text(tool),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedTool = tool),
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'TARGET'),
            const SizedBox(height: 8),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                hintText: _selectedTool == 'Ping'
                    ? 'Enter IP or domain...'
                    : 'Enter domain...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppButton(
                label: _selectedTool.toUpperCase(),
                icon: Icons.network_ping,
                onPressed: _execute,
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _result,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: AppColors.textPrimary,
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
