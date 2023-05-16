import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(Widget page, {Object? data}) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(arguments: data),
      ),
    );
  }
}
