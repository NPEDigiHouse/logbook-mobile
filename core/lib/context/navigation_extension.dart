import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(Widget page, {Object? data}) {
    Navigator.of(this).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  void replace(Widget page, {Object? data}) {
    Navigator.of(this).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    );
  }

  void removeUntil(Widget page, {Object? data}) {
    Navigator.of(this).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        settings: RouteSettings(
          arguments: data,
        ),
      ),
      (route) => false,
    );
  }

  void back() {
    Navigator.pop(this);
  }
}

extension VariantAppBar on AppBar {
  AppBar variant() {
    return AppBar(
      title: title,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: backgroundColor,
        fontWeight: FontWeight.bold,
      ),
      actions: actions,
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(
        color: backgroundColor,
      ),
      actionsIconTheme: const IconThemeData(
        color: backgroundColor,
      ),
    );
  }
}

extension FilledButtonFullWidth on FilledButton {
  SizedBox fullWidth() {
    return SizedBox(
      width: double.infinity,
      child: this,
    );
  }
}

extension Capitalize on String {
  String toCapitalize() {
    if (trim().isEmpty) return '';
    return split(' ').map((e) {
      if (e.isEmpty) return ''; // Check if the substring is empty
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1)}';
    }).join(' ');
  }
}
