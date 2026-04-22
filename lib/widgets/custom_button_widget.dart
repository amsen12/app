import 'package:flutter/material.dart';
import 'package:app/utils/profixStyles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String iconName;
  final String text;
  final Color backGroundColor;
  final TextStyle? textStyle;
  final VoidCallback onButtonClicked;
  final Color borderColor;

  const CustomButtonWidget({
    super.key,
    required this.iconName,
    required this.text,
    required this.backGroundColor,
    this.textStyle,
    required this.onButtonClicked,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroundColor,
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
          horizontal: width * 0.04,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onPressed: onButtonClicked,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconName),
          SizedBox(width: width * 0.02),
          Text(
            text,
            style: textStyle ?? ProfixStyles.medium20primary,
          )
        ],
      ),
    );
  }
}
