import 'package:flutter/material.dart';

class InputHelper {
  static bool emptyFieldChecker(
      List<TextEditingController> controllers, List<String?> errorMessage) {
    bool errorStatus = false;
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        errorMessage[i] = 'Field ini tidak boleh kosong';
        errorStatus = true;
      }
    }
    return errorStatus;
  }
}
