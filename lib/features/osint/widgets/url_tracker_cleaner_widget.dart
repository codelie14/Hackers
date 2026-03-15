import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class UrlTrackerCleanerWidget extends ConsumerStatefulWidget {
  const UrlTrackerCleanerWidget({super.key});

  @override
  ConsumerState<UrlTrackerCleanerWidget> createState() =>
      _UrlTrackerCleanerWidgetState();
}

class _UrlTrackerCleanerWidgetState
    extends ConsumerState<UrlTrackerCleanerWidget> {
  final _urlController = TextEditingController();
  String? _cleanedUrl;
  List<String>? _removedParams;

  // Tracking parameters to remove
  final List<String> _trackingParams = [
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
    'fbclid',
    'gclid',
    'ga_campaign',
    'ga_source',
    'ga_medium',
    'ga_term',
    'ga_content',
    'ref_src',
    'ref_url',
    'pk_campaign',
    'pk_kwd',
    'mc_cid',
    'mc_eid',
    '_bhs_tid',
    '_bhs_sid',
  ];

  void _cleanUrl() {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      final removed = <String>[];
      final cleanParams = Map<String, String>.from(uri.queryParameters);

      // Remove tracking parameters
      for (final param in _trackingParams) {
        if (cleanParams.containsKey(param)) {
          cleanParams.remove(param);
          removed.add(param);
        }
      }

      // Reconstruct clean URL
      final cleanUri = uri.replace(
          queryParameters: cleanParams.isEmpty ? null : cleanParams);

      setState(() {
        _cleanedUrl = cleanUri.toString();
        _removedParams = removed;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL format')),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'URL Tracker Cleaner',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'URL Tracker Cleaner',
              subtitle: 'Remove tracking parameters from URLs',
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _urlController,
              labelText: 'Paste URL with Trackers',
              hintText: 'https://example.com?utm_source=...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Clean URL',
              onPressed: _cleanUrl,
              icon: Icons.cleaning_services,
            ),
            if (_cleanedUrl != null) ...[
              const SizedBox(height: 24),

              // Success Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.successDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 48, color: AppColors.success),
                    const SizedBox(height: 16),
                    Text(
                      'URL Cleaned Successfully',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_removedParams!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Removed ${_removedParams!.length} tracking parameters',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Removed Parameters
              if (_removedParams!.isNotEmpty) ...[
                Text(
                  'Removed Tracking Parameters',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _removedParams!.map((param) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.dangerDim,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.danger),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.remove_circle_outline,
                              size: 14, color: AppColors.danger),
                          const SizedBox(width: 4),
                          Text(
                            param,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Clean URL Display
              Text(
                'Clean URL',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _cleanedUrl!,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Copy URL',
                            onPressed: () => _copyToClipboard(_cleanedUrl!),
                            variant: AppButtonVariant.secondary,
                            icon: Icons.copy,
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Would open in browser')),
                            );
                          },
                          color: AppColors.success,
                          tooltip: 'Open',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (_cleanedUrl == null) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.link_off_outlined,
                        size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Removes UTM codes, Facebook clicks,\nGoogle Ads IDs, and other trackers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.infoDim,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Common Tracking Parameters:',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'utm_*',
                              'fbclid',
                              'gclid',
                              'mc_*',
                              'pk_*'
                            ].map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    color: AppColors.info,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
    _urlController.dispose();
    super.dispose();
  }
}
