import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
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

  void back() {
    Navigator.pop(this);
  }
}

extension VariantAppBar on AppBar {
  AppBar variant() {
    return AppBar(
      title: this.title,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: backgroundColor,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(
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
