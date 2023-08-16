import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.label,
    this.textInputAction,
    this.validator,
    this.onSaved,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late final ValueNotifier<bool> isVisible;

  @override
  void initState() {
    isVisible = ValueNotifier(false);

    super.initState();
  }

  @override
  void dispose() {
    isVisible.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isVisible,
      builder: (context, value, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: !value,
          textInputAction: widget.textInputAction,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: IconButton(
              icon: Icon(
                value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => isVisible.value = !value,
            ),
          ),
          validator: widget.validator,
          onSaved: widget.onSaved,
        );
      },
    );
  }
}
