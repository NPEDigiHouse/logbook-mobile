import 'package:core/helpers/app_size.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/custom_shimmer.dart';

class ListSkeletonTemplate extends StatelessWidget {
  final List<double> listHeight;
  final double borderRadius;
  final double spacing;
  final EdgeInsets? padding;
  const ListSkeletonTemplate(
      {super.key,
      this.padding,
      this.spacing = 16,
      required this.listHeight,
      this.borderRadius = 12});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomShimmer(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white,
            ),
            width: AppSize.getAppWidth(context),
            height: listHeight[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: spacing,
        );
      },
      itemCount: listHeight.length,
    );
  }
}
