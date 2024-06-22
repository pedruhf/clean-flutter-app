import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: primaryColor,
      background: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
          decorationColor: primaryColorDark),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
      labelStyle: TextStyle(
        color: primaryColorLight,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        splashFactory: InkSplash.splashFactory,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        textStyle: const TextStyle(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(20),
        // ),
      ),
    ),
  );
}
