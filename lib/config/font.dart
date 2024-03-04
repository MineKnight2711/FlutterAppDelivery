import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trasua_delivery/config/colors.dart';

class CustomFonts {
  static TextStyle customGoogleFonts({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColors.dark100,
    );
  }
}
