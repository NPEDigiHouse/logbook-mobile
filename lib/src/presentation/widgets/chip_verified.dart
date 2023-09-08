import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class ChipVerified extends StatelessWidget {
  const ChipVerified({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: successColor,
            borderRadius: BorderRadius.circular(80),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified,
                size: 14,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text(
                'Verified',
                style: textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
