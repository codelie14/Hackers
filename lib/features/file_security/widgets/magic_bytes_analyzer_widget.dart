import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class MagicBytesAnalyzerWidget extends ConsumerStatefulWidget {
  const MagicBytesAnalyzerWidget({super.key});

  @override
  ConsumerState<MagicBytesAnalyzerWidget> createState() =>
      _MagicBytesAnalyzerWidgetState();
}

class _MagicBytesAnalyzerWidgetState
    extends ConsumerState<MagicBytesAnalyzerWidget> {
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  String? _fileType;
  String? _mimeType;
  List<int>? _magicBytes;
  bool _isAnalyzing = false;

  // Common magic byte signatures - EXPANDED DATABASE
  static final Map<List<int>, Map<String, String>> _magicSignatures = {
    [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]: {
      'type': 'PNG Image',
      'mime': 'image/png',
    },
    [0xFF, 0xD8, 0xFF]: {
      'type': 'JPEG Image',
      'mime': 'image/jpeg',
    },
    [0x47, 0x49, 0x46, 0x38, 0x39, 0x61]: {
      'type': 'GIF Image',
      'mime': 'image/gif',
    },
    [0x25, 0x50, 0x44, 0x46]: {
      'type': 'PDF Document',
      'mime': 'application/pdf',
    },
    [0x50, 0x4B, 0x03, 0x04]: {
      'type': 'ZIP Archive',
      'mime': 'application/zip',
    },
    [0x50, 0x4B, 0x05, 0x06]: {
      'type': 'ZIP Archive (empty)',
      'mime': 'application/zip',
    },
    [0x50, 0x4B, 0x07, 0x08]: {
      'type': 'ZIP Archive (spanned)',
      'mime': 'application/zip',
    },
    [0x4D, 0x5A]: {
      'type': 'Windows Executable (PE)',
      'mime': 'application/x-msdownload',
    },
    [0x7F, 0x45, 0x4C, 0x46]: {
      'type': 'ELF Executable',
      'mime': 'application/x-executable',
    },
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00]: {
      'type': 'RAR Archive',
      'mime': 'application/vnd.rar',
    },
    [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00]: {
      'type': 'DOCX/XLSX/PPTX',
      'mime': 'application/vnd.openxmlformats-officedocument',
    },
    [0x1F, 0x8B, 0x08]: {
      'type': 'GZIP Compressed',
      'mime': 'application/gzip',
    },
    [0x49, 0x49, 0x2A, 0x00]: {
      'type': 'TIFF Image (Little Endian)',
      'mime': 'image/tiff',
    },
    [0x4D, 0x4D, 0x00, 0x2A]: {
      'type': 'TIFF Image (Big Endian)',
      'mime': 'image/tiff',
    },
    [0x42, 0x4D]: {
      'type': 'BMP Image',
      'mime': 'image/bmp',
    },
    [0x52, 0x49, 0x46, 0x46]: {
      'type': 'RIFF Container (AVI/WebM)',
      'mime': 'video/x-msvideo',
    },
  };

  Future<void> _analyzeRealFile() async {
    setState(() {
      _isAnalyzing = true;
      _fileName = null;
      _fileType = null;
      _mimeType = null;
      _magicBytes = null;
    });

    try {
      // Pick a file using file_picker
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isAnalyzing = false);
        return; // User cancelled
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      final fileName = result.files.single.name;

      // Read first 16 bytes for magic number detection
      final randomAccessFile = await file.open();
      final buffer = Uint8List(16);
      await randomAccessFile.readInto(buffer, 0, 16);
      await randomAccessFile.close();

      final headerBytes = buffer.take(16).toList();

      // Find matching signature
      String? detectedType;
      String? detectedMime;
      List<int>? matchedBytes;

      for (var entry in _magicSignatures.entries) {
        if (_matchesSignature(headerBytes, entry.key)) {
          detectedType = entry.value['type'];
          detectedMime = entry.value['mime'];
          matchedBytes = entry.key;
          break;
        }
      }

      setState(() {
        _fileName = fileName;
        _filePath = result.files.single.path;
        _fileSize = fileSize;
        _magicBytes = matchedBytes ?? headerBytes.take(8).toList();
        _fileType = detectedType ?? 'Unknown File Type';
        _mimeType = detectedMime ?? 'application/octet-stream';
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _matchesSignature(List<int> bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (int i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Magic Bytes Analyzer',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'File Signature Analyzer',
              subtitle: 'Detect file type from magic bytes',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a file to analyze its magic bytes',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Identifies file type by header signature',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isAnalyzing ? 'Analyzing...' : 'Select File',
                      onPressed: _isAnalyzing ? null : _analyzeRealFile,
                      isLoading: _isAnalyzing,
                      icon: Icons.file_upload,
                    ),
                  ],
                ),
              ),
            ),
            if (_magicBytes != null && _fileType != null) ...[
              const SizedBox(height: 24),

              // File Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileName!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Size: ${_formatFileSize(_fileSize!)}',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Detection Result
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.successDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 48, color: AppColors.success),
                    const SizedBox(height: 16),
                    Text(
                      'File Type Detected',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 14,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _fileType!,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _mimeType!,
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

              // Magic Bytes Display
              Text(
                'Magic Bytes (Hex)',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _magicBytes!.asMap().entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.accent),
                            ),
                            child: Text(
                              '0x${entry.value.toRadixString(16).toUpperCase().padLeft(2, '0')}',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'First ${_magicBytes!.length} bytes of file header',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Supported Signatures Reference
              Text(
                'Supported Signatures',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: AppColors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._magicSignatures.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                '${entry.value['type']}: ',
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Flexible(
                                child: Wrap(
                                  spacing: 4,
                                  children: entry.key.map((byte) {
                                    return Text(
                                      '0x${byte.toRadixString(16).toUpperCase().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMono',
                                        fontSize: 10,
                                        color: AppColors.accent,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
