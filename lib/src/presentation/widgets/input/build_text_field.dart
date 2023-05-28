import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  final String label;
  final Function(String) onChanged;

  const BuildTextField({Key? key, required this.onChanged, required this.label})
      : super(key: key);

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
    );
  }
}
