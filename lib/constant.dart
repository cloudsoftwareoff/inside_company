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
    scaffoldBackgroundColor: const Color(0xffDAD3C8),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
    ),
    cardTheme: const CardTheme(color: Colors.white, elevation: 8),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    listTileTheme: const ListTileThemeData(tileColor: Colors.white));
