import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// STEGANOGRAPHY TOOLS
/// Hide and Detect Data in Images
/// ────────────────────────────────────────────────────────────

class SteganographyTools {
  SteganographyTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'lsb_encode',
      name: 'LSB Text Encoder',
      description: 'Hide secret text inside an image using LSB steganography.',
      category: ToolCategory.steganography,
      icon: Icons.hide_image_outlined,
      tags: ['lsb', 'steganography', 'encode', 'hide', 'image'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'lsb_decode',
      name: 'LSB Text Decoder',
      description:
          'Extract hidden text from an image encoded with LSB steganography.',
      category: ToolCategory.steganography,
      icon: Icons.image_search,
      tags: ['lsb', 'steganography', 'decode', 'extract'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'lsb_password',
      name: 'LSB + AES Encoder',
      description:
          'Encode a message into an image with password-based AES encryption.',
      category: ToolCategory.steganography,
      icon: Icons.lock_outlined,
      tags: ['lsb', 'aes', 'encrypt', 'steganography'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'bit_planes',
      name: 'Bit Plane Visualizer',
      description:
          'Visualize each bit plane of an image for steganographic analysis.',
      category: ToolCategory.steganography,
      icon: Icons.layers_outlined,
      tags: ['bit', 'planes', 'visualize', 'steganalysis'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'chi_square_test',
      name: 'Chi-Square Steganalysis',
      description:
          'Perform chi-square test to detect LSB steganography in images.',
      category: ToolCategory.steganography,
      icon: Icons.analytics_outlined,
      tags: ['chi-square', 'steganalysis', 'detection'],
      isAvailable: false,
    ),
  ];
}
