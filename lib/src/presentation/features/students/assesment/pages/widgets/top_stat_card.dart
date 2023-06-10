import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class TopStatCard extends StatelessWidget {
  final String title;
  final int score;
  const TopStatCard({
    super.key,
    required this.score,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SectionDivider(),
          SizedBox(
            height: 12,
          ),
          SemicircularIndicator(
            contain: true,
            radius: 100,
            strokeCap: StrokeCap.round,
            color: primaryColor,
            bottomPadding: 0,
            backgroundColor: Color(0xFFB0EAFC),
            child: Column(
              children: [
                Text(score.toString(),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  'Very Good',
                  style: textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
