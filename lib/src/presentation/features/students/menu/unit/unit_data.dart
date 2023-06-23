import 'package:elogbook/src/presentation/features/students/clinical_record/pages/create_clinical_record_first_page.dart';
import 'package:elogbook/src/presentation/features/students/competences/competences_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/add_scientific_session_page.dart';
import 'package:elogbook/src/presentation/features/students/training/add_training_page.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/src/presentation/features/students/assesment/assesment_home_page.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/create_self_reflection_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/sgl_cst_home_page.dart';

final List<String> iconPaths = [
  AssetPath.getIcon('clinical_notes_rounded.svg'),
  AssetPath.getIcon('biotech_rounded.svg'),
  AssetPath.getIcon('emoji_objects_rounded.svg'),
  AssetPath.getIcon('summarize_rounded.svg'),
  AssetPath.getIcon('medical_information_rounded.svg'),
  AssetPath.getIcon('diversity_3_rounded.svg'),
  AssetPath.getIcon('school_rounded.svg'),
  AssetPath.getIcon('auto_stories_rounded.svg'),
  AssetPath.getIcon('feed_rounded.svg'),
];

final List<String> labels = [
  'Clinical Record',
  'Scientific Session',
  'Self Reflection',
  'Daily Activity',
  'Training',
  'SGL and CST',
  'Competence',
  'Reference',
  'Assessment'
];

final List<Widget> pages = [
  CreateClinicalRecordFirstPage(),
  AddScientificSessionPage(),
  CreateSelfReflectionPage(),
  DailyActivityPage(),
  AddTrainingPage(),
  SglCstHomePage(),
  CompetenceHomePage(),
  SizedBox(),
  AssesmentHomePage(),
];

final List<String> descriptions = List.generate(9, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

List<VoidCallback> onTaps(BuildContext context) {
  return pages.map((e) => () => context.navigateTo(e)).toList();
}
