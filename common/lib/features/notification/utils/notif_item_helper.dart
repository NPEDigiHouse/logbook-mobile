import 'package:common/features/notification/notification_page.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:data/models/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:students/features/assesment/pages/final_score/student_final_score_page.dart';
import 'package:students/features/assesment/pages/mini_cex/student_test_grade_page.dart';
import 'package:students/features/assesment/pages/personal_behavior/student_personal_behavior_page.dart';
import 'package:students/features/assesment/pages/scientific_assigment/student_scientific_assignment_page.dart';
import 'package:students/features/assesment/pages/weekly_assesment/student_weekly_assesment_page.dart';
import 'package:students/features/clinical_record/pages/detail_clinical_record_page.dart';
import 'package:students/features/competences/list_cases_page.dart';
import 'package:students/features/competences/list_skills_page.dart';
import 'package:students/features/scientific_session/detail_scientific_session_page.dart';
import 'package:students/features/self_reflection/self_reflection_home_page.dart';
import 'package:students/features/sgl_cst/list_cst_page.dart';
import 'package:students/features/sgl_cst/list_sgl_page.dart';
import 'package:students/features/special_reports/special_report_home_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_mini_cex_detail_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_personal_behavior_detail_page.dart';
import 'package:supervisor/features/assesment/pages/supervisor_scientific_assignment_detail_page.dart';
import 'package:supervisor/features/clinical_record/supervisor_detail_clinical_record_page.dart';
import 'package:supervisor/features/competence/pages/list_cases_page.dart';
import 'package:supervisor/features/competence/pages/list_skills_page.dart';
import 'package:supervisor/features/daily_activity/supervisor_daily_activity_detail_page.dart';
import 'package:supervisor/features/scientific_session/detail_scientific_session_page.dart';
import 'package:supervisor/features/self_reflection/self_reflection_student_page.dart';
import 'package:supervisor/features/sgl_cst/supervisor_cst_detail_page.dart';
import 'package:supervisor/features/sgl_cst/supervisor_sgl_detail_page.dart';
import 'package:supervisor/features/special_report/special_report_detail_page.dart';

class NotifData {
  final String name;
  final VoidCallback onTap;
  final String pathIcon;

  NotifData({
    required this.name,
    required this.onTap,
    required this.pathIcon,
  });
}

