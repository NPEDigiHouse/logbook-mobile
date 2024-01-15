import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';

class ChipVerified extends StatelessWidget {
  final bool isVerified;
  const ChipVerified({
    super.key,
    this.isVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isVerified ? successColor : secondaryTextColor,
            borderRadius: BorderRadius.circular(80),
          ),
          child: Row(
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.hourglass_top_rounded,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                isVerified ? 'Verified' : 'Unverfied',
                style: textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
