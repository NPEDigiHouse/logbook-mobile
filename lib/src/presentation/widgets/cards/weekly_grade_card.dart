import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class WeeklyGradeCard extends StatelessWidget {
  final int week;
  final String date;
  final String place;
  final double? score;
  final VoidCallback? onTap;

  const WeeklyGradeCard({
    super.key,
    required this.week,
    required this.date,
    required this.place,
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
                  Text(
                    'Week $week',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: textTheme.titleMedium?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  Text(
                    place,
                    style: textTheme.titleMedium?.copyWith(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                  backgroundColor: const Color(0xFFADDAE7),
                  animation: true,
                  percent: score! / 100,
                  center: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF2489B4),
                          Color(0xFF29C5F6),
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
                  progressColor: primaryColor,
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
