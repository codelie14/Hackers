import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool autofocus;
  final String? initialValue;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;

  const AppInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixText,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
    this.autofocus = false,
    this.initialValue,
    this.style,
    this.contentPadding,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      readOnly: readOnly,
      autofocus: autofocus,
      focusNode: focusNode,
      style: style ??
          const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class AppTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const AppTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.minLines = 4,
    this.maxLines = 10,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: TextInputType.multiline,
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
