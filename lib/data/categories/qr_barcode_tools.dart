import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// QR CODE & BARCODE TOOLS
/// Generate and Analyze QR Codes and Barcodes
/// ────────────────────────────────────────────────────────────

class QrBarcodeTools {
  QrBarcodeTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'qr_generator',
      name: 'QR Code Generator',
      description:
          'Generate QR codes for text, URLs, email, WiFi, and vCard contacts.',
      category: ToolCategory.qrBarcode,
      icon: Icons.qr_code_2,
      tags: ['qr', 'code', 'generate', 'url', 'wifi', 'vcard'],
      isAvailable: true,
      routePath: '/qr/generator',
    ),
    ToolModel(
      id: 'barcode_gen',
      name: 'Barcode Generator',
      description: 'Generate Code128, EAN-13, EAN-8, and Code39 barcodes.',
      category: ToolCategory.qrBarcode,
      icon: Icons.view_week_outlined,
      tags: ['barcode', 'code128', 'ean13', 'generate'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'qr_analyzer',
      name: 'QR Content Analyzer',
      description:
          'Analyze QR code content to detect phishing URLs and malicious data.',
      category: ToolCategory.qrBarcode,
      icon: Icons.policy_outlined,
      tags: ['qr', 'analyze', 'phishing', 'security', 'detect'],
      isAvailable: true,
      routePath: '/qr/analyzer',
    ),
    ToolModel(
      id: 'qr_custom',
      name: 'Custom QR Designer',
      description: 'Create QR codes with custom colors, logos, and styles.',
      category: ToolCategory.qrBarcode,
      icon: Icons.palette_outlined,
      tags: ['qr', 'custom', 'design', 'logo', 'color'],
      isAvailable: true,
      routePath: '/qr/custom',
    ),
    ToolModel(
      id: 'qr_batch',
      name: 'Batch QR Generator',
      description:
          'Generate multiple QR codes at once from a CSV or text list.',
      category: ToolCategory.qrBarcode,
      icon: Icons.dynamic_feed,
      tags: ['qr', 'batch', 'bulk', 'generate'],
      isAvailable: false,
    ),
  ];
}
