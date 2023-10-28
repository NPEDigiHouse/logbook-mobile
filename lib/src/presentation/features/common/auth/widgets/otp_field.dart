import 'package:elogbook/core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OtpField extends StatelessWidget {
  final String name;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String?)? onChanged;

  const OtpField({
    super.key,
    required this.name,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: dividerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FormBuilderTextField(
          name: name,
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
          ),
          decoration: InputDecoration(
            counterText: '',
            errorStyle: const TextStyle(height: 0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: FormBuilderValidators.required(
            errorText: '',
          ),
        ),
      ),
    );
  }
}
