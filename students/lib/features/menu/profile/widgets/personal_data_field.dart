import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class PersonalDataField extends StatelessWidget {
  final String label;
  final String? value;

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
        const SizedBox(height: 4),
        Text(value ?? 'none'),
      ],
    );
  }
}
