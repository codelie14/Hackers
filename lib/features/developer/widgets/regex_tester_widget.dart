import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/regex_tester_service.dart';

class RegexTesterWidget extends ConsumerStatefulWidget {
  const RegexTesterWidget({super.key});

  @override
  ConsumerState<RegexTesterWidget> createState() => _RegexTesterWidgetState();
}

class _RegexTesterWidgetState extends ConsumerState<RegexTesterWidget> {
  final _patternController = TextEditingController();
  final _textController = TextEditingController();
  
  bool _caseInsensitive = false;
  bool _multiLine = false;
  bool _dotAll = false;
  
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void dispose() {
    _patternController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _testRegex() {
    final pattern = _patternController.text.trim();
    final text = _textController.text;

    if (pattern.isEmpty) {
      setState(() => _error = 'Please enter a regex pattern');
      return;
    }

    if (text.isEmpty) {
      setState(() => _error = 'Please enter text to test against');
      return;
    }

    setState(() {
      _error = null;
      _result = null;
    });

    // Small delay for UX
    Future.delayed(const Duration(milliseconds: 50), () {
      final result = RegexTesterService.testRegex(
        pattern: pattern,
        text: text,
        caseInsensitive: _caseInsensitive,
        multiLine: _multiLine,
        dotAll: _dotAll,
      );

      setState(() {
        _result = result;
        if (!result['success']) {
          _error = result['error'];
        }
      });
    });
  }

  void _loadExample(String type) {
    switch (type) {
      case 'email':
        _patternController.text = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
        _textController.text = 'Contact us at support@example.com or sales@test.co.uk';
        break;
      case 'phone':
        _patternController.text = r'\+?[\d\s-()]+';
        _textController.text = 'Call +1-555-123-4567 or (555) 987-6543';
        break;
      case 'date':
        _patternController.text = r'\d{4}-\d{2}-\d{2}';
        _textController.text = 'Meeting scheduled for 2024-03-15 and 2024-12-25';
        break;
      case 'url':
        _patternController.text = r'https?://[^\s]+';
        _textController.text = 'Visit https://example.com or http://test.org/path';
        break;
    }
    setState(() {
      _result = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'REGEX TESTER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pattern input
            const SectionHeader(title: 'Regex Pattern'),
            const SizedBox(height: 8),
            AppInput(
              controller: _patternController,
              hintText: r'Enter regex pattern (e.g., \d+)',
              maxLines: 2,
              prefixText: '/',
              onChanged: (_) {
                if (_result != null) setState(() => _result = null);
              },
            ),

            const SizedBox(height: 12),
            
            // Flags
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _FlagToggle(
                    label: 'i',
                    description: 'Case insensitive',
                    value: _caseInsensitive,
                    onChanged: (v) {
                      setState(() {
                        _caseInsensitive = v;
                        _result = null;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _FlagToggle(
                    label: 'm',
                    description: 'Multi-line',
                    value: _multiLine,
                    onChanged: (v) {
                      setState(() {
                        _multiLine = v;
                        _result = null;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _FlagToggle(
                    label: 's',
                    description: 'Dot matches all',
                    value: _dotAll,
                    onChanged: (v) {
                      setState(() {
                        _dotAll = v;
                        _result = null;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            
            // Example patterns
            const SectionHeader(title: 'Quick Examples'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ExampleChip(label: 'Email', onTap: () => _loadExample('email')),
                _ExampleChip(label: 'Phone', onTap: () => _loadExample('phone')),
                _ExampleChip(label: 'Date', onTap: () => _loadExample('date')),
                _ExampleChip(label: 'URL', onTap: () => _loadExample('url')),
              ],
            ),

            const SizedBox(height: 16),
            
            // Test text
            const SectionHeader(title: 'Test Text'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _textController,
              hintText: 'Enter or paste text to test against the regex pattern...',
              minLines: 4,
              maxLines: 8,
              onChanged: (_) {
                if (_result != null) setState(() => _result = null);
              },
            ),

            const SizedBox(height: 20),
            
            // Test button
            ElevatedButton.icon(
              onPressed: _testRegex,
              icon: const Icon(Icons.science, size: 18),
              label: const Text('TEST REGEX'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dangerDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_result != null && _result!['success']) ...[
              const SizedBox(height: 24),
              
              // Results summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result!['hasMatches'] 
                      ? AppColors.successDim.withValues(alpha: 0.2)
                      : AppColors.warningDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _result!['hasMatches'] 
                        ? AppColors.success 
                        : AppColors.warning,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _result!['hasMatches'] 
                          ? Icons.check_circle_outline 
                          : Icons.info_outline,
                      color: _result!['hasMatches'] 
                          ? AppColors.success 
                          : AppColors.warning,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _result!['hasMatches'] 
                                ? '${_result!['matchCount']} MATCH${_result!['matchCount'] > 1 ? 'ES' : ''} FOUND'
                                : 'NO MATCHES',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _result!['hasMatches'] 
                                  ? AppColors.success 
                                  : AppColors.warning,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pattern: /${_result!['pattern']}/${_result!['flags']}',
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const SectionHeader(title: 'Match Details'),
              const SizedBox(height: 8),

              // Match list
              ...(_result!['matches'] as List).asMap().entries.map((entry) {
                final index = entry.key;
                final match = entry.value as Map<String, dynamic>;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentGhost,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              'MATCH #${index + 1}',
                              style: const TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          CopyButton(text: match['match']),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        match['match'],
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Position: ${match['start']}–${match['end']} (${(match['end'] as int) - (match['start'] as int)} chars)',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                      
                      // Capture groups
                      if ((match['groups'] as List).isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.border),
                        const SizedBox(height: 8),
                        const Text(
                          'CAPTURE GROUPS:',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...(match['groups'] as List).asMap().entries.map((gEntry) {
                          final groupIndex = gEntry.key + 1;
                          final groupValue = gEntry.value;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text(
                                  '\$$groupIndex: ',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.info,
                                  ),
                                ),
                                Expanded(
                                  child: SelectableText(
                                    groupValue?.toString() ?? '(empty)',
                                    style: const TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 10,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlagToggle extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FlagToggle({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: value ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: value ? Colors.black : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 8,
                color: value ? Colors.black.withOpacity(0.7) : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ExampleChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
