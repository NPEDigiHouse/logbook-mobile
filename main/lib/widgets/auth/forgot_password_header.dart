import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () => context.back(),
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      actions: const [
        SizedBox(
          width: 56,
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetPath.getIcon('logo.svg'),
            color: primaryTextColor,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            "E-Logbook",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: textTheme.titleMedium?.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
