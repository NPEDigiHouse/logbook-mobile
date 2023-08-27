import 'package:flutter/material.dart';

class PartModel {
  String? partName;
  String? partId;
  List<TypeModel>? types;

  PartModel({this.partId, this.partName, this.types});
}

class TypeModel {
  String? typeName;
  String? typeId;

  TypeModel({this.typeId, this.typeName});
}

class ClinicalRecordDataNotifier extends ChangeNotifier {
  List<PartModel> examinations = [];
  List<PartModel> diagnostics = [];

  void addExaminationsPart(PartModel model) {
    examinations.add(model);
    notifyListeners();
  }

  void addExaminationType(TypeModel type, String partId) {
    examinations.forEach((element) {
      if (element.partId == partId) {
        element.types!.add(type);
        notifyListeners();
      }
    });
  }

  void removeExaminationType(String typeId, String partId) {
    examinations.forEach((element) {
      if (element.partId == partId) {
        element.types!.removeWhere((element) => element.typeId == typeId);
        notifyListeners();
      }
    });
  }

  void removeExaminationPart(String partId) {
    examinations.removeWhere((element) => element.partId == partId);
    notifyListeners();
  }
}
