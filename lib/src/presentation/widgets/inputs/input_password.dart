import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputPassword extends StatefulWidget {
  final String name;
  final String label;
  final String? Function(String?)? validator;

  const InputPassword({
    super.key,
    required this.name,
    required this.label,
    this.validator,
  });

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
      builder: (context, value, child) {
        return FormBuilderTextField(
          name: widget.name,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            label: Text(widget.label),
            suffixIcon: IconButton(
              icon: Icon(
                value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => isVisible.value = !isVisible.value,
            ),
          ),
          obscureText: !value,
          validator: widget.validator,
        );
      },
    );
  }
}
