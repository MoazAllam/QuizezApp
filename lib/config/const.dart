import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class MyColors {
  // background color
  Color backgroundColor = const Color(0xff1A1A2F);

  // main colors
  Color mainColor = const Color(0xff6541F5);
  Color cardColor = const Color(0xff232342);
  Color cardBorderColor = Color.fromARGB(255, 255, 255, 255);

  // text colors
  Color headTextColor = const Color(0xffF5F5F7);
  Color smallTextColor = const Color.fromARGB(131, 255, 255, 255);
}

class MyStyles {
  static TextStyle headTextStyle = GoogleFonts.cairo(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: MyColors().headTextColor,
  );

  static TextStyle mediumTextStyle = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: MyColors().headTextColor,
  );

  static TextStyle smallTextStyle = GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: MyColors().smallTextColor,
  );
}

const double defaultPadding = 20.0;
