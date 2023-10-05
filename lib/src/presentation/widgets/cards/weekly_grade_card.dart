import 'package:dotted_border/dotted_border.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class WeeklyGradeCard extends StatelessWidget {
  final int week;
  // final String date;
  // final String place;
  final int? attendNum;
  final int? startTime;
  final int? endTime;
  final int? notAttendNum;
  final String status;
  final double? score;
  final VoidCallback? onTap;
  final TotalGradeHelper totalGrade;

  const WeeklyGradeCard({
    super.key,
    this.attendNum,
    this.startTime,
    this.endTime,
    this.notAttendNum,
    required this.totalGrade,
    required this.week,
    // required this.date,
    required this.status,
    this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            spreadRadius: 0,
            blurRadius: 6,
            color: const Color(0xFFD4D4D4).withOpacity(.25),
          ),
          BoxShadow(
            offset: const Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
            color: const Color(0xFFD4D4D4).withOpacity(.25),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Week $week',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (status == 'VERIFIED') ...[
                        SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ]
                    ],
                  ),
                  Text(Utils.epochToStringDate(
                      startTime: (startTime ?? 0), endTime: (endTime ?? 0))),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: successColor,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${attendNum ?? 0}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Attend',
                              style: textTheme.labelSmall?.copyWith(
                                color: scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: errorColor,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${notAttendNum ?? 0}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Not Attend',
                              style: textTheme.labelSmall?.copyWith(
                                color: scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (score != null)
              GestureDetector(
                onTap: onTap,
                child: CircularPercentIndicator(
                  radius: 38.0,
                  lineWidth: 5.0,
                  backgroundColor: onDisableColor,
                  animation: true,
                  percent: score! / 100,
                  center: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          totalGrade.gradientScore.color,
                          totalGrade.gradientScore.color.withOpacity(.75),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        score!.toStringAsFixed(0),
                        style: textTheme.titleLarge?.copyWith(
                          color: scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: totalGrade.gradientScore.color,
                ),
              )
            else
              GestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: const Color(0xFF848FA9),
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: scaffoldBackgroundColor,
                    child: DottedBorder(
                      dashPattern: const [3, 2],
                      borderType: BorderType.Circle,
                      borderPadding: const EdgeInsets.all(2),
                      color: const Color(0xFF848FA9),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Color(0xFF848FA9),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
