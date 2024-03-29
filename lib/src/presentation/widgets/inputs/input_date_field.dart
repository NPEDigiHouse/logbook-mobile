import 'dart:async';

import 'package:elogbook/core/helpers/utils.dart';
import 'package:flutter/material.dart';

class InputDateField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? initialValue;
  final String? Function(dynamic data)? validator;
  final FutureOr<void> Function(DateTime date)? action;
  const InputDateField(
      {super.key,
      required this.action,
      this.initialValue,
      this.validator,
      required this.controller,
      required this.hintText});

  @override
  State<InputDateField> createState() => _InputDateFieldState();
}

class _InputDateFieldState extends State<InputDateField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      readOnly: true,
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: widget.controller.text.isEmpty
              ? DateTime.now()
              : Utils.stringToDateTime(widget.controller.text),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );

        if (selected == null) return;
        setState(() {
          widget.controller.text = Utils.datetimeToString(selected);
          widget.action!.call(selected);
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
