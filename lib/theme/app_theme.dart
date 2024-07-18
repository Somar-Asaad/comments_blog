import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //created private constructor to make sure no instances of this class can be created from outside (Singleton)
  AppTheme._();

  // light theme of the project
  static ThemeData light() {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F9FD),
      primaryColor: const Color(0xFF0C54BE),
      colorScheme: const ColorScheme.light(
        secondary: Color(0xFFCED3DC),
        primaryContainer: Colors.white,
      ),
      textTheme: AppTextStyle.lightTextTheme,
    );
  }

  //Todo implement the dark theme later
  static ThemeData? dark() {
    return null;
  }
}

class AppTextStyle {
  // singleton again
  AppTextStyle._();

  static TextTheme get lightTextTheme => TextTheme(
        headlineLarge: _headline1,
        titleMedium: _headline2,
        bodySmall: _headline3,
        headlineSmall: _headline4,
      );

  static TextStyle get _baseHeadline => TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
      );

  static TextStyle get _headline1 => _baseHeadline.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0C54BE),
      );

  static TextStyle get _headline2 => _baseHeadline.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  static TextStyle get _headline3 => _baseHeadline.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  static TextStyle get _headline4 => _baseHeadline.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFF5F9FD),
      );
}
