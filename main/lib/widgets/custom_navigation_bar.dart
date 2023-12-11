import 'package:core/helpers/app_size.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/nav_item.dart';

class CustomNavigationBar extends StatelessWidget {
  final int value;
  final ValueNotifier<int> selectedIndex;
  final List<String> listIconPath;
  final List<String> listTitle;

  const CustomNavigationBar({
    super.key,
    required this.value,
    required this.listIconPath,
    required this.listTitle,
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
