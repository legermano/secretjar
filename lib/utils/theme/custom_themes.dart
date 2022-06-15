import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primaryColor: const Color(0xff892cdc),
  primaryColorDark: Colors.purple,
  scaffoldBackgroundColor: const Color(0xff151515),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff151515),
  ),
  textTheme: const TextTheme().apply(
    fontFamily: "customFont",
  ),
  fontFamily: "customFont",
);

final defaultTheme = ThemeData(
  primaryColor: const Color(0xff892cdc),
  primaryColorDark: Colors.purple,
  textTheme: const TextTheme().apply(
    fontFamily: "customFont",
  ),
  fontFamily: "customFont",
);