class NotifiItemHelper {
  static String getSpecificTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference >= 2 && difference <= 6) {
      return '${difference}d';
    } else if (difference >= 7 && difference < 14) {
      return '1w';
    } else if (difference >= 14 && difference < 21) {
      return '2w';
    } else {
      final weeks = (difference / 7).floor();
      return '$weeks w';
    }
  }

  static String getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference <= 7) {
      return 'Last 7 days';
    } else if (difference <= 30) {
      return 'Last 30 days';
    } else {
      return 'Older';
    }
  }

  static Map<ActivityType, String> getActivityTypeReverse =
      Map<String, ActivityType>.from(getActivityType)
          .map((key, value) => MapEntry(value, key));

  static Map<String, ActivityType> getActivityType = {
    "SGL": ActivityType.sgl,
    "CST": ActivityType.cst,
    "CLINICAL_RECORD": ActivityType.clinicalRecord,
    "SCIENTIFIC_SESSION": ActivityType.scientificSession,
    "SELF_REFLECTION": ActivityType.selfReflection,
    "CASE": ActivityType.cases,
    "SKILL": ActivityType.skills,
    "OSCE": ActivityType.osce, // Tipe yang sama dengan "SKILL"?
    "CBT": ActivityType.cbt, // Tipe yang sama dengan "SKILL"?
    "FINAL_SCORE": ActivityType.finalScore,
    "MINI_CEX": ActivityType.miniCex,
    "PERSONAL_BEHAVIOUR": ActivityType.personalBehavior,
    "SCIENTIFIC_ASSESMENT":
        ActivityType.scientificAssignment, // Penulisan salah
    "WEEKLY_ASSESMENT": ActivityType.weeklyAssessment, // Penulisan salah
    "PROBLEM_CONSULTATION": ActivityType.problemConsultation,
    "CHECK_IN": ActivityType.checkIn,
    "CHECK_OUT": ActivityType.checkOut,
    "CEU_SGL": ActivityType.ceuSgl, // Tipe yang sama dengan "SGL"?
    "CEU_CST": ActivityType.ceuCst, // Tipe yang sama dengan "CST"?
    "DAILY_ACTIVITY": ActivityType.dailyActivity,
  };
  static Map<ActivityType, NotifData> getNotifData(BuildContext context,
          UserRole role, NotificationModel notification) =>
      {
        ActivityType.finalScore: NotifData(
            name: 'FINAL SCORE',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(
                    StudentFinalScorePage(
                      departmentName: notification.unitName ?? '',
                    ),
                  );
                }
              }
            },
            pathIcon: 'diversity_3_rounded.svg'),
        ActivityType.weeklyAssessment: NotifData(
            name: 'WEEKLY ASSESSMENT',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(
                    const StudentWeeklyAssementPage(),
                  );
                }
              }
            },
            pathIcon: 'diversity_3_rounded.svg'),
        ActivityType.sgl: NotifData(
            name: 'SGL',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorSglDetailPage(
                  studentId: notification.senderId ?? '',
                  isCeu: false,
                  studentName: notification.senderName ?? '',
                  unitName: notification.unitName,
                  userId: notification.receiverId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(
                      ListSglPage(activeDepartmentModel: notification.unit!));
                }
              }
            },
            pathIcon: 'diversity_3_rounded.svg'),
        ActivityType.cst: NotifData(
            name: 'CST',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorCstDetailPage(
                  studentId: notification.senderId ?? '',
                  isCeu: false,
                  studentName: notification.senderName ?? '',
                  unitName: notification.unitName,
                  userId: notification.receiverId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(
                      ListCstPage(activeDepartmentModel: notification.unit!));
                }
              }
            },
            pathIcon: 'medical_information_rounded.svg'),
        ActivityType.clinicalRecord: NotifData(
            name: 'Clinical Record',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorDetailClinicalRecordPage(
                  id: notification.submissionId ?? '',
                  unitName: notification.unitName,
                ));
              }
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(DetailClinicalRecordPage(
                    id: notification.submissionId ?? '',
                    department: notification.unit!,
                  ));
                }
              }
            },
            pathIcon: 'clinical_notes_rounded.svg'),
        ActivityType.scientificSession: NotifData(
            name: 'Scientific Session',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(
                  SupervisorDetailScientificSessionPage(
                    id: notification.submissionId ?? '',
                  ),
                );
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(
                  DetailScientificSessionPage(
                    id: notification.submissionId ?? '',
                    activeDepartmentModel: notification.unit,
                  ),
                );
              }
            },
            pathIcon: 'biotech_rounded.svg'),
        ActivityType.selfReflection: NotifData(
            name: 'Self Reflection',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorSelfReflectionStudentPage(
                  id: notification.senderActorId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(
                    StudentSelfReflectionHomePage(
                      activeDepartmentModel: notification.unit!,
                      isFromNotif: true,
                    ),
                  );
                }
              }
            },
            pathIcon: 'emoji_objects_rounded.svg'),
        ActivityType.cases: NotifData(
            name: 'CASE',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(
                  SupervisorListCasesPage(
                    studentId: notification.senderActorId ?? '',
                    studentName: notification.senderName ?? '',
                    unitName: notification.unitName ?? '',
                    id: notification.id ?? '',
                  ),
                );
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(
                  ListCasesPage(
                    unitId: notification.unitId ?? '',
                    unitName: notification.unitName ?? '',
                  ),
                );
              }
            },
            pathIcon: 'case_icon.svg'),
        ActivityType.skills: NotifData(
            name: 'SKILL',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(
                  SupervisorListSkillsPage(
                    studentId: notification.senderActorId ?? '',
                    studentName: notification.senderName ?? '',
                    unitName: notification.unitName ?? '',
                    id: notification.id ?? '',
                  ),
                );
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(
                  ListSkillsPage(
                    unitId: notification.unitId ?? '',
                    unitName: notification.unitName ?? '',
                  ),
                );
              }
            },
            pathIcon: 'skill_icon.svg'),
        ActivityType.miniCex: NotifData(
            name: 'Mini Cex',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorMiniCexDetailPage(
                    supervisorId: notification.receiverId ?? '',
                    id: notification.submissionId ?? ''));
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(StudentTestGrade(
                  unitName: notification.unitName ?? '',
                  isExaminerDPKExist: true,
                ));
              }
            },
            pathIcon: 'icon_test.svg'),
        ActivityType.personalBehavior: NotifData(
          name: 'Personal Behavior',
          onTap: () {
            Future.microtask(() {
              context
                  .read<NotificationCubit>()
                  .readNotification(id: notification.id ?? '');
            });
            //supervisor
            if (role == UserRole.supervisor) {
              context.navigateTo(SupervisorPersonalBehaviorDetailPage(
                  id: notification.submissionId ?? ''));
            }
            //student
            if (role == UserRole.student) {
              context.navigateTo(StudentPersonalBehaviorPage(
                  unitName: notification.unitName ?? ''));
            }
          },
          pathIcon: 'icon_personal_behavior.svg',
        ),
        ActivityType.scientificAssignment: NotifData(
            name: 'Scientific Assesment',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorScientificAssignmentDetailPage(
                  id: notification.submissionId ?? '',
                  supervisorId: notification.receiverId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(StudentScientificAssignmentPage(
                    isSupervisingDPKExist: true,
                    unitName: notification.unitName ?? ''));
              }
            },
            pathIcon: 'icon_scientific_assignment.svg'),
        ActivityType.problemConsultation: NotifData(
            name: 'Problem Consultation',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SpecialReportDetailPage2(
                  id: notification.submissionId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                if (notification.unit != null) {
                  context.navigateTo(SpecialReportHomePage(
                    activeDepartmentModel: notification.unit!,
                    isFromNotif: true,
                  ));
                }
              }
            },
            pathIcon: 'consultation_icon.svg'),
        ActivityType.checkIn: NotifData(
            name: 'CHECK-IN',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
            },
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        ActivityType.checkOut: NotifData(
            name: 'CHECK-OUT',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
            },
            pathIcon: 'wifi_protected_setup_rounded.svg'),
        ActivityType.finalScore: NotifData(
            name: 'Final Score',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
            },
            pathIcon: 'feed_rounded.svg'),
        ActivityType.dailyActivity: NotifData(
            name: 'Daily Activity',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
              //supervisor
              if (role == UserRole.supervisor) {
                context.navigateTo(SupervisorDailyActivityDetailPage(
                  id: notification.submissionId ?? '',
                ));
              }
              //student
              if (role == UserRole.student) {
                context.navigateTo(SupervisorDailyActivityDetailPage(
                  id: notification.submissionId ?? '',
                  isHistory: true,
                ));
              }
            },
            pathIcon: 'summarize_rounded.svg'),
        ActivityType.weeklyAssessment: NotifData(
            name: 'Weekly Assesment',
            onTap: () {
              Future.microtask(() {
                context
                    .read<NotificationCubit>()
                    .readNotification(id: notification.id ?? '');
              });
            },
            pathIcon: 'icon_weekly.svg'),
      };
}
