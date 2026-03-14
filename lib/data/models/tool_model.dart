import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ToolCategory {
  crypto,
  password,
  encodeDecode,
  fileSecurity,
  network,
  wifi,
  developer,
  encodingUtils,
  forensics,
  systemTools,
  osint,
  steganography,
  codeAnalysis,
  qrBarcode,
  privacy,
}

extension ToolCategoryExtension on ToolCategory {
  String get displayName {
    switch (this) {
      case ToolCategory.crypto: return 'Cryptography';
      case ToolCategory.password: return 'Password Toolkit';
      case ToolCategory.encodeDecode: return 'Encode / Decode';
      case ToolCategory.fileSecurity: return 'File Security';
      case ToolCategory.network: return 'Network Tools';
      case ToolCategory.wifi: return 'WiFi Tools';
      case ToolCategory.developer: return 'Developer Tools';
      case ToolCategory.encodingUtils: return 'Encoding Utils';
      case ToolCategory.forensics: return 'Forensics';
      case ToolCategory.systemTools: return 'System Tools';
      case ToolCategory.osint: return 'OSINT Tools';
      case ToolCategory.steganography: return 'Steganography';
      case ToolCategory.codeAnalysis: return 'Code Analysis';
      case ToolCategory.qrBarcode: return 'QR & Barcode';
      case ToolCategory.privacy: return 'Privacy Tools';
    }
  }

  String get shortName {
    switch (this) {
      case ToolCategory.crypto: return 'CRYPTO';
      case ToolCategory.password: return 'PWD';
      case ToolCategory.encodeDecode: return 'ENCODE';
      case ToolCategory.fileSecurity: return 'FILE';
      case ToolCategory.network: return 'NETWORK';
      case ToolCategory.wifi: return 'WIFI';
      case ToolCategory.developer: return 'DEV';
      case ToolCategory.encodingUtils: return 'UTILS';
      case ToolCategory.forensics: return 'FORENSICS';
      case ToolCategory.systemTools: return 'SYSTEM';
      case ToolCategory.osint: return 'OSINT';
      case ToolCategory.steganography: return 'STEGO';
      case ToolCategory.codeAnalysis: return 'CODE';
      case ToolCategory.qrBarcode: return 'QR';
      case ToolCategory.privacy: return 'PRIVACY';
    }
  }

  Color get color {
    switch (this) {
      case ToolCategory.crypto: return AppColors.catCrypto;
      case ToolCategory.password: return AppColors.catPassword;
      case ToolCategory.encodeDecode: return AppColors.catEncode;
      case ToolCategory.fileSecurity: return AppColors.catFile;
      case ToolCategory.network: return AppColors.catNetwork;
      case ToolCategory.wifi: return AppColors.catWifi;
      case ToolCategory.developer: return AppColors.catDeveloper;
      case ToolCategory.encodingUtils: return AppColors.catEncoding;
      case ToolCategory.forensics: return AppColors.catForensics;
      case ToolCategory.systemTools: return AppColors.catSystem;
      case ToolCategory.osint: return AppColors.catOsint;
      case ToolCategory.steganography: return AppColors.catStego;
      case ToolCategory.codeAnalysis: return AppColors.catCode;
      case ToolCategory.qrBarcode: return AppColors.catQr;
      case ToolCategory.privacy: return AppColors.catPrivacy;
    }
  }

  IconData get icon {
    switch (this) {
      case ToolCategory.crypto: return Icons.lock_outline;
      case ToolCategory.password: return Icons.key_outlined;
      case ToolCategory.encodeDecode: return Icons.swap_horiz;
      case ToolCategory.fileSecurity: return Icons.insert_drive_file_outlined;
      case ToolCategory.network: return Icons.lan_outlined;
      case ToolCategory.wifi: return Icons.wifi;
      case ToolCategory.developer: return Icons.code;
      case ToolCategory.encodingUtils: return Icons.tag;
      case ToolCategory.forensics: return Icons.search;
      case ToolCategory.systemTools: return Icons.computer;
      case ToolCategory.osint: return Icons.travel_explore;
      case ToolCategory.steganography: return Icons.hide_image_outlined;
      case ToolCategory.codeAnalysis: return Icons.analytics_outlined;
      case ToolCategory.qrBarcode: return Icons.qr_code_2;
      case ToolCategory.privacy: return Icons.privacy_tip_outlined;
    }
  }
}

class ToolModel {
  final String id;
  final String name;
  final String description;
  final ToolCategory category;
  final IconData icon;
  final List<String> tags;
  final bool isAvailable;
  final bool requiresNetwork;
  final String? routePath;

  const ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    this.tags = const [],
    this.isAvailable = false,
    this.requiresNetwork = false,
    this.routePath,
  });
}
