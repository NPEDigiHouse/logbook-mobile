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
          style: textTheme.titleLarge?.copyWith(color: primaryColor),
        ),
        Text(
          unitName,
          style: textTheme.titleSmall?.copyWith(
            color: secondaryTextColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}
