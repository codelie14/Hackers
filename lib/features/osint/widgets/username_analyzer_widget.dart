import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class UsernameAnalyzerWidget extends ConsumerStatefulWidget {
  const UsernameAnalyzerWidget({super.key});

  @override
  ConsumerState<UsernameAnalyzerWidget> createState() =>
      _UsernameAnalyzerWidgetState();
}

class _UsernameAnalyzerWidgetState
    extends ConsumerState<UsernameAnalyzerWidget> {
  final _usernameController = TextEditingController();
  List<String>? _variations;
  Map<String, String>? _platformUrls;

  void _generateVariations() {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() {
      // Generate variations
      _variations = [
        username,
        username.toLowerCase(),
        username.toUpperCase(),
        '_$username',
        '${username}_',
        'TheReal$username',
        'Official$username',
        username
            .replaceAll('a', '@')
            .replaceAll('e', '3')
            .replaceAll('i', '1')
            .replaceAll('o', '0'),
        '${username}2024',
        '${username}123',
      ];

      // Generate platform URLs
      _platformUrls = {
        'Twitter': 'https://twitter.com/$username',
        'Instagram': 'https://instagram.com/$username',
        'Facebook': 'https://facebook.com/$username',
        'GitHub': 'https://github.com/$username',
        'TikTok': 'https://tiktok.com/@$username',
        'LinkedIn': 'https://linkedin.com/in/$username',
        'Reddit': 'https://reddit.com/user/$username',
        'Pinterest': 'https://pinterest.com/$username',
      };
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Copied: $text'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Username Analyzer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'Username Analyzer',
              subtitle: 'Generate variations and check platforms',
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _usernameController,
              labelText: 'Target Username',
              hintText: 'e.g., johndoe',
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Generate Variations',
              onPressed: _generateVariations,
              icon: Icons.people_alt,
            ),
            if (_variations != null) ...[
              const SizedBox(height: 24),

              // Variations
              Text(
                'Username Variations',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._variations!.map((variation) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SelectableText(
                                  variation,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 16),
                                onPressed: () => _copyToClipboard(variation),
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
              ),

              const SizedBox(height: 24),

              // Platform URLs
              Text(
                'Platform Profile URLs',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._platformUrls!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SelectableText(
                                  entry.value,
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 16),
                                onPressed: () => _copyToClipboard(entry.value),
                                color: AppColors.accent,
                                tooltip: 'Copy URL',
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
            if (_variations == null) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.person_search_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Enter a username to generate\nvariations and platform URLs',
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
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
