import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class SecurityAuditWidget extends ConsumerStatefulWidget {
  const SecurityAuditWidget({super.key});

  @override
  ConsumerState<SecurityAuditWidget> createState() =>
      _SecurityAuditWidgetState();
}

class _SecurityAuditWidgetState extends ConsumerState<SecurityAuditWidget> {
  bool _isAuditing = false;
  Map<String, dynamic>? _auditResults;

  Future<void> _runSecurityAudit() async {
    setState(() {
      _isAuditing = true;
      _auditResults = null;
    });

    // Simulate security audit checks
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _auditResults = {
        'score': 78,
        'checks': [
          {
            'name': 'Open Ports',
            'status': 'warning',
            'details': '3 ports open (22, 80, 443)',
            'recommendation': 'Close unnecessary ports',
          },
          {
            'name': 'Firewall Status',
            'status': 'success',
            'details': 'Firewall is active',
            'recommendation': null,
          },
          {
            'name': 'SSH Configuration',
            'status': 'success',
            'details': 'Root login disabled, key-based auth enabled',
            'recommendation': null,
          },
          {
            'name': 'SUID Files',
            'status': 'warning',
            'details': '12 SUID binaries found',
            'recommendation': 'Review unusual SUID files',
          },
          {
            'name': 'System Updates',
            'status': 'error',
            'details': '5 security updates available',
            'recommendation': 'Install pending updates',
          },
          {
            'name': 'Password Policy',
            'status': 'success',
            'details': 'Strong password policy enforced',
            'recommendation': null,
          },
        ],
      };
      _isAuditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Security Audit',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'System Security Audit',
              subtitle: 'Analyze system security configuration',
            ),
            const SizedBox(height: 24),
            AppButton(
              label: _isAuditing ? 'Running Audit...' : 'Run Security Audit',
              onPressed: _isAuditing ? null : _runSecurityAudit,
              isLoading: _isAuditing,
            ),
            if (_auditResults != null) ...[
              const SizedBox(height: 32),

              // Security Score
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getScoreColor(_auditResults!['score']),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      _auditResults!['score'] >= 70
                          ? Icons.security
                          : Icons.warning,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Security Score',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_auditResults!['score']}/100',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getScoreMessage(_auditResults!['score']),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Audit Checks
              Text(
                'Security Checks',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              ...(_auditResults!['checks'] as List).map((check) {
                return _buildCheckCard(check as Map<String, dynamic>);
              }).toList(),
            ],
            if (!_isAuditing && _auditResults == null) ...[
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.security_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Click the button above to run\na comprehensive security audit',
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

  Widget _buildCheckCard(Map<String, dynamic> check) {
    final status = check['status'] as String;
    final statusColor = status == 'success'
        ? AppColors.success
        : status == 'warning'
            ? AppColors.warning
            : AppColors.danger;

    final statusIcon = status == 'success'
        ? Icons.check_circle_outline
        : status == 'warning'
            ? Icons.warning_outlined
            : Icons.error_outline;

    return Card(
      color: AppColors.bgSurface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    check['name'] as String,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              check['details'] as String,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
            if (check['recommendation'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 16, color: statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        check['recommendation'] as String,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: statusColor,
                        ),
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

  List<Color> _getScoreColor(int score) {
    if (score >= 70) {
      return [AppColors.successDim, AppColors.bgSurface];
    } else if (score >= 40) {
      return [AppColors.warningDim, AppColors.bgSurface];
    } else {
      return [AppColors.dangerDim, AppColors.bgSurface];
    }
  }

  String _getScoreMessage(int score) {
    if (score >= 90) return 'Excellent security posture';
    if (score >= 70) return 'Good, minor improvements needed';
    if (score >= 50) return 'Fair, review recommendations';
    return 'Poor, immediate action required';
  }
}
