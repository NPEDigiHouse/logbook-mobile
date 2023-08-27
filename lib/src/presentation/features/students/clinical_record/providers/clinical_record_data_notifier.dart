import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PartModel {
  String? partName;
  String? partId;
  List<TypeModel>? types;

  PartModel({this.partId, this.partName, this.types});
}

class PartManagementModel {
  String? partName;
  String? partId;
  List<RoleTypeModel>? typeRoles;

  PartManagementModel({this.partId, this.partName, this.typeRoles});
}

class RoleTypeModel {
  String? typeName;
  String? typeId;
  String? roleName;
  String? roleId;

  RoleTypeModel({this.typeId, this.typeName, this.roleName, this.roleId});
}

class TypeModel {
  String? typeName;
  String? typeId;

  TypeModel({this.typeId, this.typeName});
}

class ClinicalRecordDataNotifier extends ChangeNotifier {
  List<PartModel> examinations = [];
  List<PartModel> diagnostics = [];
  List<PartManagementModel> managements = [];

  List<ExaminationsPostModel> getExaminationPost() {
    final List<ExaminationsPostModel> examinationPost = [];
    examinations.forEach((element) {
      examinationPost.add(ExaminationsPostModel(
          affectedPartId: element.partId,
          examinationTypeId: element.types!.map((e) => e.typeId!).toList()));
    });
    return examinationPost;
  }

  List<DiagnosisPostModel> getDiagnosisPost() {
    final List<DiagnosisPostModel> diagnosisPost = [];
    diagnostics.forEach((element) {
      diagnosisPost.add(DiagnosisPostModel(
          affectedPartId: element.partId,
          diagnosisTypeId: element.types!.map((e) => e.typeId!).toList()));
    });

    return diagnosisPost;
  }

  List<ManagementPostModel> getManagementPost() {
    final List<ManagementPostModel> managementPost = [];
    managements.forEach((element) {
      managementPost.add(ManagementPostModel(
          affectedPartId: element.partId,
          management: element.typeRoles!
              .map((e) => ManagementTypeRole(
                  managementRoleId: e.roleId, managementTypeId: e.typeId))
              .toList()));
    });
    return managementPost;
  }

  void addExaminationsPart(PartModel model) {
    examinations.add(PartModel(
      partId: model.partId ?? Uuid().v4(),
      partName: model.partName,
      types: [
        TypeModel(
            typeName: model.types!.first.typeName,
            typeId: model.types!.first.typeId ?? Uuid().v4()),
      ],
    ));
    notifyListeners();
  }

  void changeExaminationPart(PartModel model, String partIdBefore) {
    int index =
        examinations.indexWhere((element) => element.partId == partIdBefore);
    examinations[index].partId = model.partId;
    examinations[index].partName = model.partName;
    print(examinations[index].partName);
    notifyListeners();
  }

  void changeExaminationType(
      TypeModel model, String partId, String typeIdBefore) {
    int index = examinations.indexWhere((element) => element.partId == partId);
    int typeIndex =
        examinations[index].types!.indexWhere((e) => e.typeId == typeIdBefore);
    examinations[index].types![typeIndex].typeId = model.typeId;
    examinations[index].types![typeIndex].typeName = model.typeName;

    notifyListeners();
  }

  void addExaminationType(TypeModel type, String partId) {
    examinations.forEach((element) {
      if (element.partId == partId) {
        element.types!.add(TypeModel(
            typeId: type.typeId ?? Uuid().v4(), typeName: type.typeName));
      }
    });
    notifyListeners();
  }

  void removeExaminationType(String typeId, String partId) {
    examinations.forEach((element) {
      if (element.partId == partId) {
        element.types!.removeWhere((element) => element.typeId == typeId);
      }
    });
    notifyListeners();
  }

  void removeExaminationPart(String partId) {
    examinations.removeWhere((element) => element.partId == partId);
    notifyListeners();
  }

  void addDiagnosticPart(PartModel model) {
    diagnostics.add(PartModel(
      partId: model.partId ?? Uuid().v4(),
      partName: model.partName,
      types: [
        TypeModel(
            typeName: model.types!.first.typeName,
            typeId: model.types!.first.typeId ?? Uuid().v4()),
      ],
    ));
    notifyListeners();
  }

