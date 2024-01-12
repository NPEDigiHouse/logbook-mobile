import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class DepartmentHeader extends StatelessWidget {
  final String unitName;
  const DepartmentHeader({super.key, required this.unitName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department',
          style: textTheme.bodyLarge?.copyWith(color: primaryTextColor),
        ),
        Text(
          unitName,
          style: textTheme.titleMedium?.copyWith(
            color: primaryColor,
            height: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
