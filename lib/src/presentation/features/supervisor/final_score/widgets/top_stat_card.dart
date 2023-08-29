import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/clip_donut_painter.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class FinalGradeTopStatCard extends StatelessWidget {
  final String title;
  final TotalGradeHelper? totalGrade;
  const FinalGradeTopStatCard({
    super.key,
    required this.totalGrade,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              bottom: 0,
              left: 8,
              child: CustomPaint(
                size: Size(
                    80,
                    (80 * 1.17)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: ClipDonutPainter(),
              ),
            ),
            Column(
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
                  progress: totalGrade != null ? totalGrade!.value / 100 : 0,
                  strokeCap: StrokeCap.round,
                  color: totalGrade != null
                      ? totalGrade!.gradientScore.color
                      : onDisableColor,
                  bottomPadding: 0,
                  backgroundColor: Color(0xFFB0EAFC),
                  child: Column(
                    children: [
                      Text(
                        totalGrade != null
                            ? totalGrade!.gradientScore.title
                            : 'Unknown',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalGrade != null
                            ? 'Avg : ${(totalGrade!.value).toInt().toString()}'
                            : '-',
                        style: textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
