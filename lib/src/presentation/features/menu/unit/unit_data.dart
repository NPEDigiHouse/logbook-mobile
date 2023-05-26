import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/asset_path.dart';

final List<String> iconPaths = [
  AssetPath.getIcon('clinical_notes_rounded.svg'),
  AssetPath.getIcon('biotech_rounded.svg'),
  AssetPath.getIcon('emoji_objects_rounded.svg'),
  AssetPath.getIcon('summarize_rounded.svg'),
  AssetPath.getIcon('flag_rounded.svg'),
  AssetPath.getIcon('wifi_protected_setup_rounded.svg'),
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
  'Special Report',
  'Rotation List',
  'Training',
  'SGL and CST',
  'Competence',
  'Reference',
  'Assessment'
];

final List<String> descriptions = List.generate(11, (_) {
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus et.';
});

final List<VoidCallback> onTaps = List.generate(11, (_) => () {});
