import 'package:elogbook/core/helpers/asset_path.dart';

class Activity {
  final String title;
  final String supervisor;
  final String iconPath;
  final bool isVerified;
  final DateTime date;

  Activity({
    required this.title,
    this.supervisor = 'Eurico Devon',
    required this.iconPath,
    required this.isVerified,
    required this.date,
  });
}

class ClinicalRecord extends Activity {
  final String patient;
  final bool hasAttachment;

  ClinicalRecord({
    super.supervisor,
    required super.isVerified,
    required super.date,
    required this.patient,
    required this.hasAttachment,
  }) : super(
          title: 'Clinical Record',
          iconPath: AssetPath.getIcon('clinical_notes_rounded.svg'),
        );
}

class ScientificSession extends Activity {
  final String sessionType;

  ScientificSession({
    super.supervisor,
    required super.isVerified,
    required super.date,
    required this.sessionType,
  }) : super(
          title: 'Scientific Session',
          iconPath: AssetPath.getIcon('biotech_rounded.svg'),
        );
}

final List<Activity> activities = [
  ClinicalRecord(
    isVerified: true,
    date: DateTime(2023, 6, 8),
    patient: 'Muh. Fajri R',
    hasAttachment: true,
  ),
  ClinicalRecord(
    isVerified: false,
    date: DateTime(2023, 6, 8),
    patient: 'Teodaryl E',
    hasAttachment: false,
  ),
  ClinicalRecord(
    isVerified: true,
    date: DateTime(2023, 5, 8),
    patient: 'Richard Enrico S',
    hasAttachment: false,
  ),
  ClinicalRecord(
    isVerified: false,
    date: DateTime(2023, 4, 8),
    patient: 'Yusuf Syam',
    hasAttachment: true,
  ),
  ScientificSession(
    isVerified: true,
    date: DateTime(2023, 6, 8),
    sessionType: 'Group Discussion',
  ),
  ScientificSession(
    isVerified: false,
    date: DateTime(2023, 6, 8),
    sessionType: 'Journal Reading',
  ),
  ScientificSession(
    isVerified: true,
    date: DateTime(2023, 5, 8),
    sessionType: 'Group Discussion',
  ),
  ScientificSession(
    isVerified: false,
    date: DateTime(2023, 1, 8),
    sessionType: 'Journal Reading',
  ),
];
