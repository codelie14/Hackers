import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// SYSTEM TOOLS
/// System Information & Monitoring
/// ────────────────────────────────────────────────────────────

class SystemTools {
  SystemTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'system_info',
      name: 'System Information',
      description: 'View OS, CPU, RAM, storage, and hardware details.',
      category: ToolCategory.systemTools,
      icon: Icons.info_outline,
      tags: ['system', 'os', 'cpu', 'ram', 'info'],
      isAvailable: true,
      routePath: '/system/info',
    ),
    ToolModel(
      id: 'network_info',
      name: 'Network Information',
      description:
          'View network interfaces, local IP, MAC address, and routing table.',
      category: ToolCategory.systemTools,
      icon: Icons.network_check,
      tags: ['network', 'ip', 'mac', 'interface'],
      isAvailable: true,
      routePath: '/system/network-info',
    ),
    ToolModel(
      id: 'env_variables',
      name: 'Environment Variables',
      description: 'Read, search, and export system environment variables.',
      category: ToolCategory.systemTools,
      icon: Icons.settings_suggest_outlined,
      tags: ['env', 'environment', 'variables', 'system'],
      isAvailable: true,
      routePath: '/system/env-variables',
    ),
    ToolModel(
      id: 'cpu_monitor',
      name: 'CPU & RAM Monitor',
      description:
          'Real-time CPU usage and RAM consumption monitoring with graphs.',
      category: ToolCategory.systemTools,
      icon: Icons.monitor_heart_outlined,
      tags: ['cpu', 'ram', 'monitor', 'performance'],
      isAvailable: true,
      routePath: '/system/cpu-monitor',
    ),
    ToolModel(
      id: 'security_audit',
      name: 'System Security Audit',
      description:
          'Check open ports, SUID files, service analysis, and SSH config audit.',
      category: ToolCategory.systemTools,
      icon: Icons.security_update_good,
      tags: ['audit', 'security', 'suid', 'ssh', 'ports'],
      isAvailable: true,
      routePath: '/system/security-audit',
    ),
    ToolModel(
      id: 'system_report',
      name: 'System Report Generator',
      description:
          'Generate a comprehensive system report and export as JSON or PDF.',
      category: ToolCategory.systemTools,
      icon: Icons.summarize_outlined,
      tags: ['report', 'system', 'export', 'json'],
      isAvailable: true,
      routePath: '/system/report',
    ),
  ];
}
