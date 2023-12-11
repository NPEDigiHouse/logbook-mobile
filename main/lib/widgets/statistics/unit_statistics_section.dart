import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DepartmentStatisticsSection extends StatelessWidget {
  final String titleText;
  final String titleIconPath;
  final GlobalKey repaintKey;
  final double percentage;
  final Map<String, int?> statistics;
  final Map<int, List<String>> detailStatistics;

  const DepartmentStatisticsSection({
    super.key,
    required this.titleText,
    required this.repaintKey,
    required this.titleIconPath,
    required this.percentage,
    required this.statistics,
    required this.detailStatistics,
  });

  @override
  Widget build(BuildContext context) {
    final labels = statistics.keys.toList();
    final values = statistics.values.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(
                AssetPath.getIcon('skill_outlined.svg'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titleText,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              RepaintBoundary(
                key: repaintKey,
                child: CircularPercentIndicator(
                  percent: percentage / 100,
                  radius: 56,
                  lineWidth: 12,
                  animation: true,
                  reverse: true,
                  animationDuration: 750,
                  center: Countup(
                    begin: 0,
                    end: percentage,
                    suffix: '%',
                    duration: const Duration(milliseconds: 750),
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  progressColor: primaryColor,
                  backgroundColor: const Color(0xFFCED8EE),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildStatisticField(
                      label: labels[0],
                      value: values[0],
                      valueTextColor: primaryTextColor,
                    ),
                    const SizedBox(height: 8),
                    buildStatisticField(
                      label: labels[1],
                      value: values[1],
                      valueTextColor: primaryColor,
                    ),
                    const SizedBox(height: 8),
                    buildStatisticField(
                      label: labels[2],
                      value: values[2],
                      valueTextColor: const Color(0xFF7D99D9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 24,
              bottom: 16,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEFF0F9),
            ),
          ),
          buildStatisticDetailField(),
        ],
      ),
    );
  }

  Column buildStatisticField({
    required String label,
    required int? value,
    required Color valueTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Text>[
        Text(
          '${value ?? 0}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueTextColor,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Column buildStatisticDetailField() {
    final keys = detailStatistics.keys.toList();
    final values = detailStatistics.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Column>[
        for (var i = 0; i < keys.length; i++) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   'Level ${keys[i]}',
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w600,
              //     color: primaryColor,
              //   ),
              // ),
              for (var j = 0; j < values[i].length; j++) ...[
                Text(
                  '${j + 1}. ${values[i][j]}',
                  style: textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ],
      ],
    );
  }
}
