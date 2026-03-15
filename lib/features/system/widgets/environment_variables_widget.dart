import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class EnvironmentVariablesWidget extends ConsumerStatefulWidget {
  const EnvironmentVariablesWidget({super.key});

  @override
  ConsumerState<EnvironmentVariablesWidget> createState() =>
      _EnvironmentVariablesWidgetState();
}

class _EnvironmentVariablesWidgetState
    extends ConsumerState<EnvironmentVariablesWidget> {
  Map<String, String> _envVars = {};
  List<MapEntry<String, String>> _filteredVars = [];
  final _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnvVariables();
    _searchController.addListener(_filterVars);
  }

  Future<void> _loadEnvVariables() async {
    setState(() => _isLoading = true);

    // Load environment variables
    final envMap = Platform.environment;
    setState(() {
      _envVars = envMap;
      _filteredVars = envMap.entries.toList();
      _isLoading = false;
    });
  }

  void _filterVars() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVars = _envVars.entries.where((entry) {
        return entry.key.toLowerCase().contains(query) ||
            entry.value.toLowerCase().contains(query);
      }).toList();

      // Sort alphabetically
      _filteredVars.sort((a, b) => a.key.compareTo(b.key));
    });
  }

  void _copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  void _exportToJson() {
    final jsonContent = const JsonEncoder.withIndent('  ').convert(_envVars);
    Clipboard.setData(ClipboardData(text: jsonContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exported to clipboard as JSON')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Environment Variables',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeader(
                  title: 'Environment Variables',
                  subtitle: 'View, search, and export system variables',
                ),
                const SizedBox(height: 16),
                AppInput(
                  controller: _searchController,
                  labelText: 'Search Variables',
                  hintText: 'Filter by name or value...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Export JSON',
                        onPressed: _exportToJson,
                        variant: AppButtonVariant.secondary,
                        icon: Icons.file_download,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredVars.length,
                itemBuilder: (context, index) {
                  final entry = _filteredVars[index];
                  return _buildEnvVarTile(entry.key, entry.value);
                },
              ),
            ),
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_filteredVars.length} of ${_envVars.length} variables',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnvVarTile(String key, String value) {
    return Card(
      color: AppColors.bgSurface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Text(
          key,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () => _copyToClipboard(value),
          tooltip: 'Copy value',
          color: AppColors.accent,
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Value:',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(value),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy Value'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
