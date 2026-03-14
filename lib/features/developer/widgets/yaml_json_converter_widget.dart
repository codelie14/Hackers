import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/copy_button.dart';
import '../../../data/models/tool_model.dart';
import '../services/yaml_json_service.dart';

class YamlJsonConverterWidget extends ConsumerStatefulWidget {
  const YamlJsonConverterWidget({super.key});

  @override
  ConsumerState<YamlJsonConverterWidget> createState() => _YamlJsonConverterWidgetState();
}

class _YamlJsonConverterWidgetState extends ConsumerState<YamlJsonConverterWidget> {
  final _inputController = TextEditingController();
  bool _yamlToJson = true;
  bool _isLoading = false;
  String _result = '';
  bool _prettyPrint = true;
  String? _error;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _error = 'Please enter input');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
      _error = null;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        String output;

        if (_yamlToJson) {
          // YAML to JSON
          output = YamlJsonService.yamlToJson(input, pretty: _prettyPrint);
        } else {
          // JSON to YAML
          output = YamlJsonService.jsonToYaml(input);
        }

        setState(() {
          _result = output;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    });
  }

  void _validate() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    Map<String, dynamic> validationResult;
    
    if (_yamlToJson) {
      validationResult = YamlJsonService.validateYaml(input);
    } else {
      validationResult = YamlJsonService.validateJson(input);
    }

    setState(() {
      _error = validationResult['valid'] ? null : validationResult['message'];
      if (validationResult['valid']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validationResult['message'] as String),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _yamlToJson ? 'YAML → JSON' : 'JSON → YAML',
      activeCategory: ToolCategory.developer,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode switcher
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _yamlToJson = true;
                        _result = '';
                        _error = null;
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _yamlToJson ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Center(
                          child: Text(
                            'YAML → JSON',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _yamlToJson = false;
                        _result = '';
                        _error = null;
                      }),
                      borderRadius: BorderRadius.circular(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_yamlToJson ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Center(
                          child: Text(
                            'JSON → YAML',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SectionHeader(
              title: _yamlToJson ? 'YAML Input' : 'JSON Input',
              subtitle: 'Paste your ${_yamlToJson ? "YAML" : "JSON"} here',
            ),
            const SizedBox(height: 8),
            AppTextArea(
              controller: _inputController,
              hintText: _yamlToJson 
                  ? 'name: John\nage: 30\ncity: New York' 
                  : '{\n  "name": "John",\n  "age": 30\n}',
              minLines: 6,
              maxLines: 12,
              onChanged: (_) {
                if (_result.isNotEmpty || _error != null) {
                  setState(() {
                    _result = '';
                    _error = null;
                  });
                }
              },
            ),

            // Options
            if (_yamlToJson) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pretty Print JSON',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Switch.adaptive(
                      value: _prettyPrint,
                      onChanged: (value) {
                        setState(() {
                          _prettyPrint = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'CONVERT ▶',
                    icon: Icons.swap_horiz,
                    isLoading: _isLoading,
                    fullWidth: true,
                    onPressed: _convert,
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  label: 'CHECK',
                  icon: Icons.check_circle_outline,
                  variant: AppButtonVariant.secondary,
                  onPressed: _validate,
                ),
              ],
            ),

            if (_error != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dangerDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_result.isNotEmpty) ...[
              const SizedBox(height: 24),
              SectionHeader(
                title: _yamlToJson ? 'JSON Output' : 'YAML Output',
                subtitle: '${_result.length} characters',
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGhost,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _yamlToJson ? 'JSON' : 'YAML',
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CopyButton(text: _result),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _result,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
