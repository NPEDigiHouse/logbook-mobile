import 'package:data/models/sglcst/topic_model.dart';
import 'package:flutter/material.dart';

class ItemRatingModel {
  String gradeItem;
  double grade;
  final TextEditingController scoreController;
  final TextEditingController titleController;
  final String? id;

  ItemRatingModel({
    required this.gradeItem,
    required this.grade,
    this.id,
    required this.scoreController,
    required this.titleController,
  });
}

class TotalGradeHelper {
  final double value;
  final ScoreGradientName gradientScore;

  TotalGradeHelper({required this.value, required this.gradientScore});
}

class ScoreGradientName {
  final String title;
  final Color color;

  ScoreGradientName({required this.title, required this.color});
}

enum ReloadState { init, reload }

class ParseHelper {
  static List<TopicModel> filterTopic(
      {required List<TopicModel> listData, required bool isSGL}) {
    final List<TopicModel> topics = [];
    for (var i = 0; i < listData.length; i++) {
      if (isSGL && listData[i].name!.trim().toLowerCase().startsWith('sgl')) {
        topics.add(listData[i]);
      } else if (!isSGL &&
          listData[i].name!.trim().toLowerCase().startsWith('cst')) {
        topics.add(listData[i]);
      }
      if (!listData[i].name!.trim().toLowerCase().startsWith('sgl') &&
          !listData[i].name!.trim().toLowerCase().startsWith('cst')) {
        topics.add(listData[i]);
      }
    }
    return topics;
  }
}

TotalGradeHelper? getTotalGrades(double grades) {
  Map<String, int> scoreColors = {
    'A': 0xFF56B9A1,
    'A-': 0xFF7AB28C,
    'B+': 0xFF9FAE78,
    'B': 0xFFC4A763,
    'B-': 0xFFE8A04E,
    'C+': 0xFFFFCB51,
    'C': 0xFFE79D6B,
    'D': 0xFFC28B86,
    'E': 0xFFD1495B,
  };
  String scoreLevel;
  if (grades >= 85) {
    scoreLevel = 'A';
  } else if (grades >= 80) {
    scoreLevel = 'A-';
  } else if (grades > 75) {
    scoreLevel = 'B+';
  } else if (grades > 70) {
    scoreLevel = 'B';
  } else if (grades > 65) {
    scoreLevel = 'B-';
  } else if (grades >= 60) {
    scoreLevel = 'C+';
  } else if (grades >= 50) {
    scoreLevel = 'C';
  } else if (grades >= 40) {
    scoreLevel = 'D';
  } else {
    scoreLevel = 'E';
  }

  return TotalGradeHelper(
    value: grades / 100,
    gradientScore: ScoreGradientName(
      title: scoreLevel,
      color: Color(scoreColors[scoreLevel]!),
    ),
  );
}
