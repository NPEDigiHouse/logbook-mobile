import 'package:elogbook/core/styles/color_palette.dart';
import 'package:flutter/material.dart';

final textTheme = const TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 98,
    fontWeight: FontWeight.w300,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 61,
    fontWeight: FontWeight.w300,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 49,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 35,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  ),
).apply(
  bodyColor: primaryTextColor,
  displayColor: primaryTextColor,
);
