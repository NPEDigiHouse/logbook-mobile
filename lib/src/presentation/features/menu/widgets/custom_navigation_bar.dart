import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/src/presentation/features/menu/widgets/nav_item.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final int val;

  const CustomNavigationBar({super.key, required this.selectedIndex, required this.val});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEFF0F9),
      height: 80,
      width: AppSize.getAppWidth(context),
      child: Builder(builder: (context) {
        List<String> listIconPath = [
          "icon_unit.svg",
          "icon_globe.svg",
          "icon_history.svg",
          "icon_user.svg"
        ];
        List<String> listTitle = [
          "Unit\nActivity",
          "Global Activity",
          "History",
          "Profile"
        ];
        return Row(
          children: [
            for (int i = 0; i < listTitle.length; i++)
              NavItem(
                iconPath: listIconPath[i],
                label: listTitle[i],
                onTap: () {
                  selectedIndex.value = i;
                },
                isActive: val == i,
              ),
          ],
        );
      }),
    );
  }
}
