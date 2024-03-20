// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatefulWidget {
  final String label;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isOnlyNumber;
  final bool isDisable;
  final bool isOnlyDigit;
  final int maxLength;
  final String? Function(dynamic data)? validator;

  const BuildTextField(
      {super.key,
      this.controller,
      this.initialValue,
      this.validator,
      this.maxLength = 50,
      this.isDisable = false,
      this.isOnlyDigit = false,
      this.isOnlyNumber = false,
      required this.onChanged,
      required this.label});

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isDisable,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      initialValue: widget.initialValue,
      inputFormatters: widget.isOnlyDigit
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : null,
      keyboardType:
          widget.isOnlyNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        
      ),
    );
  }
}
