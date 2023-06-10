import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  final bool isVertical;
  const SectionDivider({super.key, this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isVertical ? 3 : double.infinity,
      height: isVertical ? double.infinity : 6,
      decoration: BoxDecoration(
        borderRadius: isVertical ? BorderRadius.circular(24) : null,
        color: Color(0xFFF3F4F6),
      ),
    );
  }
}
