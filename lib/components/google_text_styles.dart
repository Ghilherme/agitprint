import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class GoogleTextStyles {
  static TextStyle customTextStyle({
    Color color = AppColors.blackShade3,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 14,
    FontStyle fontStyle: FontStyle.normal,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  static TextStyle customTextStyle2({
    Color color = AppColors.blackShade7,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 16,
    FontStyle fontStyle: FontStyle.normal,
  }) {
    return GoogleFonts.comfortaa(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }
}