  void changeDiagnosticPart(PartModel model, String partIdBefore) {
    int index =
        diagnostics.indexWhere((element) => element.partId == partIdBefore);
    diagnostics[index].partId = model.partId;
    diagnostics[index].partName = model.partName;
    print(diagnostics[index].partName);
    notifyListeners();
  }

  void changeDiagnosticType(
      TypeModel model, String partId, String typeIdBefore) {
    int index = diagnostics.indexWhere((element) => element.partId == partId);
    int typeIndex =
        diagnostics[index].types!.indexWhere((e) => e.typeId == typeIdBefore);
    diagnostics[index].types![typeIndex].typeId = model.typeId;
    diagnostics[index].types![typeIndex].typeName = model.typeName;

    notifyListeners();
  }

  void addDiagnosticsType(TypeModel type, String partId) {
    diagnostics.forEach((element) {
      if (element.partId == partId) {
        element.types!.add(TypeModel(
            typeId: type.typeId ?? Uuid().v4(), typeName: type.typeName));
      }
    });
    notifyListeners();
  }

  void removeDiagnosticsType(String typeId, String partId) {
    diagnostics.forEach((element) {
      if (element.partId == partId) {
        element.types!.removeWhere((element) => element.typeId == typeId);
      }
    });
    notifyListeners();
  }

  void removeDiagnosticsPart(String partId) {
    diagnostics.removeWhere((element) => element.partId == partId);
    notifyListeners();
  }

  //!
  void addManagementPart(PartManagementModel model) {
    managements.add(PartManagementModel(
      partId: model.partId ?? Uuid().v4(),
      partName: model.partName,
      typeRoles: [
        RoleTypeModel(
          typeName: model.typeRoles!.first.typeName,
          typeId: model.typeRoles!.first.typeId ?? Uuid().v4(),
          roleName: model.typeRoles!.first.roleName,
          roleId: model.typeRoles!.first.roleId ?? Uuid().v4(),
        ),
      ],
    ));
    notifyListeners();
  }

  void changeManagementPart(PartManagementModel model, String partIdBefore) {
    int index =
        managements.indexWhere((element) => element.partId == partIdBefore);
    managements[index].partId = model.partId;
    managements[index].partName = model.partName;

    notifyListeners();
  }

  void changeManagementType(
      {required String typeId,
      required String typeName,
      required String partId,
      required String typeIdBefore}) {
    int index = managements.indexWhere((element) => element.partId == partId);
    int typeIndex = managements[index]
        .typeRoles!
        .indexWhere((e) => e.typeId == typeIdBefore);
    managements[index].typeRoles![typeIndex].typeId = typeId;
    managements[index].typeRoles![typeIndex].typeName = typeName;

    notifyListeners();
  }

  void changeManagementRole(
      {required String roleId,
      required String roleName,
      required String partId,
      required String roleIdBefore}) {
    int index = managements.indexWhere((element) => element.partId == partId);
    int typeIndex = managements[index]
        .typeRoles!
        .indexWhere((e) => e.typeId == roleIdBefore);
    managements[index].typeRoles![typeIndex].roleId = roleId;
    managements[index].typeRoles![typeIndex].roleName = roleName;

    notifyListeners();
  }

  void addManagementType(RoleTypeModel type, String partId) {
    managements.forEach((element) {
      if (element.partId == partId) {
        element.typeRoles!.add(
          RoleTypeModel(
            typeId: type.typeId ?? Uuid().v4(),
            typeName: type.typeName,
            roleId: type.roleId ?? Uuid().v4(),
            roleName: type.roleName,
          ),
        );
      }
    });
    notifyListeners();
  }

  void removeManagementRoleType(String typeId, String partId, String roleId) {
    managements.forEach((element) {
      if (element.partId == partId) {
        element.typeRoles!.removeWhere(
            (element) => element.typeId == typeId && element.roleId == roleId);
      }
    });
    notifyListeners();
  }

  void removeManagementPart(String partId) {
    managements.removeWhere((element) => element.partId == partId);
    notifyListeners();
  }
}
