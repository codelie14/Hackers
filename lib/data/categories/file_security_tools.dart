import 'package:flutter/material.dart';
import '../models/tool_model.dart';

/// ────────────────────────────────────────────────────────────
/// FILE SECURITY TOOLS
/// File Hashing, Analysis & Integrity
/// ────────────────────────────────────────────────────────────

class FileSecurityTools {
  FileSecurityTools._();

  static const List<ToolModel> all = [
    ToolModel(
      id: 'file_hash',
      name: 'File Hash Calculator',
      description: 'Compute MD5, SHA1, SHA256, SHA512 hashes for any file.',
      category: ToolCategory.fileSecurity,
      icon: Icons.folder_outlined,
      tags: ['file', 'hash', 'md5', 'sha256', 'integrity'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'file_hash_compare',
      name: 'File Hash Comparator',
      description:
          'Verify file integrity by comparing computed hash against expected value.',
      category: ToolCategory.fileSecurity,
      icon: Icons.compare,
      tags: ['file', 'hash', 'compare', 'verify'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'magic_bytes',
      name: 'File Signature Analyzer',
      description:
          'Detect file type from magic bytes (file header) — real MIME detection.',
      category: ToolCategory.fileSecurity,
      icon: Icons.code,
      tags: ['magic', 'bytes', 'mime', 'file', 'header'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'integrity_report',
      name: 'Integrity Report Generator',
      description: 'Generate a full hash report for a directory of files.',
      category: ToolCategory.fileSecurity,
      icon: Icons.summarize,
      tags: ['report', 'integrity', 'hash'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'entropy_analyzer_file',
      name: 'File Entropy Analysis',
      description:
          'Analyze file entropy byte-by-byte to detect encrypted or compressed sections.',
      category: ToolCategory.fileSecurity,
      icon: Icons.bar_chart,
      tags: ['entropy', 'file', 'analysis', 'crypto'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'pe_header_analyzer',
      name: 'PE Header Analyzer',
      description:
          'Analyze PE (Portable Executable) headers of Windows EXE/DLL files.',
      category: ToolCategory.fileSecurity,
      icon: Icons.memory,
      tags: ['pe', 'exe', 'windows', 'header', 'malware'],
      isAvailable: false,
    ),
    ToolModel(
      id: 'elf_header_analyzer',
      name: 'ELF Header Analyzer',
      description:
          'Inspect ELF binary headers for Linux executables and shared libraries.',
      category: ToolCategory.fileSecurity,
      icon: Icons.memory,
      tags: ['elf', 'linux', 'binary', 'header'],
      isAvailable: false,
    ),
  ];
}
