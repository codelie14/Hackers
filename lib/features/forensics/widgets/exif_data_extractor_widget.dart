import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Map<String, String>? _exifData;
  Map<String, double>? _gpsCoordinates;
  bool _isExtracting = false;

  Future<void> _extractExif() async {
    setState(() {
      _isExtracting = true;
      _exifData = null;
      _gpsCoordinates = null;
    });

    // Simulate EXIF extraction (in production, use image package and file_picker)
    await Future.delayed(const Duration(seconds: 2));

    // Simulated EXIF data for demonstration
    setState(() {
      _fileName = 'photo_2024_03_15.jpg';
      _exifData = {
        'Make': 'Canon',
        'Model': 'Canon EOS 5D Mark IV',
        'DateTime': '2024:03:15 14:32:18',
        'Orientation': 'Horizontal (normal)',
        'XResolution': '300',
        'YResolution': '300',
        'Software': 'Adobe Photoshop Lightroom Classic 11.2',
        'ExposureTime': '1/250',
        'FNumber': 'f/5.6',
        'ISO': '400',
        'FocalLength': '85mm',
        'LensModel': 'EF 85mm f/1.8 USM',
        'Flash': 'Flash did not fire',
        'ColorSpace': 'sRGB',
        'PixelXDimension': '6720',
        'PixelYDimension': '4480',
      };
      _gpsCoordinates = {
        'latitude': 48.8566,
        'longitude': 2.3522,
      };
      _isExtracting = false;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
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
                      onPressed: _isExtracting ? null : _extractExif,
                      isLoading: _isExtracting,
                      icon: Icons.image,
                    ),
                  ],
                ),
              ),
            ),
            if (_exifData != null) ...[
              const SizedBox(height: 24),

              // Camera Info Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.catCrypto.withOpacity(0.3),
                      AppColors.bgSurface
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.catCrypto),
                ),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt,
                        size: 40, color: AppColors.catCrypto),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _exifData!['Model']!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.catCrypto,
                            ),
                          ),
                          Text(
                            '${_exifData!['ExposureTime']} • ${_exifData!['FNumber']} • ISO ${_exifData!['ISO']}',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // GPS Location
              if (_gpsCoordinates != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.infoDim,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.info),
                          const SizedBox(width: 8),
                          Text(
                            'GPS Location Detected',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 13,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Latitude: ${_gpsCoordinates!['latitude']}\nLongitude: ${_gpsCoordinates!['longitude']}',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColoredBox(
                            color: AppColors.bgSurface,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map,
                                      size: 40, color: AppColors.info),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Map Preview',
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // All EXIF Data
              Text(
                'Complete Metadata',
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
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _exifData!.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = _exifData!.entries.elementAt(index);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SelectableText(
                                entry.value,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16),
                              onPressed: () => _copyToClipboard(entry.value),
                              tooltip: 'Copy',
                              color: AppColors.accent,
                            ),
                          ],
                        ),
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
}
