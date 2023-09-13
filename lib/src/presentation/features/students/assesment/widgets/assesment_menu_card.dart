import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssementMenuCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final String desc;
  const AssementMenuCard({
    super.key,
    required this.desc,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWellContainer(
        onTap: onTap,
        radius: 12,
        padding: EdgeInsets.all(20),
        color: scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 24,
            color: Color(0xFF374151).withOpacity(.15),
          )
        ],
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: SvgPicture.asset(
                  AssetPath.getIcon(
                    iconPath,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                maxLines: 2,
                style: textTheme.bodyMedium?.copyWith(
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                desc,
                maxLines: 2,
                style: textTheme.bodySmall?.copyWith(
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
