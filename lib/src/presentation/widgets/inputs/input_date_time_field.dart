import 'dart:async';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:flutter/material.dart';

class InputDateTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final DateTime initialDate;
  final FutureOr<void> Function(DateTime date)? action;

  const InputDateTimeField(
      {super.key,
      required this.action,
      required this.controller,
      required this.hintText,
      required this.initialDate});

  @override
  State<InputDateTimeField> createState() => _InputDateTimeFieldState();
}

class _InputDateTimeFieldState extends State<InputDateTimeField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        );

        if (time == null) return;

        setState(() {
          final dateTime = DateTime(
              widget.initialDate!.year,
              widget.initialDate!.month,
              widget.initialDate!.day,
              time.hour,
              time.minute);
          widget.controller.text = ReusableFunctionHelper.datetimeToStringTime(
            dateTime,
          );
          widget.action!.call(dateTime);
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
