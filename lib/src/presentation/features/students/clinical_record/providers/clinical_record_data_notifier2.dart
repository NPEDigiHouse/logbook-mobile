import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RoleTypeModel {
  String? id;
  String? typeName;
  String? typeId;
  String? roleName;
  String? roleId;

  RoleTypeModel(
      {this.id, this.typeId, this.typeName, this.roleName, this.roleId});
}

class TypeModel {
  String? id;
  String? typeName;
  String? typeId;

  TypeModel({this.id, this.typeId, this.typeName});
}

class ClinicalRecordDataNotifier2 extends ChangeNotifier {
  List<TypeModel> examinations = [];
  List<TypeModel> diagnostics = [];
  List<RoleTypeModel> managements = [];

  void reset() {
    examinations.clear();
    diagnostics.clear();
    managements.clear();
    notifyListeners();
  }

  void addExaminationsType(TypeModel model) {
    examinations.add(TypeModel(
      id: Uuid().v4(),
      typeId: model.typeId,
      typeName: model.typeName,
    ));
    notifyListeners();
  }

  void changeExaminationType(TypeModel model, String id) {
    int index = examinations.indexWhere((element) => element.id == id);
    examinations[index].typeId = model.typeId;
    examinations[index].typeName = model.typeName;

    notifyListeners();
  }

  void removeExaminationType(String id) {
    examinations.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addDiagnosticType(TypeModel model) {
    diagnostics.add(TypeModel(
      id: Uuid().v4(),
      typeId: model.typeId,
      typeName: model.typeName,
    ));
    notifyListeners();
  }

  void changeDiagnosticsType(TypeModel model, String id) {
    int index = diagnostics.indexWhere((element) => element.id == id);
    diagnostics[index].typeId = model.typeId;
    diagnostics[index].typeName = model.typeName;

    notifyListeners();
  }

  void removeDiagnosticsType(String id) {
    diagnostics.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void addManagement(RoleTypeModel model) {
    managements.add(RoleTypeModel(
      id: Uuid().v4(),
      typeId: model.typeId,
      typeName: model.typeName,
      roleId: model.roleId,
      roleName: model.roleName,
    ));
    notifyListeners();
  }

  void changeManagementType(RoleTypeModel model, String id) {
    int index = managements.indexWhere((element) => element.id == id);
    managements[index].typeId = model.typeId;
    managements[index].typeName = model.typeName;

    notifyListeners();
  }

  void changeManagementRole(RoleTypeModel model, String id) {
    int index = managements.indexWhere((element) => element.id == id);
    managements[index].roleId = model.roleId;
    managements[index].roleName = model.roleName;

    notifyListeners();
  }

  void removeManagement(String id) {
    managements.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  List<ExaminationsPostModel> getExaminationPost() {
    final List<ExaminationsPostModel> examinationPost = [];
    if (examinations.isNotEmpty) {
      examinationPost.addAll(examinations
          .map((e) => ExaminationsPostModel(examinationTypeId: [e.typeId!])));
    }
    return examinationPost;
  }

  List<DiagnosisPostModel> getDiagnosticsPost() {
    final List<DiagnosisPostModel> posts = [];
    if (diagnostics.isNotEmpty) {
      posts.addAll(diagnostics
          .map((e) => DiagnosisPostModel(diagnosisTypeId: [e.typeId!])));
    }
    return posts;
  }

  List<ManagementPostModel> getManagementsPost() {
    final List<ManagementPostModel> posts = [];
    if (managements.isNotEmpty) {
      posts.addAll(managements.map((e) => ManagementPostModel(management: [
            ManagementTypeRole(
                managementRoleId: e.roleId, managementTypeId: e.typeId)
          ])));
    }
    return posts;
  }
}
