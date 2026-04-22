import 'package:flutter/material.dart';
import 'package:app/utils/profixStyles.dart';
import '../utils/profix_colors.dart';

class CustomTextField extends StatelessWidget {
  final Color borderColor;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool isEditable;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    this.borderColor = ProfixColors.gray2,
    this.hintText = '',
    this.labelText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.hintStyle,
    this.labelStyle,
    this.maxLines,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.grey,
      enabled: isEditable,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: '*',
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : (maxLines ?? 1),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: hintStyle ?? ProfixStyles.medium16gray,
        labelStyle: labelStyle ?? ProfixStyles.medium16gray,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ProfixColors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ProfixColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: ProfixColors.red),
        ),
      ),
    );
  }
}
