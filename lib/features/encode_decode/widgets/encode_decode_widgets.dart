import 'dart:convert';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../services/encode_decode_service.dart';

// Unused abstract class removed

// ── Hex ─────────────────────────────────────────────────────────────────────

class HexWidget extends ConsumerStatefulWidget {
  const HexWidget({super.key});
  @override
  ConsumerState<HexWidget> createState() => _HexWidgetState();
}

class _HexWidgetState extends ConsumerState<HexWidget> {
  final _ctrl = TextEditingController();
  String _encoded = '', _decoded = '', _error = '';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _encode() { try { setState(() { _decoded = ''; _error = ''; _encoded = EncodeDecodeService.encodeHex(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }
  void _decode() { try { setState(() { _encoded = ''; _error = ''; _decoded = EncodeDecodeService.decodeHex(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }

  @override
  Widget build(BuildContext c) => AppScaffold(
    title: 'HEX ENCODE / DECODE', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
    body: _BiDirBody(ctrl: _ctrl, encoded: _encoded, decoded: _decoded, error: _error, encLabel: 'HEX', decLabel: 'TEXT',
      onEncode: _encode, onDecode: _decode, inputHint: 'Enter text or hex string...',
      onChanged: () => setState(() { _encoded = ''; _decoded = ''; _error = ''; })));
}

// ── URL Encode ───────────────────────────────────────────────────────────────

class UrlEncodeWidget extends ConsumerStatefulWidget {
  const UrlEncodeWidget({super.key});
  @override
  ConsumerState<UrlEncodeWidget> createState() => _UrlEncodeWidgetState();
}

class _UrlEncodeWidgetState extends ConsumerState<UrlEncodeWidget> {
  final _ctrl = TextEditingController();
  String _encoded = '', _decoded = '', _error = '';
  bool _component = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _encode() { try { setState(() { _decoded = ''; _error = ''; _encoded = _component ? EncodeDecodeService.encodeUrlComponent(_ctrl.text) : EncodeDecodeService.encodeUrl(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }
  void _decode() { try { setState(() { _encoded = ''; _error = ''; _decoded = _component ? EncodeDecodeService.decodeUrlComponent(_ctrl.text) : EncodeDecodeService.decodeUrl(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'URL ENCODE / DECODE', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Component encode', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: AppColors.textSecondary)),
            const Spacer(),
            Switch(value: _component, onChanged: (v) => setState(() => _component = v)),
          ]),
          const SizedBox(height: 8),
          _BiDirBody(ctrl: _ctrl, encoded: _encoded, decoded: _decoded, error: _error, encLabel: 'ENCODED URL', decLabel: 'DECODED URL',
            onEncode: _encode, onDecode: _decode, inputHint: 'Enter URL or encoded string...',
            onChanged: () => setState(() { _encoded = ''; _decoded = ''; _error = ''; })),
        ]),
      ),
    );
  }
}

// ── ROT13/47 ─────────────────────────────────────────────────────────────────

class RotWidget extends ConsumerStatefulWidget {
  const RotWidget({super.key});
  @override
  ConsumerState<RotWidget> createState() => _RotWidgetState();
}

class _RotWidgetState extends ConsumerState<RotWidget> {
  final _ctrl = TextEditingController();
  String _rot13 = '', _rot47 = '';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _apply(String input) {
    setState(() {
      _rot13 = EncodeDecodeService.rot13(input);
      _rot47 = EncodeDecodeService.rot47(input);
    });
  }

  @override
  Widget build(BuildContext c) => AppScaffold(
    title: 'ROT13 / ROT47', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Input'),
      const SizedBox(height: 8),
      AppTextArea(controller: _ctrl, hintText: 'Enter text to apply ROT cipher...', minLines: 3, maxLines: 6,
          onChanged: _apply),
      if (_rot13.isNotEmpty) ...[
        const SizedBox(height: 16),
        ResultBox(content: _rot13, label: 'ROT13'),
        const SizedBox(height: 12),
        ResultBox(content: _rot47, label: 'ROT47'),
      ],
    ])));
}

// ── Morse ─────────────────────────────────────────────────────────────────────

class MorseWidget extends ConsumerStatefulWidget {
  const MorseWidget({super.key});
  @override
  ConsumerState<MorseWidget> createState() => _MorseWidgetState();
}

class _MorseWidgetState extends ConsumerState<MorseWidget> {
  final _ctrl = TextEditingController();
  String _encoded = '', _decoded = '', _error = '';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _encode() { try { setState(() { _decoded = ''; _error = ''; _encoded = EncodeDecodeService.encodeToMorse(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }
  void _decode() { try { setState(() { _encoded = ''; _error = ''; _decoded = EncodeDecodeService.decodeFromMorse(_ctrl.text); }); } catch (e) { setState(() => _error = e.toString()); } }

  @override
  Widget build(BuildContext c) => AppScaffold(
    title: 'MORSE CODE', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
    body: _BiDirBody(ctrl: _ctrl, encoded: _encoded, decoded: _decoded, error: _error, encLabel: 'MORSE', decLabel: 'TEXT',
      onEncode: _encode, onDecode: _decode, inputHint: 'Enter text or Morse code (dots and dashes)...',
      onChanged: () => setState(() { _encoded = ''; _decoded = ''; _error = ''; })));
}

// ── Binary / Octal / ASCII ───────────────────────────────────────────────────

class BinaryOctalAsciiWidget extends ConsumerStatefulWidget {
  const BinaryOctalAsciiWidget({super.key});
  @override
  ConsumerState<BinaryOctalAsciiWidget> createState() => _BinaryOctalAsciiWidgetState();
}

class _BinaryOctalAsciiWidgetState extends ConsumerState<BinaryOctalAsciiWidget> {
  final _ctrl = TextEditingController();
  String _format = 'Binary';
  String _encoded = '', _decoded = '', _error = '';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _encode() {
    try {
      String r;
      switch (_format) {
        case 'Binary': r = EncodeDecodeService.textToBinary(_ctrl.text); break;
        case 'Octal': r = EncodeDecodeService.textToOctal(_ctrl.text); break;
        default: r = EncodeDecodeService.textToAscii(_ctrl.text);
      }
      setState(() { _decoded = ''; _error = ''; _encoded = r; });
    } catch (e) { setState(() => _error = e.toString()); }
  }

  void _decode() {
    try {
      String r;
      switch (_format) {
        case 'Binary': r = EncodeDecodeService.binaryToText(_ctrl.text); break;
        case 'Octal': r = EncodeDecodeService.octalToText(_ctrl.text); break;
        default: r = EncodeDecodeService.asciiToText(_ctrl.text);
      }
      setState(() { _encoded = ''; _error = ''; _decoded = r; });
    } catch (e) { setState(() => _error = e.toString()); }
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'BINARY / OCTAL / ASCII', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Format'),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: ['Binary', 'Octal', 'ASCII'].map((f) => InkWell(
        onTap: () => setState(() { _format = f; _encoded = ''; _decoded = ''; _error = ''; }),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _format == f ? AppColors.accentGhost : AppColors.bgElevated,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _format == f ? AppColors.accent : AppColors.border),
          ),
          child: Text(f, style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: _format == f ? AppColors.accent : AppColors.textSecondary, fontWeight: _format == f ? FontWeight.w700 : FontWeight.w400)),
        ),
      )).toList()),
      const SizedBox(height: 16),
      _BiDirBody(ctrl: _ctrl, encoded: _encoded, decoded: _decoded, error: _error,
        encLabel: '$_format ENCODED', decLabel: 'DECODED TEXT',
        onEncode: _encode, onDecode: _decode, inputHint: 'Enter text or $_format data...',
        onChanged: () => setState(() { _encoded = ''; _decoded = ''; _error = ''; })),
    ])));
}

// ── Shared bi-directional body ───────────────────────────────────────────────

class _BiDirBody extends StatelessWidget {
  final TextEditingController ctrl;
  final String encoded, decoded, error, encLabel, decLabel, inputHint;
  final VoidCallback onEncode, onDecode, onChanged;

