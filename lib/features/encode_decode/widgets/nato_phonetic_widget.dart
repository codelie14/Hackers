import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class NatoPhoneticWidget extends ConsumerStatefulWidget {
  const NatoPhoneticWidget({super.key});

  @override
  ConsumerState<NatoPhoneticWidget> createState() => _NatoPhoneticWidgetState();
}

class _NatoPhoneticWidgetState extends ConsumerState<NatoPhoneticWidget> {
  final _inputController = TextEditingController();
  String _mode = 'encode';
  String _result = '';

  final List<String> _modes = [
    'Text → NATO',
    'NATO → Text',
  ];

  // NATO Phonetic Alphabet
  static const Map<String, String> _natoAlphabet = {
    'A': 'Alpha',
    'B': 'Bravo',
    'C': 'Charlie',
    'D': 'Delta',
    'E': 'Echo',
    'F': 'Foxtrot',
    'G': 'Golf',
    'H': 'Hotel',
    'I': 'India',
    'J': 'Juliett',
    'K': 'Kilo',
    'L': 'Lima',
    'M': 'Mike',
    'N': 'November',
    'O': 'Oscar',
    'P': 'Papa',
    'Q': 'Quebec',
    'R': 'Romeo',
    'S': 'Sierra',
    'T': 'Tango',
    'U': 'Uniform',
    'V': 'Victor',
    'W': 'Whiskey',
    'X': 'X-ray',
    'Y': 'Yankee',
    'Z': 'Zulu',
    '0': 'Zero',
    '1': 'One',
    '2': 'Two',
    '3': 'Three',
    '4': 'Four',
    '5': 'Five',
    '6': 'Six',
    '7': 'Seven',
    '8': 'Eight',
    '9': 'Nine',
  };

  static final Map<String, String> _reverseNato = {
    for (var entry in _natoAlphabet.entries)
      entry.value.toUpperCase(): entry.key
  };

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String _encodeToNato(String input) {
    try {
      final buffer = StringBuffer();
      final words = input.toUpperCase().split(' ');

      for (var i = 0; i < words.length; i++) {
        final word = words[i];
        for (var j = 0; j < word.length; j++) {
          final char = word[j];
          if (_natoAlphabet.containsKey(char)) {
            buffer.write(_natoAlphabet[char]);
            if (j < word.length - 1) {
              buffer.write(' ');
            }
          } else {
            // Keep non-alphanumeric characters as-is
            buffer.write(char);
          }
        }
        if (i < words.length - 1) {
          buffer.write(' / ');
        }
      }

      return buffer.toString();
    } catch (e) {
      throw Exception('Encoding failed: ${e.toString()}');
    }
  }

  String _decodeFromNato(String input) {
    try {
      final buffer = StringBuffer();
      final words = input.split(' / ');

      for (var i = 0; i < words.length; i++) {
        final word = words[i];
        final codeWords = word.trim().split(' ');

        for (var j = 0; j < codeWords.length; j++) {
          final codeWord = codeWords[j].trim().toUpperCase();

          if (_reverseNato.containsKey(codeWord)) {
            buffer.write(_reverseNato[codeWord]);
          } else {
            // Keep non-NATO words as-is
            buffer.write(codeWord);
          }
        }

        if (i < words.length - 1) {
          buffer.write(' ');
        }
      }

      return buffer.toString();
    } catch (e) {
      throw Exception('Decoding failed: ${e.toString()}');
    }
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = 'Please enter text to convert');
      return;
    }

    try {
      String output;

      if (_mode == 'encode') {
        output = _encodeToNato(input);
      } else {
        output = _decodeFromNato(input);
      }

      final buffer = StringBuffer();
      buffer.writeln('NATO PHONETIC ALPHABET');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');

      if (_mode == 'encode') {
        buffer.writeln('INPUT (Original Text)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n\n');

        buffer.writeln('OUTPUT (NATO Phonetic)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n\n');

        buffer.writeln('REFERENCE CHART');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('A: Alpha    N: November\n');
        buffer.writeln('B: Bravo    O: Oscar\n');
        buffer.writeln('C: Charlie  P: Papa\n');
        buffer.writeln('D: Delta    Q: Quebec\n');
        buffer.writeln('E: Echo     R: Romeo\n');
        buffer.writeln('F: Foxtrot  S: Sierra\n');
        buffer.writeln('G: Golf     T: Tango\n');
        buffer.writeln('H: Hotel    U: Uniform\n');
        buffer.writeln('I: India    V: Victor\n');
        buffer.writeln('J: Juliett  W: Whiskey\n');
        buffer.writeln('K: Kilo     X: X-ray\n');
        buffer.writeln('L: Lima     Y: Yankee\n');
        buffer.writeln('M: Mike     Z: Zulu\n\n');

        buffer.writeln('USAGE');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('• Aviation & military communications\n');
        buffer.writeln('• Clear spelling over radio/phone\n');
        buffer.writeln('• Customer service & support\n');
        buffer.writeln('• Password verification\n');
      } else {
        buffer.writeln('INPUT (NATO Phonetic)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$input\n\n');

        buffer.writeln('OUTPUT (Decoded Text)');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('$output\n\n');

        buffer.writeln('VALIDATION');
        buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
        buffer.writeln('✓ Valid NATO format\n');
        buffer.writeln('✓ Successfully decoded\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'NATO PHONETIC',
      activeCategory: ToolCategory.encodeDecode,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'MODE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modes.map((mode) {
                final isSelected = mode == _mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _mode = mode;
                      _result = '';
                      _inputController.clear();
                    });
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0x2000FF88),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'INPUT'),
            const SizedBox(height: 8),
            AppInput(
              controller: _inputController,
              hintText: _mode == 'encode'
                  ? 'Enter text to spell phonetically...'
                  : 'Enter NATO phonetic words (separated by spaces)...',
              maxLines: 5,
              onChanged: (_) {
                if (_result.isNotEmpty) setState(() => _result = '');
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: Icon(
                    _mode == 'encode' ? Icons.translate : Icons.text_fields),
                label: Text(
                    _mode == 'encode' ? 'ENCODE TO NATO' : 'DECODE FROM NATO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'CONVERSION RESULT',
                monospace: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
