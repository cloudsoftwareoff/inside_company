import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  //  default colors
  static Color primaryColor = HexColor("#162657");
  static Color secondaryColor = HexColor("#F3CD74");
  static const Color editTextColor = Colors.white;
  static const Color hintTextColor = Colors.white38;
}

ThemeData myTheme = ThemeData(
    //brightness: Brightness.light,
    //primaryColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: AppColors.secondaryColor, //buttons highlights
    ),
    scaffoldBackgroundColor: Color(0xffFFE5DE),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
    ),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white)
    // textTheme: TextTheme(
    //   bodyLarge: TextStyle(color: AppColors.secondaryColor),
    //   bodyMedium: TextStyle(color: AppColors.hintTextColor),
    // ),
    );
