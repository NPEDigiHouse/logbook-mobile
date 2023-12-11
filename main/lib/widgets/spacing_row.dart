import 'package:flutter/material.dart';

class SpacingRow extends StatelessWidget {
  final List<Widget> children;
  final double? horizontalPadding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool onlyPading;
  final double spacing;
  const SpacingRow({
    super.key,
    this.horizontalPadding,
    required this.children,
    required this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.onlyPading = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding == null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: horizontalPadding!),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: onlyPading
            ? children
            : [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1 && !(children[i] is SizedBox))
                    SizedBox(width: spacing),
                ],
              ],
      ),
    );
  }
}
