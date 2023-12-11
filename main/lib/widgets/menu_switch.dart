import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
          activeColor: const Color(0xFF1C1B1F).withOpacity(.1),
          inactiveColor: const Color(0xFF1C1B1F).withOpacity(.1),
          toggleColor: scaffoldBackgroundColor,
          activeIcon: const Icon(
            Icons.view_list_rounded,
            color: primaryColor,
          ),
          inactiveIcon: const Icon(
            Icons.grid_view_rounded,
            color: primaryColor,
          ),
          onToggle: onToggle,
        ),
      ],
    );
  }
}
