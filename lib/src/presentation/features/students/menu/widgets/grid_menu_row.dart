import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_item.dart';

class GridMenuRow extends StatelessWidget {
  final int length;
  final Color itemColor;
  final List<MenuModel> menus;
  final List<VoidCallback> onTaps;

  const GridMenuRow({
    super.key,
    this.length = 4,
    required this.itemColor,
    required this.menus,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return GridMenuItem(
          color: itemColor,
          menuModel: menus[index],
          onTap: onTaps[index],
        );
      },
      itemCount: length,
    );
  }
}
