import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/grid_menu_item.dart';

class GridMenuRow extends StatelessWidget {
  final int length;
  final Color itemColor;
  final List<String> iconPaths;
  final List<String> labels;
  final List<VoidCallback> onTaps;

  const GridMenuRow({
    super.key,
    this.length = 4,
    required this.itemColor,
    required this.iconPaths,
    required this.labels,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return GridMenuItem(
          color: itemColor,
          iconPath: iconPaths[index],
          label: labels[index],
          onTap: onTaps[index],
        );
      },
      itemCount: length,
    );
  }
}
