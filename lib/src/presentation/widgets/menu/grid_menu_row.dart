import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/clinical_record/create_clinical_record_first_page.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/src/presentation/widgets/menu/grid_menu_item.dart';

class GridMenuRow extends StatelessWidget {
  final int length;
  final MainAxisAlignment mainAxisAlignment;
  final Color itemColor;
  final List<String> iconPaths;
  final List<String> labels;
  final List<VoidCallback> onTaps;

  const GridMenuRow({
    super.key,
    this.length = 4,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.itemColor,
    required this.iconPaths,
    required this.labels,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    final width = AppSize.getAppWidth(context);

    final itemSize = (width / 4) - 22;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<GridMenuItem>.generate(length, (i) {
        return GridMenuItem(
          size: itemSize,
          color: itemColor,
          iconPath: iconPaths[i],
          label: labels[i],
          onTap: i == 0
              ? () => context.navigateTo(CreateClinicalRecordFirstPage())
              : onTaps[i],
        );
      }),
    );
  }
}