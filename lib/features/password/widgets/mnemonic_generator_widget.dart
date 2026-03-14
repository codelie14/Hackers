import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class MnemonicGeneratorWidget extends ConsumerStatefulWidget {
  const MnemonicGeneratorWidget({super.key});

  @override
  ConsumerState<MnemonicGeneratorWidget> createState() =>
      _MnemonicGeneratorWidgetState();
}

class _MnemonicGeneratorWidgetState
    extends ConsumerState<MnemonicGeneratorWidget> {
  final _textController = TextEditingController();
  String _result = '';
  String _error = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _generateMnemonic(String text) {
    if (text.isEmpty) return '';

    final words =
        text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';

    // Generate acronym from first letters
    final acronym = words.map((w) => w[0].toUpperCase()).join('');

    // Create memorable sentence
    final buffer = StringBuffer();
    buffer.writeln('📝 ACRONYM: $acronym\n');
    buffer.writeln();

    for (final word in words) {
      if (word.length > 2) {
        buffer.writeln('• ${word[0].toUpperCase()} → ${_findSimilar(word)}');
      }
    }

    buffer.writeln();
    buffer.writeln(
        '💡 Tip: Remember "$acronym" and associate each letter with the words above.');

    return buffer.toString();
  }

  String _findSimilar(String word) {
    // Simple mnemonic technique: find words starting with same letter
    final starters = {
      'a': ['Apple', 'Arrow', 'Anchor', 'Atlas'],
      'b': ['Ball', 'Bridge', 'Blade', 'Beacon'],
      'c': ['Castle', 'Cloud', 'Crown', 'Compass'],
      'd': ['Dragon', 'Diamond', 'Dagger', 'Dome'],
      'e': ['Eagle', 'Echo', 'Ember', 'Edge'],
      'f': ['Flame', 'Forest', 'Falcon', 'Forge'],
      'g': ['Ghost', 'Glacier', 'Garden', 'Gate'],
      'h': ['Hammer', 'Horizon', 'Harbor', 'Helm'],
      'i': ['Island', 'Iron', 'Ivy', 'Ice'],
      'j': ['Jewel', 'Jungle', 'Javelin', 'Jade'],
      'k': ['Knight', 'Kingdom', 'Key', 'Kite'],
      'l': ['Lion', 'Lance', 'Leaf', 'Lunar'],
      'm': ['Mountain', 'Moon', 'Mystic', 'Maple'],
      'n': ['Nebula', 'Night', 'Noble', 'North'],
      'o': ['Ocean', 'Orbit', 'Onyx', 'Olive'],
      'p': ['Phoenix', 'Pearl', 'Pyramid', 'Plasma'],
      'q': ['Quantum', 'Quartz', 'Quest', 'Quill'],
      'r': ['River', 'Ruby', 'Rune', 'Rose'],
      's': ['Star', 'Storm', 'Shield', 'Sage'],
      't': ['Tower', 'Thunder', 'Tide', 'Trail'],
      'u': ['Universe', 'Umbra', 'Uranium', 'Unity'],
      'v': ['Volcano', 'Velvet', 'Vortex', 'Vista'],
      'w': ['Wolf', 'Wave', 'Willow', 'Wisp'],
      'x': ['Xenon', 'Xerus', 'Xanth', 'Xebec'],
      'y': ['Yacht', 'Yew', 'Yucca', 'Yonder'],
      'z': ['Zephyr', 'Zenith', 'Zinc', 'Zebra'],
    };

    final letter = word[0].toLowerCase();
    final options = starters[letter] ?? ['Word'];
    return options[Random().nextInt(options.length)];
  }

  void _generate() {
    setState(() {
      _error = '';
      _result = '';
    });

    try {
      final text = _textController.text.trim();
      if (text.isEmpty) {
        setState(() => _error = 'Please enter some text');
        return;
      }

      setState(() => _result = _generateMnemonic(text));
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'MNEMONIC GENERATOR',
      activeCategory: ToolCategory.password,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'TEXT TO MEMORIZE'),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _textController,
              hintText:
                  'Enter a list of words, concepts, or items you want to remember...',
              minLines: 3,
              maxLines: 6,
              onChanged: (_) => setState(() {
                _result = '';
                _error = '';
              }),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'GENERATE MNEMONIC',
              icon: Icons.memory_outlined,
              onPressed: _generate,
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(content: _error, isError: true),
            ],
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'MNEMONIC',
                monospace: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
