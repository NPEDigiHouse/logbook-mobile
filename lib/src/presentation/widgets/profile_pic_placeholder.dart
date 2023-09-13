import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';

class ProfilePicPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final String name;
  final bool isSmall;
  const ProfilePicPlaceholder(
      {super.key,
      required this.height,
      required this.name,
      this.isSmall = false,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: secondaryColor,
        border: Border.all(
            width: 2,
            color: scaffoldBackgroundColor,
            strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isSmall ? 30 : 61,
          ),
        ),
      ),
    );
  }
}
