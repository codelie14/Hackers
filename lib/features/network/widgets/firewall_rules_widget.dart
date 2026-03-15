import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class FirewallRulesWidget extends ConsumerStatefulWidget {
  const FirewallRulesWidget({super.key});

  @override
  ConsumerState<FirewallRulesWidget> createState() =>
      _FirewallRulesWidgetState();
}

class _FirewallRulesWidgetState extends ConsumerState<FirewallRulesWidget> {
  final _portController = TextEditingController();
  String _selectedAction = 'ALLOW';
  String _selectedProtocol = 'TCP';
  String _selectedType = 'iptables';
  String _result = '';

  final List<String> _actions = ['ALLOW', 'DENY', 'DROP'];
  final List<String> _protocols = ['TCP', 'UDP', 'BOTH'];
  final List<String> _types = ['iptables', 'ufw', 'Windows Firewall'];

  @override
  void dispose() {
    _portController.dispose();
    super.dispose();
  }

  void _generateRules() {
    final port = _portController.text.trim();
    if (port.isEmpty) {
      setState(() => _result = 'Please enter a port number or range');
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('FIREWALL RULES - Port $port ($_selectedProtocol)');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    switch (_selectedType) {
      case 'iptables':
        buffer.writeln('# iptables Rules\n');
        if (_selectedAction == 'ALLOW') {
          buffer.writeln('# Allow incoming traffic on port $port\n');
          if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
            buffer
                .writeln('iptables -A INPUT -p tcp --dport $port -j ACCEPT\n');
          }
          if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
            buffer
                .writeln('iptables -A INPUT -p udp --dport $port -j ACCEPT\n');
          }
          buffer.writeln('\n# Allow outgoing traffic on port $port\n');
          if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
            buffer
                .writeln('iptables -A OUTPUT -p tcp --sport $port -j ACCEPT\n');
          }
          if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
            buffer
                .writeln('iptables -A OUTPUT -p udp --sport $port -j ACCEPT\n');
          }
        } else {
          buffer.writeln('# Block incoming traffic on port $port\n');
          if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
            buffer.writeln(
                'iptables -A INPUT -p tcp --dport $port -j ${_selectedAction}\n');
          }
          if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
            buffer.writeln(
                'iptables -A INPUT -p udp --dport $port -j ${_selectedAction}\n');
          }
        }
        break;

      case 'ufw':
        buffer.writeln('# UFW (Uncomplicated Firewall) Rules\n');
        if (_selectedAction == 'ALLOW') {
          if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
            buffer.writeln('ufw allow $port/tcp\n');
          }
          if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
            buffer.writeln('ufw allow $port/udp\n');
          }
        } else {
          if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
            buffer.writeln('ufw deny $port/tcp\n');
          }
          if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
            buffer.writeln('ufw deny $port/udp\n');
          }
        }
        break;

      case 'Windows Firewall':
        buffer.writeln('# Windows Firewall (PowerShell) Rules\n');
        final action = _selectedAction == 'ALLOW' ? 'Allow' : 'Block';
        if (_selectedProtocol == 'TCP' || _selectedProtocol == 'BOTH') {
          buffer.writeln(
              'New-NetFirewallRule -DisplayName "Port $port TCP" -Direction Inbound -LocalPort $port -Protocol TCP -Action $action\n');
        }
        if (_selectedProtocol == 'UDP' || _selectedProtocol == 'BOTH') {
          buffer.writeln(
              'New-NetFirewallRule -DisplayName "Port $port UDP" -Direction Inbound -LocalPort $port -Protocol UDP -Action $action\n');
        }
        break;
    }

    setState(() => _result = buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FIREWALL RULES',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'PORT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _portController,
              hintText: 'Enter port (e.g., 80 or 1000-2000)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'ACTION'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _actions.map((action) {
                final isSelected = action == _selectedAction;
                return ChoiceChip(
                  label: Text(action),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedAction = action),
                  backgroundColor: Colors.transparent,
                  selectedColor: _getActionColor(action).withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? _getActionColor(action)
                        : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color:
                        isSelected ? _getActionColor(action) : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'PROTOCOL'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _protocols.map((protocol) {
                final isSelected = protocol == _selectedProtocol;
                return ChoiceChip(
                  label: Text(protocol),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _selectedProtocol = protocol),
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
            const SectionHeader(title: 'FIREWALL TYPE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((type) {
                final isSelected = type == _selectedType;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedType = type),
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
            Center(
              child: ElevatedButton.icon(
                onPressed: _generateRules,
                icon: const Icon(Icons.security),
                label: const Text('GENERATE FIREWALL RULES'),
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
                label: 'GENERATED RULES',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'ALLOW':
        return const Color(0xFF00FF88);
      case 'DENY':
        return const Color(0xFFFFAA00);
      case 'DROP':
        return AppColors.danger;
      default:
        return AppColors.accent;
    }
  }
}
