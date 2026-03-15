import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class LoremIpsumGeneratorWidget extends ConsumerStatefulWidget {
  const LoremIpsumGeneratorWidget({super.key});

  @override
  ConsumerState<LoremIpsumGeneratorWidget> createState() =>
      _LoremIpsumGeneratorWidgetState();
}

class _LoremIpsumGeneratorWidgetState
    extends ConsumerState<LoremIpsumGeneratorWidget> {
  final _amountController = TextEditingController(text: '3');
  String _selectedType = 'paragraphs';
  String _result = '';

  final List<String> _types = ['Paragraphs', 'Sentences', 'Words'];

  // Classic Lorem Ipsum words
  final List<String> _loremWords = [
    'lorem',
    'ipsum',
    'dolor',
    'sit',
    'amet',
    'consectetur',
    'adipiscing',
    'elit',
    'sed',
    'do',
    'eiusmod',
    'tempor',
    'incididunt',
    'ut',
    'labore',
    'et',
    'dolore',
    'magna',
    'aliqua',
    'enim',
    'ad',
    'minim',
    'veniam',
    'quis',
    'nostrud',
    'exercitation',
    'ullamco',
    'laboris',
    'nisi',
    'aliquip',
    'ex',
    'ea',
    'commodo',
    'consequat',
    'duis',
    'aute',
    'irure',
    'in',
    'reprehenderit',
    'voluptate',
    'velit',
    'esse',
    'cillum',
    'fugiat',
    'nulla',
    'pariatur',
    'excepteur',
    'sint',
    'occaecat',
    'cupidatat',
    'non',
    'proident',
    'sunt',
    'culpa',
    'qui',
    'officia',
    'deserunt',
    'mollit',
    'anim',
    'id',
    'est',
    'laborum'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _generateWord() {
    final random = Random();
    final wordLength = random.nextInt(8) + 3; // 3-10 letters
    return List.generate(
        wordLength, (_) => String.fromCharCode(random.nextInt(26) + 97) // a-z
        ).join();
  }

  String _generateSentence({bool isStart = false}) {
    final random = Random();
    final wordCount = random.nextInt(15) + 8; // 8-22 words

    List<String> words;
    if (isStart) {
      // Start with classic Lorem Ipsum
      words = _loremWords.sublist(0, min(wordCount, _loremWords.length));
    } else {
      words = List.generate(wordCount, (_) => _generateWord());
    }

    // Capitalize first letter and add period
    var sentence = words.join(' ');
    sentence = sentence[0].toUpperCase() + sentence.substring(1);
    return '$sentence.';
  }

  String _generateParagraph({bool isStart = false}) {
    final random = Random();
    final sentenceCount = random.nextInt(4) + 3; // 3-6 sentences

    return List.generate(sentenceCount,
        (index) => _generateSentence(isStart: isStart && index == 0)).join(' ');
  }

  void _generate() {
    final amount = int.tryParse(_amountController.text.trim()) ?? 1;
    if (amount < 1 || amount > 100) {
      setState(() => _result = 'Please enter a number between 1 and 100');
      return;
    }

    try {
      final buffer = StringBuffer();
      buffer.writeln('LOREM IPSUM GENERATOR');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

      String generatedText;

      switch (_selectedType.toLowerCase()) {
        case 'words':
          generatedText =
              List.generate(amount, (_) => _generateWord()).join(' ');
          buffer.writeln('Generated Words: $amount\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
          buffer.writeln(generatedText);
          break;

        case 'sentences':
          generatedText = List.generate(
                  amount, (index) => _generateSentence(isStart: index == 0))
              .join('\n\n');
          buffer.writeln('Generated Sentences: $amount\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
          buffer.writeln(generatedText);
          break;

        case 'paragraphs':
        default:
          generatedText = List.generate(
                  amount, (index) => _generateParagraph(isStart: index == 0))
              .join('\n\n');
          buffer.writeln('Generated Paragraphs: $amount\n');
          buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
          buffer.writeln(generatedText);
          break;
      }

      // Add stats
      final charCount = generatedText.length;
      final wordCount =
          generatedText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      final sentenceCount = generatedText
          .split(RegExp(r'[.!?]'))
          .where((s) => s.isNotEmpty)
          .length;

      buffer.writeln('\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('STATISTICS\n');
      buffer.writeln('Characters: $charCount\n');
      buffer.writeln('Words: $wordCount\n');
      buffer.writeln('Sentences: $sentenceCount\n');
      if (_selectedType.toLowerCase() == 'paragraphs') {
        buffer.writeln('Paragraphs: $amount\n');
      }

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'LOREM IPSUM',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'GENERATE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((type) {
                final isSelected = type.toLowerCase() == _selectedType;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedType = type.toLowerCase();
                      _result = '';
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
            const SectionHeader(title: 'AMOUNT'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: _amountController,
                    hintText: 'Number...',
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      if (_result.isNotEmpty) setState(() => _result = '');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedType,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generate,
                icon: const Icon(Icons.format_quote),
                label: Text('GENERATE ${_selectedType.toUpperCase()}'),
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
                label: 'GENERATED TEXT',
                monospace: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
