import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomAlert {
  static void error({
    required String message,
    required BuildContext context,
  }) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: message,
          textStyle:
              textTheme.bodyMedium!.copyWith(color: scaffoldBackgroundColor),
        ),
        displayDuration: const Duration(milliseconds: 400),
        reverseAnimationDuration: const Duration(milliseconds: 300),
        animationDuration: const Duration(milliseconds: 400),
        snackBarPosition: SnackBarPosition.bottom);
  }

  static void success(
      {required String message, required BuildContext context}) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: message,
          textStyle:
              textTheme.bodyMedium!.copyWith(color: scaffoldBackgroundColor),
        ),
        displayDuration: const Duration(milliseconds: 400),
        reverseAnimationDuration: const Duration(milliseconds: 300),
        animationDuration: const Duration(milliseconds: 400),
        snackBarPosition: SnackBarPosition.bottom);
  }
}
