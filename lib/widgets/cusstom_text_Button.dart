import 'package:flutter/material.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';

class CusstomTextButton extends StatelessWidget {
  final VoidCallback? onButtonClicked;
  final String text;
  final TextAlign? textAlign;

  const CusstomTextButton({
    super.key,
    required this.onButtonClicked,
    required this.text,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonClicked,
      child: Text(
        text,
        style: ProfixStyles.bold16blue.copyWith(
          decorationColor: ProfixColors.lightBlue,
          decoration: TextDecoration.underline,
        ),
        textAlign: textAlign ?? TextAlign.end,
      ),
    );
  }
}
