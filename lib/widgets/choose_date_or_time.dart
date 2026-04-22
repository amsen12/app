import 'package:flutter/material.dart';
import '../utils/profixStyles.dart';
import 'custom_text_Widget.dart';

class ChooseDateOrTime extends StatelessWidget {
  final String iconName;
  final String eventDateOrTime;
  final String chooseDateOrTime;
  final VoidCallback onChooseClick;

  const ChooseDateOrTime({
    super.key,
    required this.iconName,
    required this.eventDateOrTime,
    required this.chooseDateOrTime,
    required this.onChooseClick,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Image.asset(iconName),
        SizedBox(width: width * 0.02),
        CustomTextWidget(
          text: eventDateOrTime,
          textStyle: ProfixStyles.medium16black,
        ),
        const Spacer(),
        InkWell(
          onTap: onChooseClick,
          child: CustomTextWidget(
            text: chooseDateOrTime,
            textStyle: ProfixStyles.medium16black,
          ),
        )
      ],
    );
  }
}
