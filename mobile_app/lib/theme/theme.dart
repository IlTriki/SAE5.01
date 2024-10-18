import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  secondaryHeaderColor: const Color.fromRGBO(14, 10, 23, 1),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF613EEA),
    secondary: Color(0xFF9DB2CE),
    tertiary: Colors.black12,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF613EEA),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.all(const Color.fromRGBO(14, 10, 23, 1)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  ),
  canvasColor: Colors.black87,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
    backgroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  shadowColor: Colors.black,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  secondaryHeaderColor: Colors.white,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF613EEA),
    secondary: Color(0xFF9DB2CE),
    tertiary: Colors.white12,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.black,
  ),
  iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF613EEA),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.all(const Color.fromRGBO(14, 10, 23, 1)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Color(0xFF613EEA),
        ),
      ),
    ),
  ),
  canvasColor: Colors.white54,
  appBarTheme: AppBarTheme(
    color: const Color.fromRGBO(14, 10, 23, 1),
    iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
    backgroundColor: const Color.fromRGBO(14, 10, 23, 1),
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(14, 10, 23, 1),
  shadowColor: Colors.black,
  fontFamily: 'Poppins',
  useMaterial3: true,
);
