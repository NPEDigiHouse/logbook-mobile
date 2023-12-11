import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/spacing_column.dart';

import 'widgets/title_assesment_card.dart';
import 'widgets/top_stat_card.dart';

class StudentScientificAssessmentGrade extends StatelessWidget {
  const StudentScientificAssessmentGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Assignment Grade"),
      ).variant(),
      body: const SingleChildScrollView(
        child: SpacingColumn(
          horizontalPadding: 16,
          spacing: 12,
          children: [
            SizedBox(
              height: 16,
            ),
            TitleAssesmentCard(
              title: "Scientific Assignment Grade",
              subtitle: 's',
            ),
            TopStatCard(
              title: 'Scientific Assignment Statistic',
              score: 1100,
            ),
            ...[
              ScientificGradeCard(
                title: 'Presentation',
                iconPath: 'assets/icons/presentation_icon.svg',
              ),
              ScientificGradeCard(
                title: 'Presentation Style',
                iconPath: 'assets/icons/presentation_style_icon.svg',
              ),
              ScientificGradeCard(
                title: 'Presentation',
                iconPath: 'assets/icons/discussion_icon.svg',
              ),
            ],
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ScientificGradeCard extends StatelessWidget {
  const ScientificGradeCard({
    super.key,
    required this.title,
    required this.iconPath,
  });

  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      // padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(iconPath),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const SectionDivider(),
          SpacingColumn(
            horizontalPadding: 16,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                    ),
                    const Expanded(child: Text('Systematics of Arrangement')),
                    Text(
                      '90',
                      style: textTheme.bodyMedium?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const ItemDivider(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                    ),
                    const Expanded(child: Text('Systematics of Arrangement')),
                    Text(
                      '90',
                      style: textTheme.bodyMedium?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const ItemDivider(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                    ),
                    const Expanded(child: Text('Systematics of Arrangement')),
                    Text(
                      '90',
                      style: textTheme.bodyMedium?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
