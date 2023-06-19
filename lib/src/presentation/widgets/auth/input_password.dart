import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  final String label;
  final String? errorText;
  final TextEditingController controller;

  const InputPassword(
      {super.key,
      required this.label,
      required this.controller,
      this.errorText});

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  final ValueNotifier<bool> isVisible = ValueNotifier(false);

  @override
  void dispose() {
    isVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isVisible,
        builder: (context, val, _) {
          return TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              errorText: widget.errorText,
              label: Text(widget.label),
              suffixIcon: IconButton(
                icon: Icon(
                  val
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  isVisible.value = !isVisible.value;
                },
              ),
            ),
            obscureText: !val,
          );
        });
  }
}
