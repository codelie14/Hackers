import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class DataExtractorWidget extends ConsumerStatefulWidget {
  const DataExtractorWidget({super.key});

  @override
  ConsumerState<DataExtractorWidget> createState() =>
      _DataExtractorWidgetState();
}

class _DataExtractorWidgetState extends ConsumerState<DataExtractorWidget> {
  final _inputController = TextEditingController();
  Map<String, List<String>>? _extractedData;

  // Regex patterns for extraction
  final Map<String, RegExp> _patterns = {
    'Email': RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
    'URL': RegExp(r'https?://[^\s<>"{}|\\^`\[\]]+'),
    'IPv4': RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b'),
    'Domain': RegExp(r'\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\b'),
    'Phone (US)':
        RegExp(r'(?:\+1[-.\s]?)?(?:\(?\d{3}\)?)[-.\s]?\d{3}[-.\s]?\d{4}'),
    'Bitcoin': RegExp(r'\b[13][a-km-zA-HJ-NP-Z1-9]{25,34}\b'),
    'Ethereum': RegExp(r'\b0x[a-fA-F0-9]{40}\b'),
  };

  void _extractData() {
    final text = _inputController.text;

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text')),
      );
      return;
    }

    final results = <String, List<String>>{};

    _patterns.forEach((type, pattern) {
      final matches = pattern.allMatches(text).map((m) => m.group(0)!).toList();
      if (matches.isNotEmpty) {
        results[type] = matches;
      }
    });

    setState(() => _extractedData = results);
  }

  void _copyAll() {
    if (_extractedData != null) {
      final allData = _extractedData!.values.expand((e) => e).join('\n');
      Clipboard.setData(ClipboardData(text: allData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data copied to clipboard')),
      );
    }
  }

  void _copyItem(String item) {
    Clipboard.setData(ClipboardData(text: item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Copied: $item'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Data Extractor',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Data Extractor',
              subtitle: 'Extract emails, IPs, domains, URLs, and more',
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _inputController,
              labelText: 'Paste Text Here',
              hintText: 'Paste any text content to extract data...',
              maxLines: 8,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Extract Data',
                    onPressed: _extractData,
                    icon: Icons.data_usage,
                  ),
                ),
                if (_extractedData != null) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyAll,
                    color: AppColors.accent,
                    tooltip: 'Copy all',
                  ),
                ],
              ],
            ),
            if (_extractedData != null && _extractedData!.isNotEmpty) ...[
              const SizedBox(height: 24),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Extraction Complete',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_extractedData!.values.fold<int>(0, (sum, list) => sum + list.length)} items found across ${_extractedData!.length} categories',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Results by Category
              ..._extractedData!.entries.map((entry) {
                return Card(
                  color: AppColors.bgSurface,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.folder_outlined,
                                color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 14,
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.infoDim,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${entry.value.length}',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        ...entry.value.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    item,
                                    style: const TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 16),
                                  onPressed: () => _copyItem(item),
                                  color: AppColors.accent,
                                  tooltip: 'Copy',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
            if (_extractedData == null || _extractedData!.isEmpty) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.content_paste_search_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Supported Patterns:\n• Email addresses\n• URLs\n• IP addresses\n• Domain names\n• Phone numbers\n• Cryptocurrency addresses',
                      textAlign: TextAlign.center,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
