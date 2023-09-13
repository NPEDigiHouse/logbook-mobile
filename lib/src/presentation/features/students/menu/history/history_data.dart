import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/data/models/history/history_model.dart';

class Activity {
  final String title;
  final String? supervisor;
  final String iconPath;
  final bool isVerified;
  final DateTime? date;
  final String studentId;
  final String studentName;
  final String? patientName;
  final String? dateTime;
  final String id;

  Activity(
      {required this.title,
      this.supervisor,
      required this.iconPath,
      required this.isVerified,
      required this.date,
      required this.id,
      this.patientName,
      required this.dateTime,
      required this.studentId,
      required this.studentName});
}

enum RoleHistory { student, supervisor }

class HistoryHelper {
  static List<Activity> convertHistoryToActivity(
      List<HistoryModel> history, RoleHistory roleHistory) {
    List<Activity> activityList = [];
    for (var element in history) {
      DateTime? date;
      if (element.timestamp != null)
        date = DateTime.fromMillisecondsSinceEpoch(element.timestamp! * 1000);
      print(element.type);
      switch (element.type) {
        case 'Clinical Record':
          activityList.add(Activity(
            isVerified: true,
            dateTime: ReusableFunctionHelper.datetimeToString(date!,
                isShowTime: true),
            date: DateTime(date.year, date.month, date.day, date.hour),
            title: 'Clinical Record',
            iconPath: AssetPath.getIcon('clinical_notes_rounded.svg'),
            patientName: element.patientName,
            id: element.attachment??'',
            supervisor: element.supervisorName,
            studentId: element.studentId??'',
            studentName: element.studentName??'',
          ));
          break;
        case 'Scientific Session':
          activityList.add(Activity(
            isVerified: true,
            dateTime: ReusableFunctionHelper.datetimeToString(date!,
                isShowTime: true),
            date: DateTime(date.year, date.month, date.day, date.hour),
            title: 'Scientific Session',
            iconPath: AssetPath.getIcon('biotech_rounded.svg'),
            supervisor: element.supervisorName,
            studentId: element.studentId ?? '',
            studentName: element.studentName ?? '',
            id: element.attachment ?? '',
          ));
          break;
        case 'SGL':
          activityList.add(Activity(
            isVerified: true,
            dateTime: ReusableFunctionHelper.datetimeToString(date!,
                isShowTime: true),
            date: DateTime(date.year, date.month, date.day, date.hour),
            title: 'SGL',
            iconPath: AssetPath.getIcon('diversity_3_rounded.svg'),
            supervisor: element.supervisorName,
            studentId: element.studentId ?? '',
            studentName: element.studentName ?? '',
            id: element.attachment!,
          ));
          break;
        case 'CST':
          activityList.add(Activity(
            isVerified: true,
            dateTime: ReusableFunctionHelper.datetimeToString(date!,
                isShowTime: true),
            date: DateTime(date.year, date.month, date.day, date.hour),
            title: 'CST',
            iconPath: AssetPath.getIcon('medical_information_rounded.svg'),
            supervisor: element.supervisorName,
            studentId: element.studentId ?? '',
            studentName: element.studentName ?? '',
            id: element.attachment!,
          ));
          break;
        case 'Self-Reflection':
          activityList.add(Activity(
            isVerified: true,
            dateTime: ReusableFunctionHelper.datetimeToString(date!,
                isShowTime: true),
            date: DateTime(date.year, date.month, date.day, date.hour),
            title: 'Self Reflection',
            iconPath: AssetPath.getIcon('diversity_3_rounded.svg'),
            supervisor: element.supervisorName,
            studentId: element.studentId ?? '',
            studentName: element.studentName ?? '',
            id: element.attachment!,
          ));
          break;
        default:
      }
      if (roleHistory != RoleHistory.student) {
        switch (element.type) {
          case 'Competency':
            activityList.add(Activity(
              isVerified: true,
              dateTime: ReusableFunctionHelper.datetimeToString(date!,
                  isShowTime: true),
              date: DateTime(date.year, date.month, date.day, date.hour),
              title: 'Competency',
              iconPath: AssetPath.getIcon('emoji_objects_rounded.svg'),
              supervisor: element.supervisorName,
              studentId: element.studentId ?? '',
              studentName: element.studentName ?? '',
              id: element.attachment ?? '',
            ));
            break;
          case "Assesment":
            activityList.add(Activity(
              isVerified: true,
              dateTime: ReusableFunctionHelper.datetimeToString(date!,
                  isShowTime: true),
              date: DateTime(date.year, date.month, date.day, date.hour),
              title: 'Assesment',
              iconPath: AssetPath.getIcon('feed_rounded.svg'),
              supervisor: element.supervisorName,
              studentId: element.studentId ?? '',
              id: element.studentId ?? '',
              studentName: element.studentName ?? '',
            ));
            break;
          case 'Problem Consultation':
            activityList.add(Activity(
              isVerified: true,
              dateTime: ReusableFunctionHelper.datetimeToString(date!,
                  isShowTime: true),
              date: DateTime(date.year, date.month, date.day, date.hour),
              title: 'Problem Constultation',
              iconPath: AssetPath.getIcon('consultation_icon.svg'),
              supervisor: element.supervisorName,
              studentId: element.studentId ?? '',
              id: element.studentId ?? '',
              studentName: element.studentName ?? '',
            ));
            break;
          case 'Check-in':
            activityList.add(Activity(
              isVerified: true,
              dateTime: ReusableFunctionHelper.datetimeToString(date!,
                  isShowTime: true),
              date: DateTime(date.year, date.month, date.day, date.hour),
              title: 'Check-In',
              iconPath: AssetPath.getIcon('wifi_protected_setup_rounded.svg'),
              supervisor: element.supervisorName,
              studentId: element.studentId ?? '',
              id: element.studentId ?? '',
              studentName: element.studentName ?? '',
            ));
            break;
          case 'Check-out':
            activityList.add(Activity(
              isVerified: true,
              dateTime: ReusableFunctionHelper.datetimeToString(date!,
                  isShowTime: true),
              date: DateTime(date.year, date.month, date.day, date.hour),
              title: 'Check-Out',
              iconPath: AssetPath.getIcon('wifi_protected_setup_rounded.svg'),
              supervisor: element.supervisorName,
              studentId: element.studentId ?? '',
              id: element.studentId ?? '',
              studentName: element.studentName ?? '',
            ));
            break;
          default:
        }
      }
    }
    print(activityList.length);
    return activityList;
  }
}

// class ClinicalRecord extends Activity {
//   final String patient;

//   ClinicalRecord({
//     super.supervisor,
//     required super.isVerified,
//     required super.date,
//     required this.patient,
//     required super.id,
//     required super.studentId,
//     required super.studentName,
//   }) : super(
//           title: 'Clinical Record',
//           iconPath: AssetPath.getIcon('clinical_notes_rounded.svg'),
//         );
// }

// class ScientificSession extends Activity {
//   ScientificSession({
//     super.supervisor,
//     required super.isVerified,
//     required super.date,
//     required super.studentId,
//     required super.studentName,
//     required super.id,
//   }) : super(
//           title: 'Scientific Session',
//           iconPath: AssetPath.getIcon('biotech_rounded.svg'),
//         );
// }
