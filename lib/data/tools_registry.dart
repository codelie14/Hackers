import 'package:flutter/material.dart';
import 'models/tool_model.dart';

// Import all category files
import 'categories/crypto_tools.dart';
import 'categories/password_tools.dart';
import 'categories/encode_decode_tools.dart';
import 'categories/file_security_tools.dart';
import 'categories/network_tools.dart';
import 'categories/wifi_tools.dart';
import 'categories/developer_tools.dart';
import 'categories/system_tools.dart';
import 'categories/forensics_tools.dart';
import 'categories/osint_tools.dart';
import 'categories/steganography_tools.dart';
import 'categories/code_analysis_tools.dart';
import 'categories/qr_barcode_tools.dart';
import 'categories/privacy_tools.dart';
import 'categories/encoding_utils_tools.dart';

// ─── Route IDs ─────────────────────────────────────────────
// Implemented tools have a routePath matching a screen widget that exists.
// All others are shown as "COMING SOON" cards in the category screen.

class ToolsRegistry {
  ToolsRegistry._();

  static List<ToolModel> get all => [
    // Crypto tools
    ...CryptoTools.all,

    // Password tools
    ...PasswordTools.all,

    // Encode/Decode tools
    ...EncodeDecodeTools.all,

    // File Security tools
    ...FileSecurityTools.all,

    // Network tools
    ...NetworkTools.all,

    // WiFi tools
    ...WifiTools.all,

    // Developer tools
    ...DeveloperTools.all,

    // System tools
    ...SystemTools.all,

    // Forensics tools
    ...ForensicsTools.all,

    // OSINT tools
    ...OsintTools.all,

    // Steganography tools
    ...SteganographyTools.all,

    // Code Analysis tools
    ...CodeAnalysisTools.all,

    // QR & Barcode tools
    ...QrBarcodeTools.all,

    // Privacy tools
    ...PrivacyTools.all,

    // Encoding Utils tools
    ...EncodingUtilsTools.all,
  ];

  static List<ToolModel> byCategory(ToolCategory category) {
    return all.where((t) => t.category == category).toList();
  }

  static List<ToolModel> available() {
    return all.where((t) => t.isAvailable).toList();
  }

  static List<ToolModel> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    return all.where((t) {
      return t.name.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q) ||
          t.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  static int countByCategory(ToolCategory category) {
    return all.where((t) => t.category == category).length;
  }

  static int countAvailableByCategory(ToolCategory category) {
    return all.where((t) => t.category == category && t.isAvailable).length;
  }
}
