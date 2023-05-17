import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthHeader extends StatelessWidget {
  final double height;
  const AuthHeader({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          child: FittedBox(
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
            child: Image.asset(
              AssetPath.getImage('bg_image.png'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: backgroundColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetPath.getVector('logo.svg')),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "E-Logbook",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 2,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryTextColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Image.asset(AssetPath.getImage("logo_umi.png"))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
