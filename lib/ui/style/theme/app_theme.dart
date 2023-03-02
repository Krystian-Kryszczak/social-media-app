import 'package:flutter/material.dart';

import '../palette/palette.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    // primaryColor: Colors.white,
    // primarySwatch: MaterialColor(Colors.white.value, Colors.white.swatch),
    // scaffoldBackgroundColor: const Color(0xFFF0F2F5),
    // fontFamily: Palette.fontFamily,
    appBarTheme: const AppBarTheme(backgroundColor: Palette.lightColor),
    // indicatorColor: Palette.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: Palette.primaryColor,
      secondary: Palette.primaryColor,
      onPrimary: Palette.darkColor,
    )
  );
  // -------------------------------------------------- //
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    // primaryColor: Colors.black87,
    // primarySwatch: MaterialColor(Colors.white.value, Colors.white.swatch),
    // primaryColorLight: Palette.primaryColorLight,
    // primaryColorDark: Palette.primaryColorDark,
    // fontFamily: Palette.fontFamily,
    scaffoldBackgroundColor: const Color(0xFF181818),
    cardColor: const Color(0xFF232323),
    // appBarTheme: const AppBarTheme(backgroundColor: Palette.darkColor),
    indicatorColor: Palette.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: Palette.primaryColor,
      secondary: Palette.primaryColor,
      onPrimary: Palette.lightColor,
    ),
  );
}
