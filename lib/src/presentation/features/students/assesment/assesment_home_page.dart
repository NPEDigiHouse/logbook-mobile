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
  final ActiveDepartmentModel activeDepartmentModel;
  final UserCredential credential;

  const AssesmentHomePage(
      {super.key,
      required this.activeDepartmentModel,
      required this.credential});

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
            DepartmentHeader(
              unitName: activeDepartmentModel.unitName!,
            ),
            SizedBox(
              height: 12,
            ),
            FinalGradeCard(
              model: activeDepartmentModel,
            ),
            Row(
              children: [
                AssementMenuCard(
                  iconPath: 'icon_weekly.svg',
                  title: 'Weekly Grades',
                  onTap: () => context.navigateTo(StudentWeeklyAssementPage()),
                  desc: 'Weekly assessment from kordik team',
                ),
                SizedBox(
                  width: 12,
                ),
                AssementMenuCard(
                  iconPath: 'icon_scientific_assignment.svg',
                  title: 'Scientific Assignment Grade',
                  onTap: () =>
                      context.navigateTo(StudentScientificAssignmentPage(
                    unitName: activeDepartmentModel.unitName!,
                    isSupervisingDPKExist:
                        credential.student?.supervisingDPKId != null,
                  )),
                  desc: 'Scientific assessment data',
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
                      unitName: activeDepartmentModel.unitName!,
                      isExaminerDPKExist:
                          credential.student?.examinerDPKId != null,
                    )),
                    desc: 'Mini Clinical Evaluation Exercise',
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
                      unitName: activeDepartmentModel.unitName!,
                    ),
                  ),
                  desc: 'Assessment given to personal behavior or behavior',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
