import 'package:flutter/material.dart';
import 'package:app/utils/profixStyles.dart';
import 'package:app/utils/profix_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color backGroundColor;
  final TextStyle? textColor;
  final VoidCallback onButtonClick;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.backGroundColor = ProfixColors.lightBlue,
    this.textColor,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroundColor,
        minimumSize: const Size(double.infinity, 56),
        padding: EdgeInsets.symmetric(
          vertical: height * 0.015,
          horizontal: width * 0.04,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onButtonClick,
      child: Text(
        text,
        style: textColor ?? ProfixStyles.medium20white,
      ),
    );
  }
}
