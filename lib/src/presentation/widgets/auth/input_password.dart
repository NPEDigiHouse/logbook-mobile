import 'package:flutter/material.dart';

class InputPassword extends StatelessWidget {
  final String label;
  const InputPassword({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Text(label),
        suffixIcon: Icon(
          Icons.visibility_off_outlined,
        ),
      ),
      obscureText: true,
    );
  }
}
