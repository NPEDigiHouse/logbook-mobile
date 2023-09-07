import 'package:elogbook/src/data/models/assessment/list_scientific_assignment.dart';
import 'package:flutter/material.dart';

class ItemRatingSA {
  final String indicator;
  int score;
  final TextEditingController scoreController;
  final int id;

  ItemRatingSA({
    required this.indicator,
    required this.score,
    required this.id,
    required this.scoreController,
  });
}

class TotalGradeHelper {
  final double value;
  final ScoreGradientName gradientScore;

  TotalGradeHelper({required this.value, required this.gradientScore});
}

enum ScientificType {
  discussion,
  presentation,
  presentation_style,
}

class ScoreGradientName {
  final String title;
  final Color color;

  ScoreGradientName({required this.title, required this.color});
}

class ScientificAssignmentProvider extends ChangeNotifier {
  void reset() {
    presentationList.clear();
    presentationStyleList.clear();
    discussionList.clear();
    isAlreadyInit = false;
    notifyListeners();
  }

  bool isAlreadyInit = false;
  final List<ItemRatingSA> presentationStyleList = [];
  final List<ItemRatingSA> presentationList = [];
  final List<ItemRatingSA> discussionList = [];

  TotalGradeHelper? getTotalGrades() {
    double total = 0;

    for (var item in presentationList) {
      total += item.score / 100;
    }

    for (var item in presentationStyleList) {
      total += item.score / 100;
    }
    for (var item in discussionList) {
      total += item.score / 100;
    }

    Map<String, int> scoreColors = {
      'A': 0xFF56B9A1,
      'B+': 0xFF7AB28C,
      'B': 0xFF9FAE78,
      'B-': 0xFFC4A763,
      'C+': 0xFFE8A04E,
      'C': 0xFFFFCB51,
      'C-': 0xFFE79D6B,
      'D': 0xFFC28B86,
      'E': 0xFFD1495B,
    };

    total /= (presentationList.length +
        presentationStyleList.length +
        discussionList.length);
    String scoreLevel;
    if (total * 100 >= 85) {
      scoreLevel = 'A';
    } else if (total * 100 >= 80) {
      scoreLevel = 'A-';
    } else if (total * 100 > 75) {
      scoreLevel = 'B+';
    } else if (total * 100 > 70) {
      scoreLevel = 'B';
    } else if (total * 100 > 65) {
      scoreLevel = 'B-';
    } else if (total * 100 >= 60) {
      scoreLevel = 'C+';
    } else if (total * 100 >= 50) {
      scoreLevel = 'C';
    } else if (total * 100 >= 40) {
      scoreLevel = 'D';
    } else {
      scoreLevel = 'E';
    }

    return TotalGradeHelper(
        value: total,
        gradientScore: ScoreGradientName(
            title: scoreLevel, color: Color(scoreColors[scoreLevel]!)));
  }

  List<Map> getScientificAssignmentData() {
    final listData = [
      for (final item in presentationList)
        {
          'id': item.id,
          'score': item.score,
        },
      for (final item in presentationStyleList)
        {
          'id': item.id,
          'score': item.score,
        },
      for (final item in discussionList)
        {
          'id': item.id,
          'score': item.score,
        }
    ];
    return listData;
  }

  void updateScore({
    required double grade,
    required int id,
    required ScientificType type,
  }) {
    switch (type) {
      case ScientificType.discussion:
        discussionList[discussionList.indexWhere((element) => element.id == id)]
            .score = grade.toInt();
        break;
      case ScientificType.presentation:
        presentationList[
                presentationList.indexWhere((element) => element.id == id)]
            .score = grade.toInt();
        break;
      case ScientificType.presentation_style:
        presentationStyleList[
                presentationStyleList.indexWhere((element) => element.id == id)]
            .score = grade.toInt();
        break;
      default:
    }
  }

  void init(List<Score> scores) {
    presentationList.clear();
    presentationStyleList.clear();
    discussionList.clear();
    // if (scores.isEmpty) {
    //   List<String> presentationData = [
    //     'Systematic Arrangement',
    //     'Coherence of Thought Flow',
    //     'Proper and Correct Language Usage',
    //     'Writing Style and Reference Usage'
    //   ];
    //   List<String> presentationStyleData = [
    //     'Timeliness of Presentation',
    //     'Presentation Method and Techniques',
    //     'Visualization Techniques (Delivery/Transparency)',
    //   ];
    //   List<String> discussionData = [
    //     'Mastery of Material',
    //     'Relevance of Answers and Questions',
    //     'Clear, Concise, and Directed Answering Techniques',
    //   ];

    //   int index = 1;

    //   for (var element in presentationData) {
    //     presentationList.add(
    //       ItemRatingSA(
    //           indicator: element,
    //           score: 0,
    //           id: index,
    //           scoreController: TextEditingController(text: '0')),
    //     );
    //     index++;
    //   }

    //   for (var element in presentationStyleData) {
    //     presentationStyleList.add(
    //       ItemRatingSA(
    //           indicator: element,
    //           score: 0,
    //           id: index,
    //           scoreController: TextEditingController(text: '0')),
    //     );
    //     index++;
    //   }

    //   for (var element in discussionData) {
    //     discussionList.add(
    //       ItemRatingSA(
    //           indicator: element,
    //           score: 0,
    //           id: index,
    //           scoreController: TextEditingController(text: '0')),
    //     );
    //     index++;
    //   }
    // }

    //  else {
    for (var s in scores) {
      switch (s.type) {
        case ScientificAssignmentType.CARA_PENYAJIAN:
          presentationStyleList.add(ItemRatingSA(
              indicator: s.name!,
              score: s.score ?? 0,
              id: s.id!,
              scoreController:
                  TextEditingController(text: s.score.toString())));
          break;
        case ScientificAssignmentType.DISKUSI:
          discussionList.add(ItemRatingSA(
              indicator: s.name!,
              score: s.score ?? 0,
              id: s.id!,
              scoreController:
                  TextEditingController(text: s.score.toString())));
          break;
        case ScientificAssignmentType.SAJIAN:
          presentationList.add(ItemRatingSA(
              indicator: s.name!,
              score: s.score ?? 0,
              id: s.id!,
              scoreController:
                  TextEditingController(text: s.score.toString())));
          break;
        default:
      }
    }
    // }
    isAlreadyInit = true;
  }
}
