import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/professional_activity/create_professional_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/thesis/add_thesis_page.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/students/assesment/assesment_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/references/references_page.dart';
import 'package:elogbook/src/presentation/features/students/self_reflection/create_self_reflection_page.dart';
import 'package:elogbook/src/presentation/features/students/sgl_cst/sgl_cst_home_page.dart';
import 'package:elogbook/src/presentation/features/students/training/add_training_page.dart';

final List<Color> colors = [
  // primaryColor,
  variant2Color,
  variant1Color,
  // errorColor,
];

class MenuModel {
  final String iconPath;
  final String labels;
  final String? desc;

  MenuModel({required this.iconPath, required this.labels, this.desc});
}

final List<MenuModel> listGlobalMenu = [
  MenuModel(
    iconPath: 'health_metrics_rounded.svg',
    labels: 'Professional Activity',
  ),
  MenuModel(
    iconPath: 'menu_book_rounded.svg',
    labels: 'Thesis',
  ),
];

final List<MenuModel> listStudentMenu = [
  MenuModel(
    iconPath: 'diversity_3_rounded.svg',
    labels: 'SGL and CST',
  ),
  MenuModel(
    iconPath: 'summarize_rounded.svg',
    labels: 'Daily Activity',
  ),
  MenuModel(
    iconPath: 'clinical_notes_rounded.svg',
    labels: 'Clinical Record',
  ),
  MenuModel(
    iconPath: 'biotech_rounded.svg',
    labels: 'Scientific Session',
  ),
  MenuModel(
    iconPath: 'school_rounded.svg',
    labels: 'Competence',
  ),
  MenuModel(
    iconPath: 'feed_rounded.svg',
    labels: 'Assessment',
  ),
  MenuModel(
    iconPath: 'consultation_icon.svg',
    labels: 'Problem Consultation',
  ),
  MenuModel(
    iconPath: 'auto_stories_rounded.svg',
    labels: 'Reference',
  ),
];

final List<MenuModel> listSupervisorMenu = [
  MenuModel(
    iconPath: 'diversity_3_rounded.svg',
    labels: 'SGL and CST',
  ),
  MenuModel(
    iconPath: 'summarize_rounded.svg',
    labels: 'Daily Activity',
  ),
  MenuModel(
    iconPath: 'clinical_notes_rounded.svg',
    labels: 'Clinical Record',
  ),
  MenuModel(
    iconPath: 'biotech_rounded.svg',
    labels: 'Scientific Session',
  ),
  MenuModel(
    iconPath: 'school_rounded.svg',
    labels: 'Competence',
  ),
  MenuModel(
    iconPath: 'feed_rounded.svg',
    labels: 'Assessment',
  ),
  MenuModel(
    iconPath: 'consultation_icon.svg',
    labels: 'Problem Consultation',
  ),
  MenuModel(
    iconPath: 'auto_stories_rounded.svg',
    labels: 'Reference',
  ),
];

final List<Widget> pagesStudent = [
  SizedBox(),
  SizedBox(),
  const CreateSelfReflectionPage(),
  const DailyActivityPage(),
  const AddTrainingPage(),
  const SglCstHomePage(),
  SizedBox(),
  const ReferencePage(),
  const AssesmentHomePage(),
];

final List<Widget> pagesGlobal = [
  const CreateProfessionalActivityPage(),
  const AddThesisPage(),
];

final List<String> descriptions = List.generate(9, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

List<VoidCallback> onTaps(BuildContext context) {
  return pagesStudent.map((e) => () => context.navigateTo(e)).toList();
}
