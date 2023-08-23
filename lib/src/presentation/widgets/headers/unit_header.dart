import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class UnitHeader extends StatelessWidget {
  const UnitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
          style: textTheme.titleLarge?.copyWith(color: primaryColor),
        ),
        Text(
          'Obstetrics and Gynecology',
          style: textTheme.titleSmall?.copyWith(
            color: secondaryTextColor,
            height: 1,
          ),
        ),
      ],
    );
  }
}
