import 'package:flutter/material.dart';

class InkWellContainer extends StatelessWidget {
  final double radius;
  final Color? color;
  final BoxBorder? border;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final Widget? child;

  const InkWellContainer({
    super.key,
    this.radius = 0,
    this.color,
    this.border,
    this.margin,
    this.padding,
    this.boxShadow,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        border: border,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
