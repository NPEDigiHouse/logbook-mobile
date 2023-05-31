import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class MenuSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggle;

  const MenuSwitch({
    super.key,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Menu',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        FlutterSwitch(
          value: value,
          width: 48,
          height: 32,
          activeColor: Color(0xFF1C1B1F).withOpacity(.1),
          inactiveColor: Color(0xFF1C1B1F).withOpacity(.1),
          toggleColor: scaffoldBackgroundColor,
          activeIcon: Icon(
            Icons.view_list_rounded,
            color: primaryColor,
          ),
          inactiveIcon: Icon(
            Icons.grid_view_rounded,
            color: primaryColor,
          ),
          onToggle: onToggle,
        ),
      ],
    );
  }
}
