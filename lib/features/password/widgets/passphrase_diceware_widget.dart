import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';

class PassphraseDicewareWidget extends ConsumerStatefulWidget {
  const PassphraseDicewareWidget({super.key});

  @override
  ConsumerState<PassphraseDicewareWidget> createState() => _PassphraseDicewareWidgetState();
}

class _PassphraseDicewareWidgetState extends ConsumerState<PassphraseDicewareWidget> {
  List<String> _words = [];
  String _passphrase = '';
  int _wordCount = 6;
  String _separator = ' ';
  bool _loading = false;
  List<String>? _wordlist;

  @override
  void initState() {
    super.initState();
    _loadWordlist();
  }

  Future<void> _loadWordlist() async {
    try {
      final data = await rootBundle.loadString('assets/data/wordlist_diceware.txt');
      _wordlist = data.split('\n').where((line) => line.trim().isNotEmpty).toList();
    } catch (_) {
      // Fallback embedded wordlist
      _wordlist = _fallbackWordlist;
    }
  }

  void _generate() async {
    if (_wordlist == null) await _loadWordlist();
    final wordlist = _wordlist!;
    if (wordlist.isEmpty) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 50));

    final rng = Random.secure();
    final words = List.generate(
      _wordCount,
      (_) {
        final line = wordlist[rng.nextInt(wordlist.length)];
        // Most diceware files have "12345\tword" format or just "word"
        final parts = line.split(RegExp(r'\s+'));
        return parts.length > 1 ? parts.last : parts.first;
      },
    );

    setState(() {
      _words = words;
      _passphrase = words.join(_separator);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DICEWARE PASSPHRASE',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'Word Count: $_wordCount'),
            Slider(
              value: _wordCount.toDouble(),
              min: 3,
              max: 12,
              divisions: 9,
              label: '$_wordCount',
              onChanged: (v) => setState(() { _wordCount = v.round(); _words = []; _passphrase = ''; }),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Separator'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _SepChip(label: 'Space', value: ' ', selected: _separator == ' ', onTap: () => setState(() => _separator = ' ')),
                _SepChip(label: 'Dash (-)', value: '-', selected: _separator == '-', onTap: () => setState(() => _separator = '-')),
                _SepChip(label: 'Dot (.)', value: '.', selected: _separator == '.', onTap: () => setState(() => _separator = '.')),
                _SepChip(label: 'None', value: '', selected: _separator == '', onTap: () => setState(() => _separator = '')),
                _SepChip(label: 'Undersc.', value: '_', selected: _separator == '_', onTap: () => setState(() => _separator = '_')),
              ],
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE PASSPHRASE',
              icon: Icons.casino_outlined,
              isLoading: _loading,
              fullWidth: true,
              onPressed: _generate,
            ),
            if (_passphrase.isNotEmpty) ...[
              const SizedBox(height: 24),
              const SectionHeader(title: 'Generated Passphrase'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accentDim.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _passphrase,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          '${_wordCount} words · ${_passphrase.length} chars',
                          style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: AppColors.textMuted),
                        ),
                        const Spacer(),
                        CopyButton(text: _passphrase),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 16, color: AppColors.textSecondary),
                          onPressed: _generate,
                          tooltip: 'Regenerate',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Word breakdown
              const SectionHeader(title: 'Word Breakdown'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _words.asMap().entries.map((e) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${e.key + 1}',
                          style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 9, color: AppColors.accent, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e.value,
                          style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Minimal fallback wordlist (100 common EFF words)
  static const _fallbackWordlist = [
    'abacus', 'abbey', 'ability', 'absence', 'accent', 'access', 'account', 'achieve',
    'adrift', 'against', 'basket', 'battle', 'beacon', 'bicycle', 'blanket', 'bridge',
    'canyon', 'castle', 'chain', 'chant', 'charge', 'chrome', 'circle', 'citrus',
    'dollar', 'domain', 'donkey', 'double', 'dragon', 'drawer', 'driver', 'drone',
    'eagle', 'earth', 'eight', 'ember', 'empire', 'engine', 'entry', 'equal',
    'factor', 'falcon', 'ferry', 'fever', 'field', 'figure', 'filter', 'finger',
    'galaxy', 'garden', 'garlic', 'gentle', 'ghost', 'giant', 'glider', 'golden',
    'harbor', 'hammer', 'handle', 'harvest', 'helmet', 'hollow', 'honor', 'hunter',
    'ice', 'image', 'impact', 'input', 'install', 'island', 'ivory', 'jacket',
    'jungle', 'junior', 'kernel', 'kettle', 'kitten', 'knight', 'ladder', 'lagoon',
    'mango', 'marble', 'master', 'mirror', 'module', 'monkey', 'mountain', 'muscle',
    'native', 'nature', 'nectar', 'nerve', 'network', 'nomad', 'north', 'nothing',
    'obtain', 'ocean', 'offset', 'origin', 'output', 'oyster', 'packet', 'palace',
    'pilot', 'planet', 'plasma', 'portal', 'probe', 'python', 'quartz', 'quest',
    'rabbit', 'radar', 'radius', 'ranger', 'rapid', 'raven', 'record', 'reflex',
    'safari', 'salute', 'sample', 'server', 'shield', 'signal', 'silver', 'socket',
    'tablet', 'target', 'temple', 'tensor', 'thunder', 'timber', 'token', 'tunnel',
    'ubuntu', 'ultra', 'upload', 'user', 'value', 'vapor', 'vector', 'velvet',
    'whale', 'winter', 'wisdom', 'wizard', 'worker', 'yellow', 'zebra', 'zephyr',
  ];
}

class _SepChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _SepChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGhost : AppColors.bgElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: selected ? AppColors.accent : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
