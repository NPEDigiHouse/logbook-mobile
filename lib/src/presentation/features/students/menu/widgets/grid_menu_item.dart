import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/styles/text_style.dart';

class GridMenuItem extends StatelessWidget {
  final Color color;
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const GridMenuItem({
    super.key,
    required this.color,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              child: InkWell(
                onTap: onTap,
                child: Ink(
                  width: 68,
                  height: 68,
                  color: color.withOpacity(.1),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      color: color,
                      width: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
