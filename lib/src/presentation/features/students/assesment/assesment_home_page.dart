import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/student_personal_behavior_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/student_scientific_assesment_grade_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_test_grade_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/student_weekly_grade_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/widgets/assesment_menu_card.dart';
import 'package:elogbook/src/presentation/features/students/assesment/widgets/final_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class AssesmentHomePage extends StatelessWidget {
  final ActiveUnitModel activeUnitModel;

  const AssesmentHomePage({super.key, required this.activeUnitModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assesment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SpacingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          horizontalPadding: 16,
          spacing: 12,
          children: [
            UnitHeader(
              unitName: activeUnitModel.unitName!,
            ),
            SizedBox(
              height: 12,
            ),
            FinalGradeCard(),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_weekly.svg',
                  title: 'Weekly Grades',
                  onTap: () => context.navigateTo(StudentWeeklyGrade()),
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_scientific_assignment.svg',
                  title: 'Scientific Assignment Grade',
                  onTap: () =>
                      context.navigateTo(StudentScientificAssessmentGrade()),
                ),
              ],
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_test.svg',
                  title: 'Mini Cex',
                  onTap: () => context.navigateTo(StudentTestGrade(
                    unitName: activeUnitModel.unitName!,
                  )),
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_personal_behavior.svg',
                  title: 'Personal Behavior Grade',
                  onTap: () =>
                      context.navigateTo(StudentPersonalBehaviorGrade()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
