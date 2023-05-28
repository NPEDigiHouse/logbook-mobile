import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

ThemeData get lightTheme {
  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: textTheme,
    useMaterial3: true,
  ).copyWith(
    dividerColor: dividerColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    inputDecorationTheme: inputDecorationTheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    appBarTheme: appBarTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

final appBarTheme = AppBarTheme(
    titleTextStyle: textTheme.titleMedium?.copyWith(
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    elevation: 2,
    shadowColor: Colors.black38,
    iconTheme: IconThemeData(
      color: primaryColor,
    ),
    centerTitle: true,
    actionsIconTheme: IconThemeData(
      color: primaryColor,
    ));

final filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: scaffoldBackgroundColor,
    textStyle: textTheme.titleMedium?.copyWith(
      color: scaffoldBackgroundColor,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
  ),
);

final textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
  ),
);

final inputDecorationTheme = InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: onFormDisableColor,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: onFormDisableColor,
    ),
  ),
  hintStyle: const TextStyle(
    color: onFormDisableColor,
  ),
);
