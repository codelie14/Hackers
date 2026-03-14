import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/result_box.dart';
import '../../../data/models/tool_model.dart';

class Argon2Widget extends ConsumerStatefulWidget {
  const Argon2Widget({super.key});

  @override
  ConsumerState<Argon2Widget> createState() => _Argon2WidgetState();
}

class _Argon2WidgetState extends ConsumerState<Argon2Widget> {
  final _controller = TextEditingController();
  String _result = '';
  int _memoryCost = 65536; // 64 MB
  int _timeCost = 3;
  int _parallelism = 4;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hash() {
    setState(() => _result = '');

    try {
      final input = _controller.text;
      if (input.isEmpty) {
        setState(() => _result = 'Please enter a password');
        return;
      }

      final buffer = StringBuffer();
      buffer.writeln('ARGON2 HASH\n');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      buffer.writeln('Password: ${'*' * input.length}\n');
      buffer.writeln('Parameters:\n');
      buffer.writeln(
          '• Memory Cost: $_memoryCost KB (${_memoryCost ~/ 1024} MB)\n');
      buffer.writeln('• Time Cost: $_timeCost iterations\n');
      buffer.writeln('• Parallelism: $_parallelism threads\n');
      buffer.writeln('Hash:\n');
      buffer.writeln(
          '\$argon2id\$v=19\$m=$_memoryCost,t=$_timeCost,p=$_parallelism\$...\n');
      buffer.writeln(
          '\nNote: Full Argon2 implementation requires argon2 package');

      setState(() => _result = buffer.toString());
    } catch (e) {
      setState(() => _result = 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ARGON2 HASH',
      activeCategory: ToolCategory.crypto,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'PASSWORD'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password...',
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: AppColors.bgElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              onChanged: (_) => setState(() => _result = ''),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'MEMORY COST'),
            const SizedBox(height: 8),
            Slider(
              value: _memoryCost.toDouble(),
              min: 1024,
              max: 262144,
              divisions: 10,
              label: '${_memoryCost ~/ 1024} MB',
              activeColor: AppColors.accent,
              onChanged: (value) => setState(() => _memoryCost = value.toInt()),
            ),
            const SectionHeader(title: 'TIME COST'),
            const SizedBox(height: 8),
            Slider(
              value: _timeCost.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$_timeCost',
              activeColor: AppColors.accent,
              onChanged: (value) => setState(() => _timeCost = value.toInt()),
            ),
            const SectionHeader(title: 'PARALLELISM'),
            const SizedBox(height: 8),
            Slider(
              value: _parallelism.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              label: '$_parallelism',
              activeColor: AppColors.accent,
              onChanged: (value) =>
                  setState(() => _parallelism = value.toInt()),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'GENERATE HASH',
              icon: Icons.security,
              onPressed: _hash,
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              ResultBox(
                content: _result,
                label: 'ARGON2 HASH',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
