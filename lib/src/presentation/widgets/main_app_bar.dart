import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      title: const Text('E-Logbook'),
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SvgPicture.asset(
          AssetPath.getVector('logo.svg'),
        ),
      ),
      leadingWidth: 56,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () => context.back(),
            icon: Icon(
              Icons.logout_rounded,
              color: primaryColor,
              size: 30,
            ),
            tooltip: 'Keluar',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Color(0xFFE8E4E4),
        ),
      ),
    );
  }
}
