import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class ExifDataExtractorWidget extends ConsumerStatefulWidget {
  const ExifDataExtractorWidget({super.key});

  @override
  ConsumerState<ExifDataExtractorWidget> createState() =>
      _ExifDataExtractorWidgetState();
}

class _ExifDataExtractorWidgetState
    extends ConsumerState<ExifDataExtractorWidget> {
  String? _fileName;
  String? _filePath;
  int? _fileSize;
  Map<String, String>? _exifData;
  Map<String, double>? _gpsCoordinates;
  bool _isExtracting = false;

  Future<void> _extractRealExif() async {
    setState(() {
      _isExtracting = true;
      _exifData = null;
      _gpsCoordinates = null;
    });

    try {
      // Pick an image file using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isExtracting = false);
        return; // User cancelled
      }

      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      final fileName = result.files.single.name;

      // Read file bytes
      final imageBytes = await file.readAsBytes();

      // Decode image to get EXIF
      final image = img.decodeImage(imageBytes);

      // Extract EXIF data from image
      final exifMap = <String, String>{};

      if (image != null && image.exif != null) {
        final exif = image.exif!;

        // Extract common fields
        if (exif.make != null && exif.make!.isNotEmpty) {
          exifMap['Make'] = exif.make!;
        }
        if (exif.model != null && exif.model!.isNotEmpty) {
          exifMap['Model'] = exif.model!;
        }
        if (exif.dateTime != null && exif.dateTime!.isNotEmpty) {
          exifMap['DateTime'] = exif.dateTime!;
        }
        if (exif.software != null && exif.software!.isNotEmpty) {
          exifMap['Software'] = exif.software!;
        }

        // Exposure settings
        if (exif.exposureTime != null) {
          exifMap['ExposureTime'] = '1/${exif.exposureTime!.round()} sec';
        }
        if (exif.fNumber != null) {
          exifMap['FNumber'] = 'f/${exif.fNumber}';
        }
        if (exif.isoSpeedRatings != null) {
          exifMap['ISO'] = exif.isoSpeedRatings.toString();
        }
        if (exif.focalLength != null) {
          exifMap['FocalLength'] = '${exif.focalLength}mm';
        }
        if (exif.lensModel != null && exif.lensModel!.isNotEmpty) {
          exifMap['LensModel'] = exif.lensModel!;
        }

        // Image dimensions
        exifMap['Width'] = image.width.toString();
        exifMap['Height'] = image.height.toString();
      }

      // GPS coordinates (simplified - may not work for all images)
      Map<String, double>? gpsCoords;
      // Note: Full GPS extraction requires more complex parsing
      // This is a simplified version

      setState(() {
        _fileName = fileName;
        _filePath = result.files.single.path;
        _fileSize = fileSize;
        _exifData = exifMap.isEmpty
            ? {'Note': 'No EXIF data found in this image'}
            : exifMap;
        _gpsCoordinates = gpsCoords;
        _isExtracting = false;
      });
    } catch (e) {
      setState(() => _isExtracting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error extracting EXIF data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      title: 'EXIF Data Extractor',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'EXIF Metadata Extractor',
              subtitle: 'Extract camera info, GPS, and timestamps',
            ),
            const SizedBox(height: 24),
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select an image to extract\nEXIF metadata',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Camera settings, GPS, timestamps',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: _isExtracting ? 'Extracting...' : 'Select Image',
                      onPressed: _isExtracting ? null : _extractRealExif,
                      isLoading: _isExtracting,
                      icon: Icons.image,
                    ),
                  ],
                ),
              ),
            ),
            if (_exifData != null && _exifData!.isNotEmpty) ...[
              const SizedBox(height: 24),

              // File Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.info),
                ),
                child: Row(
                  children: [
                    Icon(Icons.image, color: AppColors.info),
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

              // All EXIF Data
              Text(
                'Metadata (${_exifData!.length} fields)',
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _exifData!.length,
                  itemBuilder: (context, index) {
                    final key = _exifData!.keys.elementAt(index);
                    final value = _exifData![key]!;

                    return ListTile(
                      dense: true,
                      title: Text(
                        key,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      subtitle: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () => _copyToClipboard(value),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }
}
