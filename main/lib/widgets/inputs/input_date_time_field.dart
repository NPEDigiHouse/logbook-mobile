import 'dart:async';
import 'package:core/helpers/utils.dart';
import 'package:flutter/material.dart';

class InputDateTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final DateTime initialDate;
  final String? Function(String? data)? validator;
  final FutureOr<void> Function(DateTime date)? action;

  const InputDateTimeField(
      {super.key,
      required this.action,
      this.validator,
      required this.controller,
      required this.hintText,
      required this.initialDate});

  @override
  State<InputDateTimeField> createState() => _InputDateTimeFieldState();
}

class _InputDateTimeFieldState extends State<InputDateTimeField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      readOnly: true,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(widget.initialDate),
        );

        if (time == null) return;

        setState(() {
          final dateTime = DateTime(
              widget.initialDate.year,
              widget.initialDate.month,
              widget.initialDate.day,
              time.hour,
              time.minute);
          widget.controller.text = Utils.datetimeToStringTime(
            dateTime,
          );
          widget.action!.call(dateTime);
        });
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 2,
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
