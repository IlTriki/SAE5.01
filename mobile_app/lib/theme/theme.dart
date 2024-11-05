import 'package:flutter/material.dart';

const Color kMainAppColor = Color(0xFF613EEA);

// light theme
const Color kLightScaffoldBackgroundColor = Color(0xFFF6F6F9);
const Color kLightWidgetOnScaffoldBackgroundColor = Color(0xFFF1F1FA);
const Color kLightIconColor = Color(0xFFF1F1FA);
const Color kLightTextFieldBackgroundColor = Color.fromRGBO(247, 247, 253, 1);
const Color kLightPlaceholderTextColor = Color.fromRGBO(153, 154, 162, 1);
const Color kLightInactiveTextColor = Color(0xFFE8E9EC);
const Color kLightBorderColor = Color(0xFFC4C5CE);
const Color kLightOppositeThemeColor = Color(0xFF19191B);

// dark theme
const Color kDarkScaffoldBackgroundColor = Color(0xFF19191B);
const Color kDarkWidgetOnScaffoldBackgroundColor = Color(0xFF151529);
const Color kDarkIconColor = Color(0xFF151529);
const Color kDarkTextFieldBackgroundColor = Color.fromRGBO(27, 25, 41, 1);
const Color kDarkPlaceholderTextColor = Color.fromRGBO(99, 101, 115, 1);
const Color kDarkInactiveTextColor = Color(0xFF222325);
const Color kDarkBorderColor = Color(0xFF46484F);
const Color kDarkOppositeThemeColor = Color(0xFFF6F6F9);

final ThemeData lightTheme = ThemeData(
  iconTheme: const IconThemeData(color: kLightIconColor),
  scaffoldBackgroundColor: kLightScaffoldBackgroundColor,
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: kMainAppColor),
  primaryColor: kLightScaffoldBackgroundColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: kMainAppColor,
    onPrimary: kLightScaffoldBackgroundColor,
    secondary: kLightWidgetOnScaffoldBackgroundColor,
    onSecondary: kLightScaffoldBackgroundColor,
    tertiary: kLightTextFieldBackgroundColor,
    error: Colors.red,
    errorContainer: kLightWidgetOnScaffoldBackgroundColor,
    onError: kLightScaffoldBackgroundColor,
    surface: kLightWidgetOnScaffoldBackgroundColor,
    onSurface: kLightTextFieldBackgroundColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kLightScaffoldBackgroundColor,
    iconTheme: IconThemeData(color: kDarkIconColor),
    actionsIconTheme: IconThemeData(color: kDarkIconColor),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: kLightBorderColor,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: kLightBorderColor,
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: kLightOppositeThemeColor,
    ),
  ),
  hintColor: kLightPlaceholderTextColor,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: kLightScaffoldBackgroundColor,
  ),
  // primaryColor: Colors.white,
  // secondaryHeaderColor: const Color.fromRGBO(14, 10, 23, 1),
  // colorScheme: const ColorScheme.light(
  //   primary: Color(0xFF613EEA),
  //   secondary: Color(0xFF9DB2CE),
  //   tertiary: Colors.black12,
  // ),
  // bottomAppBarTheme: const BottomAppBarTheme(
  //   color: Colors.white,
  // ),
  // iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
  // floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //   backgroundColor: Color(0xFF613EEA),
  // ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: ButtonStyle(
  //     backgroundColor:
  //         WidgetStateProperty.all(const Color.fromRGBO(14, 10, 23, 1)),
  //     textStyle: WidgetStateProperty.all(
  //       const TextStyle(
  //         color: Colors.white,
  //       ),
  //     ),
  //   ),
  // ),
  // canvasColor: Colors.black87,
  // appBarTheme: const AppBarTheme(
  //   iconTheme: IconThemeData(color: Color(0xFF9DB2CE)),
  //   backgroundColor: Colors.white,
  // ),
  // scaffoldBackgroundColor: Colors.white,
  // shadowColor: Colors.black,
  fontFamily: 'Poppins',
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  iconTheme: const IconThemeData(color: kDarkIconColor),
  scaffoldBackgroundColor: kDarkScaffoldBackgroundColor,
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: kMainAppColor),
  primaryColor: kDarkScaffoldBackgroundColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: kMainAppColor,
    onPrimary: kDarkScaffoldBackgroundColor,
    secondary: kDarkWidgetOnScaffoldBackgroundColor,
    onSecondary: kDarkScaffoldBackgroundColor,
    tertiary: kDarkTextFieldBackgroundColor,
    error: Colors.red,
    errorContainer: kDarkWidgetOnScaffoldBackgroundColor,
    onError: kDarkScaffoldBackgroundColor,
    surface: kDarkWidgetOnScaffoldBackgroundColor,
    onSurface: kDarkTextFieldBackgroundColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kDarkScaffoldBackgroundColor,
    iconTheme: IconThemeData(color: kLightIconColor),
    actionsIconTheme: IconThemeData(color: kLightIconColor),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: kDarkBorderColor,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: kDarkBorderColor,
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: kDarkOppositeThemeColor,
    ),
  ),
  hintColor: kDarkPlaceholderTextColor,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: kDarkScaffoldBackgroundColor,
  ),
  // primaryColor: Colors.black,
  // secondaryHeaderColor: Colors.white,
  // colorScheme: const ColorScheme.dark(
  // primary: Color.fromARGB(255, 124, 95, 237),
  //   secondary: Color(0xFF9DB2CE),
  //   tertiary: Colors.white12,
  // ),
  // bottomAppBarTheme: const BottomAppBarTheme(
  //   color: Colors.black,
  // ),
  // iconTheme: const IconThemeData(color: Color(0xFF9DB2CE)),
  // floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //   backgroundColor: Color.fromARGB(255, 124, 95, 237),
  // ),
  // outlinedButtonTheme: OutlinedButtonThemeData(
  //   style: ButtonStyle(
  //     backgroundColor:
  //         WidgetStateProperty.all(const Color.fromRGBO(14, 10, 23, 1)),
  //     textStyle: WidgetStateProperty.all(
  //       const TextStyle(
  //         color: Color.fromARGB(255, 124, 95, 237),
  //       ),
  //     ),
  //   ),
  // ),
  // canvasColor: Colors.white54,
  // appBarTheme: const AppBarTheme(
  //   iconTheme: IconThemeData(color: Color(0xFF9DB2CE)),
  //   backgroundColor: Color.fromRGBO(14, 10, 23, 1),
  // ),
  // scaffoldBackgroundColor: const Color.fromRGBO(14, 10, 23, 1),
  // shadowColor: Colors.black,
  fontFamily: 'Poppins',
  useMaterial3: true,
);
