import 'package:elogbook/src/data/datasources/local_datasources/static_datasource.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/list_menu_item.dart';

class ListMenuColumn extends StatelessWidget {
  final int length;
  final Color itemColor;
  final List<MenuModel> menus;

  final List<VoidCallback> onTaps;

  const ListMenuColumn({
    super.key,
    this.length = 4,
    required this.itemColor,
    required this.menus,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListMenuItem(
          color: itemColor,
          menuModel: menus[index],
          onTap: onTaps[index],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 30,
          thickness: 1,
          color: Color(0xFFEFF0F9),
        );
      },
      itemCount: length,
    );
  }
}
