
import 'package:flutter/material.dart';

import 'custom_themes/appbar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class EAppTheme {
  EAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Ubuntu',
    brightness: Brightness.light,
    primaryColor: const Color(0xFF70BE92),
    textTheme: ETextTheme.lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: EAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Ubuntu',
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF70BE92),
    textTheme: ETextTheme.darkTextTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: EAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.darkInputDecorationTheme
  );
}
