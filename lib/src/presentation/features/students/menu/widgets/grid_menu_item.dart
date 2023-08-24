import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/styles/text_style.dart';

class GridMenuItem extends StatelessWidget {
  final Color color;
  final MenuModel menuModel;
  final VoidCallback onTap;

  const GridMenuItem({
    super.key,
    required this.color,
    required this.menuModel,
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
                      AssetPath.getIcon(menuModel.iconPath),
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
                menuModel.labels,
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
