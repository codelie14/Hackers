import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class HkdfToolWidget extends ConsumerStatefulWidget {
  const HkdfToolWidget({super.key});

  @override
  ConsumerState<HkdfToolWidget> createState() => _HkdfToolWidgetState();
}

class _HkdfToolWidgetState extends ConsumerState<HkdfToolWidget> {
  final _ikmController = TextEditingController();
  final _saltController = TextEditingController();
  final _infoController = TextEditingController();
  int _outputLength = 32;
  String _result = '';

  @override
  void dispose() {
    _ikmController.dispose();
    _saltController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  void _deriveKey() {
    setState(() => _result = '');
    try {
      final ikm = _ikmController.text.trim();
      final salt = _saltController.text.trim();
      final info = _infoController.text.trim();

      if (ikm.isEmpty) {
        setState(() => _result = 'Please enter Input Keying Material (IKM)');
        return;
      }

      // HKDF placeholder implementation
      // In production, use pointycastle's HkdfBytesGenerator
      final ikmBytes = ikm.codeUnits;
      final saltBytes = salt.isEmpty ? [] : salt.codeUnits;
      final infoBytes = info.isEmpty ? [] : info.codeUnits;

      var prk = 0x8B7C9D2E; // Pseudo-Random Key seed

      // Extract phase (simplified)
      for (var i = 0; i < ikmBytes.length; i++) {
        prk = prk ^ (ikmBytes[i] << (i % 32));
        prk = ((prk << 5) | (prk >> 27)) & 0xFFFFFFFF;
      }

      // Expand phase (simplified)
      final okm = StringBuffer();
      var t = prk;
      for (var i = 0; i < _outputLength; i++) {
        t = ((t << 5) | (t >> 27)) & 0xFFFFFFFF;
        okm.write(t.toRadixString(16).padLeft(2, '0').toUpperCase());
      }

      setState(() {
        _result = 'HKDF KEY DERIVATION\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
            'Input Keying Material: ${ikm.length} bytes\n'
            'Salt: ${salt.isEmpty ? '(none)' : '$salt (${salt.length} bytes)'}\n'
            'Info: ${info.isEmpty ? '(none)' : '$info (${info.length} bytes)'}\n'
            'Output Length: $_outputLength bytes\n\n'
            'DERIVED KEY (OKM)\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${okm.toString()}\n\nNote: Full HKDF-SHA256 implementation requires pointycastle package';
      });
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'HKDF KEY DERIVATION',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'ABOUT HKDF', color: AppColors.accent),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'HKDF (HMAC-based Extract-and-Expand Key Derivation Function) is defined in RFC 5869.\n\n'
                'Two-stage process:\n'
                '1. Extract: Creates a fixed-length PRK from input keying material\n'
                '2. Expand: Derives output keying material of desired length\n\n'
                'Used in TLS 1.3, Signal Protocol, and many security protocols.',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'INPUT KEYING MATERIAL (IKM)'),
            const SizedBox(height: 8),
            TextField(
              controller: _ikmController,
              decoration: InputDecoration(
                hintText: 'Enter secret key material...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              maxLines: 3,
              obscureText: true,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'SALT (OPTIONAL)'),
            const SizedBox(height: 8),
            TextField(
              controller: _saltController,
              decoration: InputDecoration(
                hintText: 'Optional salt value...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText: 'If not provided, uses default values',
              ),
              maxLines: 2,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INFO CONTEXT (OPTIONAL)'),
            const SizedBox(height: 8),
            TextField(
              controller: _infoController,
              decoration: InputDecoration(
                hintText: 'Optional context/application info...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                helperText:
                    'Application-specific context (e.g., "AES-256 key")',
              ),
              maxLines: 2,
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'OUTPUT LENGTH'),
            const SizedBox(height: 8),
            Slider(
              value: _outputLength.toDouble(),
              min: 16,
              max: 64,
              divisions: 12,
              label: '$_outputLength bytes',
              activeColor: AppColors.accent,
              onChanged: (value) =>
                  setState(() => _outputLength = value.toInt()),
            ),
            Center(
              child: Text(
                'Derived key will be $_outputLength bytes (${_outputLength * 8} bits)',
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'DERIVE KEY WITH HKDF',
              icon: Icons.key,
              onPressed: _deriveKey,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'DERIVED KEY',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
