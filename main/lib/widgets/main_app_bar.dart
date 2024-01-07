// ignore_for_file: use_build_context_synchronously

import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainAppBar extends StatelessWidget {
  final bool withLogout;
  const MainAppBar({super.key, this.withLogout = true});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      shadowColor: Colors.transparent,
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
            onPressed: () async {},
            icon: const Icon(
              CupertinoIcons.bell_fill,
              color: primaryColor,
              size: 30,
            ),
            tooltip: 'Keluar',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFE8E4E4),
        ),
      ),
    );
  }
}
