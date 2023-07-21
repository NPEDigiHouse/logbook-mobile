import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class PersonalDataField extends StatelessWidget {
  final String label;
  final String value;

  const PersonalDataField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(value),
      ],
    );
  }
}
