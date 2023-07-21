import 'package:flutter/material.dart';

class PersonalDataTextField extends StatefulWidget {
  final String label;
  final String value;

  const PersonalDataTextField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  State<PersonalDataTextField> createState() => _PersonalDataTextFieldState();
}

class _PersonalDataTextFieldState extends State<PersonalDataTextField> {
  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}
