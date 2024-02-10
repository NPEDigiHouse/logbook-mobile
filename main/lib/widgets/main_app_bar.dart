// ignore_for_file: use_build_context_synchronously

import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainAppBar extends StatelessWidget {
  final bool withLogout;
  final VoidCallback? onTap;
  final Widget? notifIcon;
  const MainAppBar(
      {super.key, this.withLogout = true, this.onTap, this.notifIcon});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetPath.getIcon('logo.svg'),
                  color: primaryTextColor,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text('E-Logbook'),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: primaryTextColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      leadingWidth: 56,
      actions: (notifIcon != null) ? <Widget>[notifIcon!] : null,
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

class MainTitleAppBar extends StatelessWidget {
  final List<Widget>? widget;
  final String title;
  final bool isPin;
  const MainTitleAppBar(
      {super.key, this.widget, required this.title, this.isPin = false});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: isPin ? true : false,
      elevation: 0,
      floating: isPin ? false : true,
      snap: false,
      shadowColor: Colors.transparent,
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: scaffoldBackgroundColor,
      title: Text(title),
      centerTitle: false,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      actions: (widget != null) ? widget! : null,
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
