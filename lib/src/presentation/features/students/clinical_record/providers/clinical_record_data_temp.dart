import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/widgets/build_examination.dart';

class ClinicalRecordData {
  ClinicalRecordPostModel _clinicalRecordPostModel = ClinicalRecordPostModel();

  ClinicalRecordPostModel get clinicalRecordPostModel =>
      _clinicalRecordPostModel;

  void clear() {
    _clinicalRecordPostModel = ClinicalRecordPostModel();
  }

  void addAttachment(String path) {
    _clinicalRecordPostModel.attachment = path;
  }

  void tempAddSecondData(
      List<ManagementPostModel> managements,
      List<DiagnosisPostModel> diagnosis,
      List<ExaminationsPostModel> examinations) {
    _clinicalRecordPostModel.managements = managements;
    _clinicalRecordPostModel.diagnosiss = diagnosis;
    _clinicalRecordPostModel.examinations =examinations;
  }

  // void updateAffectedPart(
  //     {required AffectedPart old,
  //     required AffectedPart newAffectedPart,
  //     required ClinicalRecordSectionType type}) {
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.examination) {
  //     int index = _clinicalRecordPostModel.examinations!
  //         .indexWhere((element) => element.affectedPartId == old.id);
  //     _clinicalRecordPostModel.examinations![index].affectedPartId =
  //         newAffectedPart.id;
  //   }
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.diagnosis) {
  //     int index = _clinicalRecordPostModel.diagnosiss!
  //         .indexWhere((element) => element.affectedPartId == old.id);
  //     _clinicalRecordPostModel.diagnosiss![index].affectedPartId =
  //         newAffectedPart.id;
  //   }
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.management) {
  //     int index = _clinicalRecordPostModel.managements!
  //         .indexWhere((element) => element.affectedPartId == old.id);
  //     _clinicalRecordPostModel.managements![index].affectedPartId =
  //         newAffectedPart.id;
  //   }
  // }

  // void addData({
  //   required ClinicalRecordSectionType type,
  //   required AffectedPart affectedPart,
  //   String? roleId,
  //   String? id,
  // }) {
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.examination) {
  //     int index = _clinicalRecordPostModel.examinations!
  //         .indexWhere((element) => element.affectedPartId == affectedPart.id);
  //     if (index == -1) {
  //       _clinicalRecordPostModel.examinations!.add(ExaminationsPostModel(
  //           affectedPartId: affectedPart.id, examinationTypeId: [id!]));
  //     } else {
  //       _clinicalRecordPostModel.examinations![index].examinationTypeId!
  //           .add(id!);
  //     }
  //   }
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.diagnosis) {
  //     int index = _clinicalRecordPostModel.diagnosiss!
  //         .indexWhere((element) => element.affectedPartId == affectedPart.id);
  //     if (index == -1) {
  //       _clinicalRecordPostModel.diagnosiss!.add(DiagnosisPostModel(
  //           affectedPartId: affectedPart.id, diagnosisTypeId: [id!]));
  //     } else {
  //       _clinicalRecordPostModel.diagnosiss![index].diagnosisTypeId!.add(id!);
  //     }
  //   }
  //   if (ClinicalRecordSectionType == ClinicalRecordSectionType.management) {
  //     int index = _clinicalRecordPostModel.managements!
  //         .indexWhere((element) => element.affectedPartId == affectedPart.id);
  //     if (index == -1) {
  //       _clinicalRecordPostModel.managements!.add(
  //           ManagementPostModel(affectedPartId: affectedPart.id, management: [
  //         ManagementTypeRole(
  //           managementRoleId: roleId!,
  //           managementTypeId: id,
  //         )
  //       ]));
  //     } else {
  //       _clinicalRecordPostModel.managements![index].management!
  //           .add(ManagementTypeRole(
  //         managementRoleId: roleId!,
  //         managementTypeId: id,
  //       ));
  //     }
  //   }
  // }

  void addSupervisorId(String id) {
    _clinicalRecordPostModel.supervisorId = id;
  }

  void addRecordId(String id) {
    _clinicalRecordPostModel.recordId = id;
  }

  void addPatientData(String name, int age, String gender) {
    _clinicalRecordPostModel.patientName = name;
    _clinicalRecordPostModel.patientAge = age;
    _clinicalRecordPostModel.gender = gender;
  }

  bool isFirstDataComplete() {
    return _clinicalRecordPostModel.patientName != null &&
        _clinicalRecordPostModel.patientAge != null &&
        _clinicalRecordPostModel.supervisorId!.isNotEmpty &&
        _clinicalRecordPostModel.recordId != null &&
        _clinicalRecordPostModel.gender != null;
  }
}
