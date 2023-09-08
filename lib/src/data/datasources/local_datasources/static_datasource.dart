import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/professional_activity/create_professional_activity_page.dart';
import 'package:elogbook/src/presentation/features/students/thesis/add_thesis_page.dart';
import 'package:flutter/material.dart';

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

List<MenuModel> listStudentMenu(bool isSglCstShow) => [
      // if (isSglCstShow)
      MenuModel(
          iconPath: 'diversity_3_rounded.svg',
          labels: 'SGL and CST',
          desc: 'Small Group Learning and Clinical Education Department'),
      MenuModel(
          iconPath: 'summarize_rounded.svg',
          labels: 'Daily Activity',
          desc: 'Contains the daily activities you do'),
      MenuModel(
          iconPath: 'clinical_notes_rounded.svg',
          labels: 'Clinical Record',
          desc: 'Clinical data that you do in this unit'),
      MenuModel(
          iconPath: 'biotech_rounded.svg',
          labels: 'Scientific Session',
          desc: 'The science session you attended'),
      MenuModel(
        iconPath: 'emoji_objects_rounded.svg',
        labels: 'Self Reflection',
        desc: "Internal introspective self-analysis.",
      ),
      MenuModel(
        iconPath: 'school_rounded.svg',
        labels: 'Competency',
        desc: 'List cases and skills you discussed, observed or performed.',
      ),
      MenuModel(
          iconPath: 'feed_rounded.svg',
          labels: 'Assessment',
          desc:
              'Weekly assessments, science assessments, mini-cex, personal behavior'),
      MenuModel(
          iconPath: 'consultation_icon.svg',
          labels: 'Special Reports',
          desc: 'Problem consultation with the supervisor'),
      MenuModel(
          iconPath: 'auto_stories_rounded.svg',
          labels: 'Reference',
          desc: 'Data reference in the active unit'),
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
    iconPath: 'emoji_objects_rounded.svg',
    labels: 'Self Reflection',
  ),
  MenuModel(
    iconPath: 'school_rounded.svg',
    labels: 'Competency',
  ),
  MenuModel(
    iconPath: 'feed_rounded.svg',
    labels: 'Assessment',
  ),
  MenuModel(
    iconPath: 'consultation_icon.svg',
    labels: 'Special Reports',
  ),
  MenuModel(
    iconPath: 'icon_final.svg',
    labels: 'Final Score',
  ),
];

// final List<Widget> pagesStudent = [
//   SizedBox(),
//   SizedBox(),
//   const CreateSelfReflectionPage(),
//   const DailyActivityPage(),
//   const AddTrainingPage(),
//   const SglCstHomePage(),
//   SizedBox(),
//   const ReferencePage(),
//   const AssesmentHomePage(),
// ];

final List<Widget> pagesGlobal = [
  const CreateProfessionalActivityPage(),
  const AddThesisPage(),
];

final List<String> descriptions = List.generate(9, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

// List<VoidCallback> onTaps(BuildContext context) {
//   return pagesStudent.map((e) => () => context.navigateTo(e)).toList();
// }
