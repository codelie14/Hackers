import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class HexDumpViewerWidget extends ConsumerStatefulWidget {
  const HexDumpViewerWidget({super.key});

  @override
  ConsumerState<HexDumpViewerWidget> createState() =>
      _HexDumpViewerWidgetState();
}

class _HexDumpViewerWidgetState extends ConsumerState<HexDumpViewerWidget> {
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  List<int>? _fileBytes;
  bool _isLoading = false;
  int _bytesPerRow = 16;

  Future<void> _loadRealFile() async {
    setState(() {
      _isLoading = true;
      _fileName = null;
      _fileBytes = null;
    });

    try {
      // Pick a file using file_picker
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      final fileName = result.files.single.name;

      // Read file bytes (limit to first 10KB for performance)
      final bytes = await file.readAsBytes();
      final limitedBytes =
          bytes.length > 10240 ? bytes.take(10240).toList() : bytes.toList();

      setState(() {
        _fileName = fileName;
        _filePath = result.files.single.path;
        _fileSize = fileSize;
        _fileBytes = limitedBytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _byteToHex(int byte) {
    return byte.toRadixString(16).toUpperCase().padLeft(2, '0');
  }

  String _byteToAscii(int byte) {
    if (byte >= 32 && byte <= 126) {
      return String.fromCharCode(byte);
    }
    return '.';
  }

  void _copyHex() {
    if (_fileBytes != null) {
      final hexString = _fileBytes!.map((b) => _byteToHex(b)).join(' ');
      Clipboard.setData(ClipboardData(text: hexString));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hex dump copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hex Dump Viewer',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeader(
                  title: 'Hex Dump Viewer',
                  subtitle: 'View binary file content with ASCII sidebar',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: _isLoading ? 'Loading...' : 'Load File',
                        onPressed: _isLoading ? null : _loadRealFile,
                        isLoading: _isLoading,
                        icon: Icons.folder_open,
                      ),
                    ),
                    if (_fileBytes != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: _copyHex,
                        color: AppColors.accent,
                        tooltip: 'Copy hex',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_fileBytes == null)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.memory_outlined,
                        size: 64, color: AppColors.textMuted),
                    SizedBox(height: 16),
                    Text(
                      'Load a file to view\nhexadecimal dump',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                color: AppColors.bgSurface,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.infoDim,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.info),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 18, color: AppColors.info),
                              const SizedBox(width: 8),
                              Text(
                                '${_fileName!} • ${_fileBytes!.length} bytes',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                  color: AppColors.info,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Header row
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                'Offset',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                List.generate(_bytesPerRow,
                                    (i) => _byteToHex(i).padLeft(2)).join(' '),
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: (_bytesPerRow * 1.5).toDouble(),
                              child: Text(
                                'ASCII',
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // Hex rows
                        ...List.generate(
                            (_fileBytes!.length / _bytesPerRow).ceil(),
                            (rowIndex) {
                          final startOffset = rowIndex * _bytesPerRow;
                          final rowData = _fileBytes!
                              .skip(startOffset)
                              .take(_bytesPerRow)
                              .toList();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                // Offset
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    startOffset
                                        .toRadixString(16)
                                        .toUpperCase()
                                        .padLeft(8, '0'),
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Hex bytes
                                Expanded(
                                  child: Row(
                                    children:
                                        rowData.asMap().entries.map((entry) {
                                      final colIndex = entry.key;
                                      final byte = entry.value;

                                      return Expanded(
                                        child: Text(
                                          _byteToHex(byte),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'JetBrainsMono',
                                            fontSize: 10,
                                            color: byte >= 32 && byte <= 126
                                                ? AppColors.success
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // ASCII representation
                                SizedBox(
                                  width: (_bytesPerRow * 1.5).toDouble(),
                                  child: Text(
                                    rowData
                                        .map((b) => _byteToAscii(b))
                                        .join(''),
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      fontSize: 10,
                                      color: AppColors.catCrypto,
                                    ),
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
              ),
            ),
        ],
      ),
    );
  }
}
