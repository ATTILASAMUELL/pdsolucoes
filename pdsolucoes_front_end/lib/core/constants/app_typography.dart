import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static const double baseSize = 16.0;
  static const double scale = 1.333;

  static const double h1Size = 47.78;
  static const double h2Size = 35.83;
  static const double h3Size = 26.88;
  static const double h4Size = 21.28;
  static const double h5Size = 16.0;
  static const double paragraphSize = 16.0;
  static const double smallSize = 12.0;

  static TextStyle h1({Color? color}) => GoogleFonts.roboto(
        fontSize: h1Size,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color? color}) => GoogleFonts.roboto(
        fontSize: h2Size,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h3({Color? color}) => GoogleFonts.roboto(
        fontSize: h3Size,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h4({Color? color}) => GoogleFonts.roboto(
        fontSize: h4Size,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h5({Color? color}) => GoogleFonts.roboto(
        fontSize: h5Size,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle paragraph({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.roboto(
        fontSize: paragraphSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
        height: 1.5,
      );

  static TextStyle small({Color? color, FontWeight? fontWeight}) =>
      GoogleFonts.roboto(
        fontSize: smallSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
        height: 1.4,
      );

  static TextStyle label({Color? color}) => GoogleFonts.roboto(
        fontSize: smallSize,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.3,
      );

  static TextStyle button({Color? color}) => GoogleFonts.roboto(
        fontSize: paragraphSize,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );

  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: h1(),
      displayMedium: h2(),
      displaySmall: h3(),
      headlineMedium: h4(),
      headlineSmall: h5(),
      bodyLarge: paragraph(),
      bodyMedium: paragraph(),
      bodySmall: small(),
      labelLarge: button(),
      labelMedium: label(),
      labelSmall: small(fontWeight: FontWeight.w500),
    );
  }
}

