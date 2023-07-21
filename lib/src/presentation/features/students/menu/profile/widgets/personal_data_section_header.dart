import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class PersonalDataSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const PersonalDataSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: onDisableColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
