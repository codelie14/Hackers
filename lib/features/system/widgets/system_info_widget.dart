import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../data/models/tool_model.dart';

class SystemInfoWidget extends ConsumerStatefulWidget {
  const SystemInfoWidget({super.key});

  @override
  ConsumerState<SystemInfoWidget> createState() => _SystemInfoWidgetState();
}

class _SystemInfoWidgetState extends ConsumerState<SystemInfoWidget> {
  late Map<String, String> _systemInfo;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  void _loadSystemInfo() {
    final info = <String, String>{};

    // Platform Info
    info['Operating System'] = Platform.operatingSystem;
    info['OS Version'] = Platform.operatingSystemVersion;
    info['Local Hostname'] = Platform.localHostname;

    // Environment
    info['Username'] = Platform.environment['USERNAME'] ??
        Platform.environment['USER'] ??
        'Unknown';
    info['Home Path'] = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        'N/A';

    // Locale
    info['Locale'] = Platform.localeName;
    info['Timezone'] = DateTime.now().timeZoneName;
    info['Script Token'] = Platform.script.toString();

    // Process Info
    info['PID'] = pid.toString();
    info['Executable'] = Platform.executable;
    info['Resolved Executable'] = Platform.resolvedExecutable;
    info['Package Config'] = Platform.packageConfig.toString();

    // Architecture
    info['Architecture'] = 'Unknown'; // dart:io doesn't expose this directly

    setState(() => _systemInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SYSTEM INFORMATION',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.info_outline,
                        color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SYSTEM INFO',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _systemInfo['Operating System'] ?? 'Loading...',
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const SectionHeader(title: 'DETAILED INFORMATION'),
            const SizedBox(height: 12),

            // Info List
            ..._systemInfo.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: SelectableText(
                        entry.value,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
