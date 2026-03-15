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

class DnsLookupWidget extends ConsumerStatefulWidget {
  const DnsLookupWidget({super.key});

  @override
  ConsumerState<DnsLookupWidget> createState() => _DnsLookupWidgetState();
}

class _DnsLookupWidgetState extends ConsumerState<DnsLookupWidget> {
  final _domainController = TextEditingController();
  String _selectedType = 'A';
  bool _isLookingUp = false;
  String _result = '';

  final List<String> _recordTypes = ['A', 'AAAA', 'MX', 'TXT', 'CNAME', 'NS'];

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _lookupDns() async {
    final domain = _domainController.text.trim();
    if (domain.isEmpty) {
      setState(() => _result = 'Please enter a domain name');
      return;
    }

    setState(() {
      _isLookingUp = true;
      _result = 'Looking up $_selectedType records for $domain...\n\n';
    });

    try {
      final results = <String>[];

      switch (_selectedType) {
        case 'A':
          final addresses = await InternetAddress.lookup(domain);
          for (final addr in addresses) {
            results.add('A Record: ${addr.address}');
          }
          break;

        case 'AAAA':
          final addresses = await InternetAddress.lookup(domain,
              type: InternetAddressType.IPv6);
          for (final addr in addresses) {
            results.add('AAAA Record: ${addr.address}');
          }
          break;

        default:
          // For other record types, we'd need a proper DNS library
          // This is a simplified implementation
          results
              .add('Note: $_selectedType records require advanced DNS lookup');
          results.add('Consider using a DNS library like dns_client');
      }

      setState(() {
        _result += results.join('\n');
        _result +=
            '\n\nDNS Server: ${Platform.localeName.contains('WiFi') ? 'Router DNS' : 'System DNS'}\n';
        _result += 'Query Time: ${DateTime.now().toIso8601String()}\n';
        _isLookingUp = false;
      });
    } catch (e) {
      setState(() {
        _result += '\nError: ${e.toString()}';
        _isLookingUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DNS LOOKUP',
      activeCategory: ToolCategory.network,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'DOMAIN NAME'),
            const SizedBox(height: 8),
            AppInput(
              controller: _domainController,
              hintText: 'Enter domain (e.g., google.com)...',
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'RECORD TYPE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recordTypes.map((type) {
                final isSelected = type == _selectedType;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = type;
                      _result = '';
                    });
                  },
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
              child: AppButton(
                label: _isLookingUp ? 'LOOKING UP...' : 'DNS LOOKUP',
                icon: _isLookingUp ? Icons.hourglass_empty : Icons.dns_outlined,
                onPressed: _isLookingUp ? null : _lookupDns,
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'DNS RESULTS',
                monospace: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
