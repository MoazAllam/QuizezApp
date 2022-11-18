import 'package:expert_academy/config/const.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Color color, textColor;
  final String title;
  final Function tap;
  const PrimaryButton({
    Key? key,
    required this.color,
    required this.title,
    required this.tap,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.black,
        minimumSize: const Size(
          double.infinity,
          20,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 0,
      ),
      onPressed: () => tap(),
      child: Text(
        title,
        style: MyStyles.mediumTextStyle.copyWith(color: textColor),
      ),
    );
  }
}
