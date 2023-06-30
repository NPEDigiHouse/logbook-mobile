import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';

final List<Color> colors = [
  // primaryColor,
  variant2Color,
  variant1Color,
  // errorColor,
];

final List<String> iconPaths = [
  // AssetPath.getIcon('biotech_rounded.svg'),
  AssetPath.getIcon('health_metrics_rounded.svg'),
  AssetPath.getIcon('menu_book_rounded.svg'),
  // AssetPath.getIcon('flag_rounded.svg'),
];

final List<String> labels = [
  // 'Scientific Session',
  'Professional Activity',
  'Thesis',
  // 'Self reflection',
];

final List<String> descriptions = List.generate(4, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

final List<VoidCallback> onTaps = List.generate(4, (_) => () {});
