import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

class MiniCexProvider extends ChangeNotifier {
  ReloadState state = ReloadState.init;
  void reset() {
    items.clear();
    notifyListeners();
  }

  final List<ItemRatingModel> items = [];

  void addItemRating(ItemRatingModel model) {
    items.add(
      ItemRatingModel(
        gradeItem: model.gradeItem,
        grade: model.grade,
        id: Uuid().v4(),
        scoreController: model.scoreController,
        titleController: model.titleController,
      ),
    );
    notifyListeners();
  }

  TotalGradeHelper? getTotalGrades() {
    double total = 0;
    for (var item in items) {
      total += item.grade / 100;
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
    total /= items.length;
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

    return items.isEmpty
        ? null
        : TotalGradeHelper(
            value: items.isEmpty ? 0 : total,
            gradientScore: ScoreGradientName(
                title: items.isEmpty ? 'E' : scoreLevel,
                color: items.isEmpty
                    ? onDisableColor
                    : Color(scoreColors[scoreLevel]!)));
  }

  List<Map> getMiniCexData() {
    final listData = [
      for (final item in items)
        {
          'name': item.gradeItem,
          'score': item.grade,
        }
    ];
    return listData;
  }

  void updateScore(double grade, String id) {
    items[items.indexWhere((element) => element.id == id)].grade = grade;
  }

  void updateGradeItem(String name, String id) {
    items[items.indexWhere((element) => element.id == id)].gradeItem = name;
  }

  void removeItemRating(String id) {
    notifyListeners();

    items.removeWhere((element) => element.id == id);
    state = ReloadState.init;

    notifyListeners();
  }

  void initialValue(int index) {
    items[index].scoreController.text = items[index].grade.toString();
    items[index].titleController.text = items[index].gradeItem;
    notifyListeners();
  }

  void init(List<Score> scores) {
    if (scores.length > items.length)
      for (var s in scores) {
        items.add(
          ItemRatingModel(
            gradeItem: s.name!,
            grade: s.score!.toDouble(),
            id: s.id.toString(),
            scoreController: TextEditingController(text: s.score.toString()),
            titleController: TextEditingController(text: s.name!),
          ),
        );
      }
  }
}
