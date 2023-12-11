import 'package:flutter/material.dart';

class SpacingColumn extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double? horizontalPadding;
  final double? spacing;
  final bool onlyPading;

  final List<Widget> children;

  const SpacingColumn({
    Key? key,
    this.spacing,
    required this.children,
    this.horizontalPadding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.onlyPading = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding == null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: horizontalPadding!),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: onlyPading
            ? children
            : [
                for (int i = 0; i < children.length; i++) ...[
                  Column(
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      children[i],
                      if (i < children.length - 1 && !(children[i] is SizedBox))
                        SizedBox(height: spacing),
                    ],
                  ),
                ],
              ],
      ),
    );
  }
}
