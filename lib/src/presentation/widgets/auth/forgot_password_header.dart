import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordHeader extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () => context.back(),
        icon: Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      actions: [
        SizedBox(
          width: 56,
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetPath.getVector('logo.svg')),
          SizedBox(
            width: 8,
          ),
          Text(
            "E-Logbook",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: textTheme.titleSmall?.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
