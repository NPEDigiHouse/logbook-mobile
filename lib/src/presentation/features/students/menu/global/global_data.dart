import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/students/professional_activity/create_professional_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/thesis/add_thesis_page.dart';
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

final List<Widget> pages = [
  const CreateProfessionalActivityPage(),
  const AddThesisPage(),
];

final List<String> descriptions = List.generate(4, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

List<VoidCallback> onTaps(BuildContext context) {
  return pages.map((e) => () => context.navigateTo(e)).toList();
}
