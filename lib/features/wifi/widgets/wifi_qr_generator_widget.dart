import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../data/models/tool_model.dart';

class WiFiQRGeneratorWidget extends ConsumerStatefulWidget {
  const WiFiQRGeneratorWidget({super.key});

  @override
  ConsumerState<WiFiQRGeneratorWidget> createState() =>
      _WiFiQRGeneratorWidgetState();
}

class _WiFiQRGeneratorWidgetState extends ConsumerState<WiFiQRGeneratorWidget> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  String _securityType = 'WPA';
  bool _isHidden = false;
  bool _showQR = false;

  String get _wifiString {
    final security = _securityType == 'None' ? 'nopass' : _securityType;
    return 'WIFI:T:$security;S:${_ssidController.text.trim()};P:${_passwordController.text.trim()};H:$_isHidden;;';
  }

  void _generateQR() {
    if (_ssidController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter SSID')),
      );
      return;
    }

    setState(() => _showQR = true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'WiFi QR Generator',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: 'WiFi QR Code Generator',
              subtitle: 'Generate QR codes for easy WiFi sharing',
            ),
            const SizedBox(height: 24),
            AppInput(
              controller: _ssidController,
              labelText: 'Network Name (SSID)',
              hintText: 'Enter WiFi network name',
            ),
            const SizedBox(height: 16),
            AppInput(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter WiFi password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _securityType,
              decoration: InputDecoration(
                labelText: 'Security Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.bgSurface,
              ),
              items: ['WPA', 'WEP', 'None'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _securityType = value!),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Hidden Network'),
              value: _isHidden,
              onChanged: (value) => setState(() => _isHidden = value ?? false),
              activeColor: AppColors.accent,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Generate QR Code',
              onPressed: _generateQR,
            ),
            if (_showQR) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: _wifiString,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Share / Print',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Screenshot to save or share'),
                    ),
                  );
                },
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
