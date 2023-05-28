import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/clinical_record/create_clinical_record_first_page.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/widgets/menu/list_menu_item.dart';

class ListMenuColumn extends StatelessWidget {
  final int length;
  final Color itemColor;
  final List<String> iconPaths;
  final List<String> labels;
  final List<String> descriptions;
  final List<VoidCallback> onTaps;

  const ListMenuColumn({
    super.key,
    this.length = 4,
    required this.itemColor,
    required this.iconPaths,
    required this.labels,
    required this.descriptions,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListMenuItem(
          color: itemColor,
          iconPath: iconPaths[index],
          label: labels[index],
          description: descriptions[index],
          onTap: index != 0
              ? onTaps[index]
              : () => context.navigateTo(CreateClinicalRecordFirstPage()),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        );
      },
      itemCount: length,
    );
  }
}
