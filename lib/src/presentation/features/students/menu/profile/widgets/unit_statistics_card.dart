import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';

class DepartmentStatisticsCard extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  const DepartmentStatisticsCard({
    super.key,
    this.width = double.infinity,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 16,
            color: Colors.black.withOpacity(.1),
          ),
        ],
      ),
      child: child,
    );
  }
}
