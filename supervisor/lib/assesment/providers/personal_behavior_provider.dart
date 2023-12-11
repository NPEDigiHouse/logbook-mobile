import 'package:data/models/assessment/personal_behavior_detail.dart';

class PersonalBehaviorHelperModel {
  final String name;
  String verificationStatus;
  final int id;
  final String type;

  PersonalBehaviorHelperModel({
    required this.name,
    required this.verificationStatus,
    required this.type,
    required this.id,
  });
}

class PersonalBehaviorProvider {
  final List<PersonalBehaviorHelperModel> personalBehaviors = [];

  void init(List<Score> scores) {
    for (var element in scores) {
      personalBehaviors.add(PersonalBehaviorHelperModel(
        id: element.id ?? -1,
        name: element.name ?? '',
        type: element.type ?? '',
        verificationStatus: element.verificationStatus ?? '',
      ));
    }
  }
}
