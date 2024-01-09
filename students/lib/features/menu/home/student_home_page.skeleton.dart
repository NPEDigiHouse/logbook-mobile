import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/custom_shimmer.dart';

class StudentHomePageSkeleton extends StatelessWidget {
  const StudentHomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              width: AppSize.getAppWidth(context),
              height: 130,
            ),
          ),
          const SizedBox(height: 32),
          CustomShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              width: AppSize.getAppWidth(context),
              height: 56,
            ),
          ),
          const SizedBox(height: 12),
          CustomShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              width: AppSize.getAppWidth(context),
              height: 56,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Menu',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Row(
                  children: [
                    Expanded(child: cardShimmer()),
                    if (index != 3)
                      const SizedBox(
                        width: 8,
                      )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Row(
                  children: [
                    Expanded(child: cardShimmer()),
                    if (index != 3)
                      const SizedBox(
                        width: 8,
                      )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Row(
                  children: [
                    Expanded(child: cardShimmer()),
                    if (index != 3)
                      const SizedBox(
                        width: 8,
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardShimmer() {
    return CustomShimmer(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            height: 56,
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            height: 10,
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            height: 10,
          ),
        ],
      ),
    );
  }
}
