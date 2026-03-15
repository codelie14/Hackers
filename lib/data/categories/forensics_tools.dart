import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// FORENSICS TOOLS
/// Digital Forensics & Analysis
/// ────────────────────────────────────────────────────────────

class ForensicsTools {
  ForensicsTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'exif_extractor',
      name: 'EXIF Data Extractor',
      description:
          'Extract EXIF metadata from images including GPS, camera model, and timestamps.',
      category: ToolCategory.forensics,
      icon: Icons.photo_camera_outlined,
      tags: ['exif', 'metadata', 'gps', 'image'],
      isAvailable: true,
      routePath: '/forensics/exif-extractor',
    ),
    ToolModel(
      id: 'exif_remover',
      name: 'EXIF Metadata Remover',
      description: 'Strip EXIF and metadata from images to protect privacy.',
      category: ToolCategory.forensics,
      icon: Icons.no_photography_outlined,
      tags: ['exif', 'metadata', 'remove', 'privacy'],
      isAvailable: true,
      routePath: '/forensics/exif-remover',
    ),
    ToolModel(
      id: 'hex_dump',
      name: 'Hex Dump Viewer',
      description: 'View file content as a hex dump with ASCII sidebar.',
      category: ToolCategory.forensics,
      icon: Icons.memory,
      tags: ['hex', 'dump', 'binary', 'viewer'],
      isAvailable: true,
      routePath: '/forensics/hex-dump',
    ),
    ToolModel(
      id: 'strings_extractor',
      name: 'Strings Extractor',
      description:
          'Extract readable ASCII and Unicode strings from binary files.',
      category: ToolCategory.forensics,
      icon: Icons.text_snippet_outlined,
      tags: ['strings', 'binary', 'extract', 'forensics'],
      isAvailable: true,
      routePath: '/forensics/strings-extractor',
    ),
    ToolModel(
      id: 'file_entropy',
      name: 'File Entropy Visualizer',
      description:
          'Visualize entropy of file sections to detect encrypted/packed content.',
      category: ToolCategory.forensics,
      icon: Icons.bar_chart,
      tags: ['entropy', 'file', 'encryption', 'detect'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'lsb_detector',
      name: 'LSB Steganography Detector',
      description: 'Detect least-significant-bit steganography in images.',
      category: ToolCategory.forensics,
      icon: Icons.image_search,
      tags: ['lsb', 'steganography', 'detect', 'image'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'log_analyzer',
      name: 'Log Analyzer',
      description:
          'Parse and analyze syslog, Apache, Nginx, and SSH auth logs.',
      category: ToolCategory.forensics,
      icon: Icons.list_alt_outlined,
      tags: ['log', 'analyze', 'syslog', 'apache', 'nginx'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'timeline_builder',
      name: 'Timeline Builder',
      description: 'Build a chronological event timeline from log files.',
      category: ToolCategory.forensics,
      icon: Icons.timeline,
      tags: ['timeline', 'events', 'forensics', 'log'],
      isAvailable: false,
    ),
  ];
}
