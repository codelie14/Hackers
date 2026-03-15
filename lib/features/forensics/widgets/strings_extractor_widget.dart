import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class StringsExtractorWidget extends ConsumerStatefulWidget {
  const StringsExtractorWidget({super.key});

  @override
  ConsumerState<StringsExtractorWidget> createState() =>
      _StringsExtractorWidgetState();
}

class _StringsExtractorWidgetState
    extends ConsumerState<StringsExtractorWidget> {
  String? _fileName;
  List<String>? _extractedStrings;
  bool _isExtracting = false;
  int _minLength = 4;

  Future<void> _extractStrings() async {
    setState(() {
      _isExtracting = true;
      _extractedStrings = null;
    });

    // Simulate file loading and string extraction
    await Future.delayed(const Duration(seconds: 2));

    // Simulated binary data with embedded strings
    final simulatedBinary = utf8.encode(
        'This is a test binary file\x00with some embedded strings\x00and more text here\x00');

    setState(() {
      _fileName = 'binary_file.exe';
      _extractedStrings = [
        'This is a test binary file',
        'with some embedded strings',
        'and more text here',
        'Copyright (c) 2024',
        'Version 1.0.0',
        'User-Agent: Mozilla/5.0',
        'Content-Type: application/json',
        'Authorization: Bearer token',
      ];
      _isExtracting = false;
    });
  }

  void _copyAll() {
    if (_extractedStrings != null) {
      Clipboard.setData(ClipboardData(text: _extractedStrings!.join('\n')));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All strings copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Strings Extractor',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeader(
                  title: 'Strings Extractor',
                  subtitle: 'Extract readable text from binary files',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: _isExtracting
                            ? 'Extracting...'
                            : 'Select Binary File',
                        onPressed: _isExtracting ? null : _extractStrings,
                        isLoading: _isExtracting,
                        icon: Icons.text_snippet_outlined,
                      ),
                    ),
                    if (_extractedStrings != null) ...[
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
              ],
            ),
          ),
          const Divider(height: 1),
          if (_extractedStrings == null)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.text_snippet_outlined,
                        size: 64, color: AppColors.textMuted),
                    SizedBox(height: 16),
                    Text(
                      'Load a binary file to extract\nreadable ASCII strings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                color: AppColors.bgSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.infoDim,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.info),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.find_in_page, color: AppColors.info),
                          const SizedBox(width: 12),
                          Text(
                            '${_extractedStrings!.length} strings extracted from $_fileName',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 12,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Extracted Strings',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        itemCount: _extractedStrings!.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final str = _extractedStrings![index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            leading: Icon(Icons.short_text,
                                size: 18, color: AppColors.accent),
                            title: SelectableText(
                              str,
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 11,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy, size: 16),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: str));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('String copied'),
                                      duration: Duration(seconds: 1)),
                                );
                              },
                              color: AppColors.accent,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
