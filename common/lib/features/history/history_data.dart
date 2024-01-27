import 'package:common/features/history/cst/cst_history_detail.dart';
import 'package:common/features/history/sgl/sgl_history_detail.dart';
import 'package:coordinator/features/weekly_grade/weekly_grade_detail_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:data/models/history/history_model.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:students/features/assesment/pages/final_score/student_final_score_page.dart';
import 'package:students/features/assesment/pages/mini_cex/student_test_grade_page.dart';
import 'package:students/features/assesment/pages/personal_behavior/student_personal_behavior_page.dart';
import 'package:students/features/assesment/pages/scientific_assigment/student_scientific_assignment_page.dart';
import 'package:students/features/assesment/pages/weekly_assesment/student_weekly_assesment_page.dart';
import 'package:students/features/competences/list_cases_page.dart';
import 'package:students/features/competences/list_skills_page.dart';
import 'package:students/features/scientific_session/detail_scientific_session_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_mini_cex_detail_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_personal_behavior_detail_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_scientific_assignment_detail_page.dart';
import 'package:supervisor/features/clinical_record/supervisor_detail_clinical_record_page.dart';
import 'package:supervisor/features/competence/pages/list_cases_page.dart';
import 'package:supervisor/features/competence/pages/list_skills_page.dart';
import 'package:supervisor/features/daily_activity/supervisor_daily_activity_detail_page.dart';
import 'package:supervisor/features/final_score/supervisor_final_grade_page.dart';
import 'package:supervisor/features/self_reflection/self_reflection_student_page.dart';
import 'package:supervisor/features/special_report/special_report_home_page.dart';

class Activity {
  final String title;
  final String? supervisorId;
  final String iconPath;
  final DateTime? date;
  final String studentId;
  final String studentName;
  final String? patientName;
  final String? dateTime;
  final String id;
  final VoidCallback onTap;
  Activity(
      {required this.title,
      this.supervisorId,
      required this.iconPath,
      required this.date,
      required this.onTap,
      required this.id,
      this.patientName,
      required this.dateTime,
      required this.studentId,
      required this.studentName});
}

enum RoleHistory { student, supervisor }

class HistoryData {
  final String name;
  final VoidCallback onTap;
  final String pathIcon;

  HistoryData({
    required this.name,
    required this.onTap,
    required this.pathIcon,
  });
}

