import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomAlert {
  static void error({required String message, required BuildContext context}) {
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: message,
        ),
        displayDuration: Duration(milliseconds: 400),
        reverseAnimationDuration: Duration(milliseconds: 300),
        animationDuration: Duration(milliseconds: 400),
        snackBarPosition: SnackBarPosition.bottom);
  }

  static void success(
      {required String message, required BuildContext context}) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
      ),
    );
  }
}
