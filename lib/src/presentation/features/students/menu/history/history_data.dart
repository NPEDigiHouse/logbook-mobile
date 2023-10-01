import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/data/models/history/history_model.dart';
import 'package:elogbook/src/presentation/features/common/history/cst/cst_history_detail.dart';
import 'package:elogbook/src/presentation/features/common/history/sgl/sgl_history_detail.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_mini_cex_detail.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/mini_cex/student_test_grade_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/personal_behavior/student_personal_behavior_page.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/scientific_assigment/student_scientific_assignment_page.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/detail_scientific_session_page.dart';

import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_mini_cex_detail_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_personal_behavior_detail_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_scientific_assignment_detail_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/supervisor_detail_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/list_cases_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/competence/pages/list_skills_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_detail_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/supervisor_final_grade_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_student_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/special_report/special_report_home_page.dart';
import 'package:flutter/material.dart';

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
      if (isCoordinator) {
        if (element.type != 'Weekly Assesemnt') {
          continue;
        }
      }

      if (onlyInOut) {
        if (element.type != 'Check-in' && element.type != 'Check-out') {
          continue;
        }
      }

      // if (isCeu && element.supervisorId != supervisorId) {
      //   if (element.type != 'SGL' &&
      //       element.type != 'CST' &&
      //       element.type != 'Assesment') {
      //     continue;
      //   }
      // }

      if (!((isHeadDiv &&
              (unitIds ?? ['']).indexWhere((e) =>
                      e.trim().toLowerCase() ==
                      element.unitName?.trim().toLowerCase()) !=
                  -1) ||
          isStudent ||
          onlyInOut)) {
        if (element.type == 'Check-in' || element.type == 'Check-out') {
          continue;
        }
      }
      DateTime? date;
      if (element.timestamp != null)
        date = DateTime.fromMillisecondsSinceEpoch(element.timestamp! * 1000);

      Map<String, HistoryData> types = {
        'SGL': HistoryData(
            name: 'SGL',
            onTap: () => context.navigateTo(HistorySglPage(
                  id: element.attachment ?? '',
                )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'CST': HistoryData(
            name: 'CST',
            onTap: () => context.navigateTo(HistoryCstPage(
                  id: element.attachment ?? '',
                )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'Clinical Record': HistoryData(
            name: 'Clinical Record',
            onTap: () {
              context.navigateTo(
                SupervisorDetailClinicalRecordPage(
                  id: element.attachment ?? '',
                ),
              );
            },
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'Scientific Session': HistoryData(
            name: 'Scientific Session',
            onTap: () => context.navigateTo(
                  DetailScientificSessionPage(
                    id: element.attachment ?? '',
                  ),
                ),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'SELF_REFLECTION': HistoryData(
            name: 'Self Reflection',
            onTap: isStudent
                ? () {}
                : () => context.navigateTo(SupervisorSelfReflectionStudentPage(
                      studentId: element.studentId ?? '',
                    )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'CASE': HistoryData(
            name: 'CASE',
            onTap: () => isStudent
                ? {}
                : context.navigateTo(SupervisorListCasesPage(
                    studentName: element.studentName ?? '',
                    unitName: element.unitName ?? '',
                    studentId: element.studentId ?? '')),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'SKILL': HistoryData(
            name: 'SKILL',
            onTap: () => isStudent
                ? {}
                : context.navigateTo(SupervisorListSkillsPage(
                    studentName: element.studentName ?? '',
                    unitName: element.unitName ?? '',
                    studentId: element.studentId ?? '')),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
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
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'PERSONAL_BEHAVIOUR': HistoryData(
            name: 'Personal Behavior',
            onTap: () => isStudent
                ? context.navigateTo(StudentPersonalBehaviorPage(
                    unitName: element.unitName ?? ''))
                : context.navigateTo(SupervisorPersonalBehaviorDetailPage(
                    unitName: element.unitName ?? '',
                    id: element.attachment ?? '')),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
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
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'Problem Consultation': HistoryData(
            name: 'Problem Consultation',
            onTap: isStudent
                ? () {}
                : () => context.navigateTo(SpecialReportDetailPage(
                      studentId: element.studentId ?? '',
                    )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
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
                ? () {}
                : () => context.navigateTo(SupervisorFinalGrade(
                      departmentId: element.unitId ?? '',
                      departmentName: element.unitName ?? '',
                      studentId: element.studentId ?? '',
                      studentName: element.studentName ?? '',
                    )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        'DAILY_ACTIVITY': HistoryData(
            name: 'Daily Activity',
            onTap: () => context.navigateTo(SupervisorDailyActivityDetailPage(
                  id: element.attachment ?? '',
                  isHistory: true,
                )),
            pathIcon: 'wifi_protected_setup_rounded.svg'),
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
