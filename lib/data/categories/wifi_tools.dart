import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// WIFI TOOLS
/// WiFi Scanning, Analysis & Configuration
/// ────────────────────────────────────────────────────────────

class WifiTools {
  WifiTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'wifi_scanner',
      name: 'WiFi Scanner',
      description:
          'Scan nearby WiFi networks with signal strength, channel, and security info.',
      category: ToolCategory.wifi,
      icon: Icons.wifi_find,
      tags: ['wifi', 'scan', 'rssi', 'network'],
      isAvailable: true,
      routePath: '/wifi/scanner',
    ),
    ToolModel(
      id: 'wifi_qr',
      name: 'WiFi QR Generator',
      description: 'Generate WiFi QR codes for easy network sharing.',
      category: ToolCategory.wifi,
      icon: Icons.qr_code,
      tags: ['wifi', 'qr', 'share', 'network'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'wifi_config_gen',
      name: 'WPA3 Config Generator',
      description: 'Generate WPA3 configuration templates for access points.',
      category: ToolCategory.wifi,
      icon: Icons.router_outlined,
      tags: ['wpa3', 'wifi', 'config', 'security'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'wifi_channel_calc',
      name: 'Channel Optimizer',
      description:
          'Calculate optimal WiFi channel based on nearby networks and interference.',
      category: ToolCategory.wifi,
      icon: Icons.tune,
      tags: ['wifi', 'channel', '2.4ghz', '5ghz'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'wifi_range_calc',
      name: 'WiFi Range Calculator',
      description:
          'Estimate WiFi coverage range using the Friis transmission model.',
      category: ToolCategory.wifi,
      icon: Icons.signal_cellular_alt,
      tags: ['wifi', 'range', 'friis', 'signal'],
      isAvailable: false,
    ),
  ];
}
