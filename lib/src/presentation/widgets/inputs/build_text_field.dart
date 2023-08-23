import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  final String label;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final bool isOnlyNumber;

  const BuildTextField(
      {Key? key,
      this.controller,
      this.isOnlyNumber = false,
      required this.onChanged,
      required this.label})
      : super(key: key);

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType:
          widget.isOnlyNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
    );
  }
}
