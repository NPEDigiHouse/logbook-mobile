import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/personal_behavior/student_personal_behavior_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/student_scientific_assignment_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_test_grade_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/weekly_assesment/student_weekly_assesment_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/widgets/assesment_menu_card.dart';
import 'package:elogbook/src/presentation/features/students/assesment/widgets/final_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class AssesmentHomePage extends StatelessWidget {
  final ActiveUnitModel activeUnitModel;
  final UserCredential credential;

  const AssesmentHomePage(
      {super.key, required this.activeUnitModel, required this.credential});

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
            FinalGradeCard(
              model: activeUnitModel,
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_weekly.svg',
                  title: 'Weekly Grades',
                  onTap: () => context.navigateTo(StudentWeeklyAssementPage()),
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_scientific_assignment.svg',
                  title: 'Scientific Assignment Grade',
                  onTap: () =>
                      context.navigateTo(StudentScientificAssignmentPage(
                    unitName: activeUnitModel.unitName!,
                    isSupervisingDPKExist:
                        credential.student?.supervisingDPKId != null,
                  )),
                ),
              ],
            ),
            Row(
              children: [
                Builder(builder: (context) {
                  print(credential.student?.examinerDPKId);
                  return AssementMenuCard(
                    iconPath: 'icon_test.svg',
                    title: 'Mini Cex',
                    onTap: () => context.navigateTo(StudentTestGrade(
                      unitName: activeUnitModel.unitName!,
                      isExaminerDPKExist:
                          credential.student?.examinerDPKId != null,
                    )),
                  );
                }),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_personal_behavior.svg',
                  title: 'Personal Behavior Grade',
                  onTap: () => context.navigateTo(
                    StudentPersonalBehaviorPage(
                      unitName: activeUnitModel.unitName!,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
