import 'package:flutter/material.dart';

class PersonalDataTextField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueSetter<String?>? onSaved;

  const PersonalDataTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onSaved,
  });

  @override
  State<PersonalDataTextField> createState() => _PersonalDataTextFieldState();
}

class _PersonalDataTextFieldState extends State<PersonalDataTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
        onSaved: widget.onSaved,
      ),
    );
  }
}
