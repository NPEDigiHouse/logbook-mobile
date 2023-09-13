import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';

class ProfileItemMenuCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const ProfileItemMenuCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      color: scaffoldBackgroundColor,
      radius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 4, 6, 4),
      border: Border.all(
        width: 1,
        color: onFormDisableColor.withOpacity(.5),
      ),
      // boxShadow: <BoxShadow>[
      //   BoxShadow(
      //     offset: const Offset(0, 1),
      //     blurRadius: 8,
      //     color: Colors.black.withOpacity(.1),
      //   ),
      // ],
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE1F8FF),
            ),
            child: SvgPicture.asset(
              AssetPath.getIcon(
                iconPath,
              ),
              color: secondaryColor,
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class ProfileItemMenuCardVariant extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const ProfileItemMenuCardVariant({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      color: scaffoldBackgroundColor,
      radius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 16, 6, 16),
      border: Border.all(
        width: 1,
        color: errorColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: errorColor),
          ),
        ],
      ),
    );
  }
}

class ProfileItemMenuCardVariant2 extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const ProfileItemMenuCardVariant2({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      color: errorColor,
      radius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(12, 16, 6, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            AssetPath.getIcon(
              iconPath,
            ),
            color: Colors.white,
            width: 16,
            height: 16,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            title,
            style: textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