class HistoryHelper {
  static List<Activity> convertHistoryToActivity(
    List<HistoryModel> history,
    RoleHistory roleHistory,
    BuildContext context, {
    bool isCeu = false,
    String? supervisorId,
    bool isCoordinator = false,
    bool onlyInOut = false,
    bool isHeadDiv = false,
    List<String>? unitIds,
    bool isStudent = false,
  }) {
    List<Activity> activityList = [];
    for (var element in history) {
      if (onlyInOut) {
        if (element.type != 'Check-in' && element.type != 'Check-out') {
          continue;
        }
      }
      DateTime? date;
      if (element.timestamp != null) {
        date = DateTime.fromMillisecondsSinceEpoch(element.timestamp! * 1000);
      }

      Map<String, HistoryData> types = {
        'SGL': HistoryData(
            name: 'SGL',
            onTap: () => context.navigateTo(HistorySglPage(
                  id: element.attachment ?? '',
                )),
            pathIcon: 'diversity_3_rounded.svg'),
        'CST': HistoryData(
            name: 'CST',
            onTap: () => context.navigateTo(HistoryCstPage(
                  id: element.attachment ?? '',
                )),
            pathIcon: 'medical_information_rounded.svg'),
        'Clinical Record': HistoryData(
            name: 'Clinical Record',
            onTap: () {
              context.navigateTo(
                SupervisorDetailClinicalRecordPage(
                  id: element.attachment ?? '',
                ),
              );
            },
            pathIcon: 'clinical_notes_rounded.svg'),
        'Scientific Session': HistoryData(
            name: 'Scientific Session',
            onTap: () => context.navigateTo(
                  DetailScientificSessionPage(
                    id: element.attachment ?? '',
                  ),
                ),
            pathIcon: 'biotech_rounded.svg'),
        'Self-Reflection': HistoryData(
            name: 'Self Reflection',
            onTap: isStudent
                ? () {}
                : () => context.navigateTo(SupervisorSelfReflectionStudentPage(
                      studentId: element.studentId ?? '',
                    )),
            pathIcon: 'emoji_objects_rounded.svg'),
        'CASE': HistoryData(
            name: 'CASE',
            onTap: () => isStudent
                ? context.navigateTo(ListCasesPage(
                    unitName: element.unitName ?? '',
                    unitId: element.unitId ?? '',
          
                  ))
                : context.navigateTo(SupervisorListCasesPage(
                    studentName: element.studentName ?? '',
                    unitName: element.unitName ?? '',
                    studentId: element.studentId ?? '')),
            pathIcon: 'case_icon.svg'),
        'SKILL': HistoryData(
            name: 'SKILL',
            onTap: () => isStudent
                ? context.navigateTo(ListSkillsPage(
                    unitName: element.unitName ?? '',
                    unitId: element.unitId ?? '',
            
                  ))
                : context.navigateTo(SupervisorListSkillsPage(
                    studentName: element.studentName ?? '',
                    unitName: element.unitName ?? '',
                    studentId: element.studentId ?? '')),
            pathIcon: 'skill_icon.svg'),
        'MINI_CEX': HistoryData(
            name: 'Mini Cex',
            onTap: () => isStudent
                ? context.navigateTo(StudentTestGrade(
                    unitName: element.unitName ?? '',
                    isExaminerDPKExist: true,
                  ))
                : context.navigateTo(SupervisorMiniCexDetailPage(
                    unitName: element.unitName ?? '',
                    supervisorId: element.supervisorId ?? '',
                    id: element.attachment ?? '')),
            pathIcon: 'icon_test.svg'),
        'PERSONAL_BEHAVIOUR': HistoryData(
            name: 'Personal Behavior',
            onTap: () => isStudent
                ? context.navigateTo(StudentPersonalBehaviorPage(
                    unitName: element.unitName ?? ''))
                : context.navigateTo(SupervisorPersonalBehaviorDetailPage(
                    unitName: element.unitName ?? '',
                    id: element.attachment ?? '')),
            pathIcon: 'icon_personal_behavior.svg'),
        'SCIENTIFIC_ASSESMENT': HistoryData(
            name: 'Scientific Assesment',
            onTap: () => isStudent
                ? context.navigateTo(StudentScientificAssignmentPage(
                    isSupervisingDPKExist: true,
                    unitName: element.unitName ?? ''))
                : context.navigateTo(SupervisorScientificAssignmentDetailPage(
                    unitName: element.unitName ?? '',
                    id: element.attachment ?? '',
                    supervisorId: element.supervisorId ?? '',
                  )),
            pathIcon: 'icon_scientific_assignment.svg'),
        'Problem Consultation': HistoryData(
            name: 'Problem Consultation',
            onTap: isStudent
                ? () {}
                : () => context.navigateTo(SpecialReportDetailPage(
                      studentId: element.studentId ?? '',
                    )),
            pathIcon: 'consultation_icon.svg'),
        'Check-in': HistoryData(
            name: 'CHECK-IN',
            onTap: () {},
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'Check-out': HistoryData(
            name: 'CHECK-OUT',
            onTap: () {},
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'CEU_SKILL': HistoryData(
            name: 'Completed Skills',
            onTap: () {},
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'CEU_CASE': HistoryData(
            name: 'Completed Cases',
            onTap: () {},
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'Assesment': HistoryData(
            name: 'Final Score',
            onTap: isStudent
                ? () => context.navigateTo(StudentFinalScorePage(
                    departmentName: element.unitName ?? ''))
                : () => context.navigateTo(SupervisorFinalGrade(
                      departmentId: element.unitId ?? '',
                      departmentName: element.unitName ?? '',
                      studentId: element.studentId ?? '',
                      studentName: element.studentName ?? '',
                    )),
            pathIcon: 'feed_rounded.svg'),
        'DAILY_ACTIVITY': HistoryData(
            name: 'Daily Activity',
            onTap: () => context.navigateTo(SupervisorDailyActivityDetailPage(
                  id: element.attachment ?? '',
                  isHistory: true,
                )),
            pathIcon: 'summarize_rounded.svg'),
        'WEEKLY_ASSESMENT': HistoryData(
            name: 'Weekly Assesment',
            onTap: isStudent
                ? () => context.navigateTo(const StudentWeeklyAssementPage())
                : () => context.navigateTo(WeeklyGradeDetailPage(
                      student: StudentDepartmentModel(
                        studentId: element.studentId,
                        studentName: element.studentName,
                        activeDepartmentId: element.unitId,
                        activeDepartmentName: element.unitName,
                      ),
                    )),
            pathIcon: 'icon_weekly.svg'),
      };

      activityList.add(Activity(
        onTap: types[element.type]!.onTap,
        dateTime: Utils.datetimeToString(date!, isShowTime: true),
        date: DateTime(date.year, date.month, date.day, date.hour),
        title: types[element.type]!.name,
        iconPath: AssetPath.getIcon(types[element.type]!.pathIcon),
        supervisorId: element.supervisorName,
        studentId: element.studentId ?? '',
        id: element.studentId ?? '',
        studentName: element.studentName ?? '',
      ));
    }
    return activityList;
  }
}
