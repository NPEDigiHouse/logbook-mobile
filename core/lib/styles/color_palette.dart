import 'package:flutter/material.dart';

// Colors
const primaryColor = Color(0xFF00C2FF);
const secondaryColor = Color(0xFF00A7DB);
const variant1Color = Color(0xFFF72585);
const variant2Color = Color(0xFF7209B7);
const backgroundColor = Color(0xFFF8F8F8);
const scaffoldBackgroundColor = Color(0xFFFFFFFF);
const primaryTextColor = Color(0xFF222431);
const secondaryTextColor = Color(0xFFBBBEC1);
const dividerColor = Color(0xFFE4E4E4);
const errorColor = Color(0xFFD1495B);
const successColor = Color(0xFF56B9A1);
const onDisableColor = Color(0xFFF3F4F6);
const onFormDisableColor = Color(0xFF9CA3AF);
const borderColor = Color(0xFF8E90A3);

// Color scheme
final colorScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: scaffoldBackgroundColor,
  secondary: secondaryColor,
  onSecondary: scaffoldBackgroundColor,
  onTertiary: scaffoldBackgroundColor,
  background: backgroundColor,
  onBackground: primaryTextColor,
  error: errorColor,
  errorContainer: errorColor,
  onError: scaffoldBackgroundColor,
);
