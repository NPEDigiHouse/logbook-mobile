import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/datasources/local_datasources/static_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/widgets/inkwell_container.dart';

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
    if (AppSize.getAppWidth(context) >= 800) {
      return InkWellContainer(
        onTap: onTap,
        color: color.withOpacity(.1),
        radius: 12,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetPath.getIcon(menuModel.iconPath),
              color: color,
              width: 48,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              menuModel.labels,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
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
