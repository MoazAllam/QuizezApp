import 'package:expert_academy/config/const.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String title;
  final bool isPassword;
  final TextEditingController controller;
  final Icon icon;
  const InputField({
    Key? key,
    required this.controller,
    required this.title,
    required this.isPassword,
    required this.icon,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        textAlign: TextAlign.right,
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          prefixIcon: widget.icon,
          fillColor: MyColors().cardColor,
          labelText: widget.title,
          labelStyle: MyStyles.smallTextStyle,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors().mainColor,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors().cardBorderColor,
            ),
          ),
        ),
        style: MyStyles.smallTextStyle.copyWith(
          color: Colors.white,
        ),
        obscureText: widget.isPassword,
      ),
    );
  }
}
