import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalDataTextField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueSetter<String?>? onSaved;
  final TextEditingController controller;
  final bool isDisable;
  final bool isNumberOnly;

  const PersonalDataTextField({
    super.key,
    required this.label,
    required this.value,
    this.isDisable = false,
    this.isNumberOnly = false,
    required this.onSaved,
    required this.controller,
  });

  @override
  State<PersonalDataTextField> createState() => _PersonalDataTextFieldState();
}

class _PersonalDataTextFieldState extends State<PersonalDataTextField> {
  @override
  void initState() {
    widget.controller.text = widget.value ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        inputFormatters: [
          if (widget.isNumberOnly)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        keyboardType:
            widget.isNumberOnly ? TextInputType.number : TextInputType.text,
        readOnly: widget.isDisable,
        onSaved: widget.onSaved,
      ),
    );
  }
}
