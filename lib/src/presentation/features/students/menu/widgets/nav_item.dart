import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const NavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isActive
                    ? Color(0xFF29C5F6).withOpacity(.21)
                    : Colors.transparent,
              ),
              child: SvgPicture.asset(
                AssetPath.getIcon(iconPath),
                color: isActive ? primaryTextColor : secondaryTextColor,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 30),
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                    height: 1,
                    color: isActive ? primaryTextColor : secondaryTextColor),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
