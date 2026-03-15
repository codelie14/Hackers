import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../data/models/tool_model.dart';

class LSBEncoderWidget extends ConsumerStatefulWidget {
  const LSBEncoderWidget({super.key});

  @override
  ConsumerState<LSBEncoderWidget> createState() => _LSBEncoderWidgetState();
}

class _LSBEncoderWidgetState extends ConsumerState<LSBEncoderWidget> {
  final _messageController = TextEditingController();
  String? _imageName;
  Uint8List? _imageBytes;
  Uint8List? _encodedImageBytes;
  bool _isEncoding = false;
  bool _isComplete = false;

  // Simulated image data (in production, use image package and file_picker)
  void _encodeMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message to hide')),
      );
      return;
    }

    setState(() {
      _isEncoding = true;
      _isComplete = false;
    });

    // Simulate encoding process
    await Future.delayed(const Duration(seconds: 2));

    // In production, this would actually encode into image pixels
    // For now, simulate success
    setState(() {
      _imageName = 'secret_image.png';
      _encodedImageBytes = Uint8List.fromList(List.generate(1024, (_) => 0));
      _isEncoding = false;
      _isComplete = true;
    });
  }

  void _downloadImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved to gallery')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'LSB Encoder',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'LSB Text Encoder',
              subtitle: 'Hide secret text inside images',
            ),
            const SizedBox(height: 24),

            // Image Selection
            Card(
              color: AppColors.bgSurface,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _imageName ?? 'Select an image to hide text in',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        color: _imageName != null
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Select Image',
                      onPressed: () {
                        setState(() {
                          _imageName = 'selected_image.png';
                        });
                      },
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Message Input
            AppInput(
              controller: _messageController,
              labelText: 'Secret Message',
              hintText: 'Enter the text you want to hide...',
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoDim,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How LSB Works',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 13,
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Least Significant Bit steganography replaces\nthe last bit of pixel values with your data.',
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

            AppButton(
              label: _isEncoding ? 'Encoding...' : 'Encode Message',
              onPressed:
                  _isEncoding || _imageName == null ? null : _encodeMessage,
              isLoading: _isEncoding,
              icon: Icons.hide_image,
            ),

            if (_isComplete) ...[
              const SizedBox(height: 24),

              // Success Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.successDim, AppColors.bgSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 48, color: AppColors.success),
                    const SizedBox(height: 16),
                    Text(
                      'Message Successfully Hidden!',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your secret message is now invisible\nembedded in the image pixels.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        'Original Size', '2.4 MB', AppColors.catPassword),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                        'Encoded Size', '2.4 MB', AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                        'Message Length',
                        '${_messageController.text.length} chars',
                        AppColors.accent),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Download Image',
                      onPressed: _downloadImage,
                      icon: Icons.download,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share dialog opened')),
                      );
                    },
                    color: AppColors.accent,
                    tooltip: 'Share',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