  const _BiDirBody({
    required this.ctrl, required this.encoded, required this.decoded,
    required this.error, required this.encLabel, required this.decLabel,
    required this.onEncode, required this.onDecode,
    required this.inputHint, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SectionHeader(title: 'Input'),
    const SizedBox(height: 8),
    AppTextArea(controller: ctrl, hintText: inputHint, minLines: 3, maxLines: 8, onChanged: (_) => onChanged()),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: AppButton(label: 'ENCODE', icon: Icons.arrow_downward, onPressed: onEncode)),
      const SizedBox(width: 10),
      Expanded(child: AppButton(label: 'DECODE', icon: Icons.arrow_upward, onPressed: onDecode, variant: AppButtonVariant.secondary)),
    ]),
    if (error.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: error, isError: true)],
    if (encoded.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: encoded, label: encLabel)],
    if (decoded.isNotEmpty) ...[const SizedBox(height: 16), ResultBox(content: decoded, label: decLabel)],
  ]);
}

// ── Base32 ───────────────────────────────────────────────────────────────────

class Base32Widget extends ConsumerStatefulWidget {
  const Base32Widget({super.key});
  @override
  ConsumerState<Base32Widget> createState() => _Base32WidgetState();
}

class _Base32WidgetState extends ConsumerState<Base32Widget> {
  final _ctrl = TextEditingController();
  String _encoded = '', _decoded = '', _error = '';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _encode() {
    try {
      final bytes = utf8.encode(_ctrl.text);
      setState(() { _decoded = ''; _error = ''; _encoded = base32.encode(Uint8List.fromList(bytes)); });
    } catch (e) { setState(() => _error = e.toString()); }
  }

  void _decode() {
    try {
      final bytes = base32.decode(_ctrl.text.trim().toUpperCase());
      setState(() { _encoded = ''; _error = ''; _decoded = utf8.decode(bytes); });
    } catch (e) { setState(() => _error = e.toString()); }
  }

  @override
  Widget build(BuildContext c) => AppScaffold(
    title: 'BASE32', activeCategory: ToolCategory.encodeDecode, showBackButton: true,
    body: _BiDirBody(ctrl: _ctrl, encoded: _encoded, decoded: _decoded, error: _error,
      encLabel: 'BASE32 ENCODED', decLabel: 'DECODED TEXT',
      onEncode: _encode, onDecode: _decode, inputHint: 'Enter text or Base32...',
      onChanged: () => setState(() { _encoded = ''; _decoded = ''; _error = ''; })));
}
