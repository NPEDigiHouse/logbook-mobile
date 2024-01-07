import 'package:core/helpers/app_size.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/custom_shimmer.dart';

class ListSglCstPageSkeleton extends StatelessWidget {
  const ListSglCstPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> height = [90, 140, 100, 80, 180];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomShimmer(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            width: AppSize.getAppWidth(context),
            height: height[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 16,
        );
      },
      itemCount: height.length,
    );
  }
}
