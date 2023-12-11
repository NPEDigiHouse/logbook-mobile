import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class DepartmentStatisticsField extends StatelessWidget {
  final String label;
  final String? value;

  const DepartmentStatisticsField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'none',
            style: textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
