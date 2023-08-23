import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/top_stat_card.dart';
import 'package:elogbook/src/presentation/widgets/cards/weekly_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';

class StudentWeeklyGrade extends StatelessWidget {
  const StudentWeeklyGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Grades"),
      ).variant(),
      body: SingleChildScrollView(
        child: SpacingColumn(
          horizontalPadding: 16,
          spacing: 12,
          children: [
            SizedBox(
              height: 16,
            ),
            _buildAttendanceOverview(context),
            TopStatCard(
              title: 'Total Weekly Grades',
              score: 1100,
            ),
            ...[
              WeeklyGradeCard(
                week: 1,
                date: 'Senin, 27 Mar 2023',
                place: 'RS Unhas',
                score: 87,
              ),
              WeeklyGradeCard(
                week: 2,
                date: 'Senin, 4 Jun 2023',
                place: 'Puskesmas',
                score: 50,
              ),
              WeeklyGradeCard(
                week: 3,
                date: 'Senin, 11 Jun 2023',
                place: 'RS Unhas',
                score: 80.7,
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

Container _buildAttendanceOverview(BuildContext context) {
  return Container(
    width: AppSize.getAppWidth(context),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.12),
          offset: Offset(0, 2),
          blurRadius: 20,
        )
      ],
      borderRadius: BorderRadius.circular(12),
      color: scaffoldBackgroundColor,
    ),
    child: Column(
      children: [
        Text(
          'Attendance Overview',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 84,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: errorColor.withOpacity(
                          .2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        AssetPath.getIcon('emoji_alfa.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '1',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text('Tidak Hadir'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 84,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(
                          .2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        AssetPath.getIcon('emoji_hadir.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '1',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text('Hadir'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
