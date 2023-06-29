import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/nav_item.dart';

class CustomNavigationBar extends StatelessWidget {
  final int value;
  final ValueNotifier<int> selectedIndex;

  const CustomNavigationBar({
    super.key,
    required this.value,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF0F9),
      height: 80,
      width: AppSize.getAppWidth(context),
      child: Builder(
        builder: (context) {
          List<String> listIconPath = [
            "icon_unit.svg",
            "icon_globe.svg",
            "icon_history.svg",
            "icon_user.svg"
          ];

          List<String> listTitle = [
            "Unit\nActivity",
            "Global\nActivity",
            "History",
            "Profile"
          ];

          return Row(
            children: <Widget>[
              for (int i = 0; i < listTitle.length; i++)
                NavItem(
                  iconPath: listIconPath[i],
                  label: listTitle[i],
                  onTap: () => selectedIndex.value = i,
                  isActive: value == i,
                ),
            ],
          );
        },
      ),
    );
  }
}
