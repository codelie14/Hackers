import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/jwt_decoder_service.dart';

class JwtDecoderWidget extends ConsumerStatefulWidget {
  const JwtDecoderWidget({super.key});

  @override
  ConsumerState<JwtDecoderWidget> createState() => _JwtDecoderWidgetState();
}

class _JwtDecoderWidgetState extends ConsumerState<JwtDecoderWidget>
    with SingleTickerProviderStateMixin {
  final _tokenController = TextEditingController();
  late TabController _tabController;
  
  Map<String, dynamic>? _decodedToken;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _decodeToken() {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Please enter a JWT token');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _decodedToken = null;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        final result = JwtDecoderService.decodeJwt(token);
        
        if (result['valid'] == true) {
          setState(() {
            _decodedToken = result;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = result['error'];
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    });
  }

  void _analyzeSecurity() {
    final token = _tokenController.text.trim();
    if (token.isEmpty) return;

    final analysis = JwtDecoderService.analyzeSecurity(token);
    
    showDialog(
      context: context,
      builder: (_) => _SecurityAnalysisDialog(analysis: analysis),
    );
  }

  void _loadSample() {
    final sample = JwtDecoderService.createSampleJwt();
    _tokenController.text = sample;
    setState(() {
      _decodedToken = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'JWT DECODER',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'JWT Token'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _tokenController,
              hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
              minLines: 4,
              maxLines: 8,
              onChanged: (_) {
                if (_decodedToken != null || _error != null) {
                  setState(() {
                    _decodedToken = null;
                    _error = null;
                  });
                }
              },
            ),
            
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loadSample,
                    icon: const Icon(Icons.science, size: 16),
                    label: const Text('LOAD SAMPLE'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _analyzeSecurity,
                    icon: const Icon(Icons.security, size: 16),
                    label: const Text('ANALYZE'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.info,
                      side: const BorderSide(color: AppColors.info),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            AppButton(
              label: 'DECODE TOKEN ▶',
              icon: Icons.lock_open,
              isLoading: _isLoading,
              fullWidth: true,
              onPressed: _decodeToken,
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

            if (_decodedToken != null) ...[
              const SizedBox(height: 24),
              // Token info bar
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _decodedToken!['isExpired'] 
                      ? AppColors.dangerDim.withValues(alpha: 0.2)
                      : AppColors.successDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _decodedToken!['isExpired'] 
                        ? AppColors.danger 
                        : AppColors.success,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _decodedToken!['isExpired'] 
                          ? Icons.cancel_outlined 
                          : Icons.check_circle_outline,
                      color: _decodedToken!['isExpired'] 
                          ? AppColors.danger 
                          : AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _decodedToken!['isExpired'] 
                                ? 'TOKEN EXPIRED' 
                                : 'TOKEN VALID',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _decodedToken!['isExpired'] 
                                  ? AppColors.danger 
                                  : AppColors.success,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Algorithm: ${_decodedToken!['algorithm']} | Type: ${_decodedToken!['tokenType']}',
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 9,
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
              // Tabs for Header, Payload, Signature
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.accent,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.accent,
                      tabs: const [
                        Tab(text: 'HEADER'),
                        Tab(text: 'PAYLOAD'),
                        Tab(text: 'SIGNATURE'),
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Header tab
                          _JsonViewer(data: _decodedToken!['header']),
                          
                          // Payload tab
                          _JsonViewer(data: _decodedToken!['payload']),
                          
                          // Signature tab
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SIGNATURE',
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: SelectableText(
                                      _decodedToken!['signature'],
                                      style: const TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontSize: 11,
                                        color: AppColors.textPrimary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    CopyButton(text: _decodedToken!['signature']),
                                  ],
                                ),
                              ],
                            ),
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
}

class _JsonViewer extends StatelessWidget {
  final Map<String, dynamic> data;

  const _JsonViewer({required this.data});

  @override
  Widget build(BuildContext context) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SelectableText(
          jsonString,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SecurityAnalysisDialog extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const _SecurityAnalysisDialog({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final score = analysis['score'] as int? ?? 0;
    final rating = analysis['rating'] as String? ?? 'Unknown';
    final issues = analysis['issues'] as List? ?? [];
    final warnings = analysis['warnings'] as List? ?? [];
    final recommendations = analysis['recommendations'] as List? ?? [];

    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'SECURITY ANALYSIS',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            
            // Score
            Center(
              child: Column(
                children: [
                  Text(
                    '$score/100',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  Text(
                    rating.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _getRatingColor(rating),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (issues.isNotEmpty) ...[
                      _Section(title: 'ISSUES', items: issues, color: AppColors.danger),
                      const SizedBox(height: 16),
                    ],
                    if (warnings.isNotEmpty) ...[
                      _Section(title: 'WARNINGS', items: warnings, color: AppColors.warning),
                      const SizedBox(height: 16),
                    ],
                    if (recommendations.isNotEmpty) ...[
                      _Section(title: 'RECOMMENDATIONS', items: recommendations, color: AppColors.info),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(String rating) {
    switch (rating.toLowerCase()) {
      case 'excellent': return AppColors.success;
      case 'good': return AppColors.info;
      case 'fair': return AppColors.warning;
      case 'poor': return AppColors.warning;
      case 'critical': return AppColors.danger;
      default: return AppColors.textSecondary;
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final Color color;

  const _Section({required this.title, required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(color: AppColors.textSecondary)),
              Expanded(
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
