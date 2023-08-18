import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';

import '../../data/models/clinical_records/clinical_record_post_model.dart';

abstract class ClinicalRecordRepository {
  Future<Either<Failure, List<DiagnosisTypesModel>>> getDiagnosisTypes(
      {required String unitId});
  Future<Either<Failure, List<ManagementTypesModel>>> getManagementTypes(
      {required String unitId});
  Future<Either<Failure, List<ExaminationTypesModel>>> getExaminationTypes(
      {required String unitId});
  Future<Either<Failure, List<ManagementRoleModel>>> getManagementRoles();
  Future<Either<Failure, List<AffectedPart>>> getAffectedParts(
      {required String unitId});
  Future<Either<Failure, String>> uploadClinicalRecordAttachment(
      {required String filePath});
  Future<Either<Failure, void>> uploadClinicalRecord({
    required ClinicalRecordPostModel clinicalRecordPostModel,
  });
}
