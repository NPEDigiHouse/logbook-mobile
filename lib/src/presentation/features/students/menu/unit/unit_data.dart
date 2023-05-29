import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/src/presentation/features/students/assesment/assesment_home_page.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/create_clinical_record_first_page.dart';
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

final List<String> descriptions = List.generate(9, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

List<VoidCallback> onTaps(BuildContext context) {
  List<VoidCallback> onTapList = [];

  for (var i = 0; i < 9; i++) {
    if (i == 0) {
      onTapList.add(() => context.navigateTo(CreateClinicalRecordFirstPage()));
    } else if (i == 2) {
      onTapList.add(() => context.navigateTo(CreateSelfReflectionPage()));
    } else if (i == 7) {
      onTapList.add(() => context.navigateTo(SglCstHomePage()));
    } else if (i == 10) {
      onTapList.add(() => context.navigateTo(AssesmentHomePage()));
    } else {
      onTapList.add(() {});
    }
  }

  return onTapList;
}
