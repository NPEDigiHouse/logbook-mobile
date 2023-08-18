import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class ClinicalRecordRepositoryImpl implements ClinicalRecordRepository {
  final ClinicalRecordsDatasource dataSource;

  ClinicalRecordRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<AffectedPart>>> getAffectedParts(
      {required String unitId}) async {
    try {
      final result = await dataSource.getAffectedParts(unitId: unitId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<DiagnosisTypesModel>>> getDiagnosisTypes(
      {required String unitId}) async {
    try {
      final result = await dataSource.getDiagnosisTypes(unitId: unitId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<ExaminationTypesModel>>> getExaminationTypes(
      {required String unitId}) async {
    try {
      final result = await dataSource.getExaminationTypes(unitId: unitId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<ManagementRoleModel>>>
      getManagementRoles() async {
    try {
      final result = await dataSource.getManagementRoles();
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<ManagementTypesModel>>> getManagementTypes(
      {required String unitId}) async {
    try {
      final result = await dataSource.getManagementTypes(unitId: unitId);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadClinicalRecordAttachment(
      {required String filePath}) async {
    try {
      final result =
          await dataSource.uploadClinicalRecordAttachment(filePath: filePath);
      return Right(result);
    } catch (e) {
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> uploadClinicalRecord(
      {required ClinicalRecordPostModel clinicalRecordPostModel}) async {
    try {
      final result = await dataSource.uploadClinicalRecord(
          clinicalRecordPostModel: clinicalRecordPostModel);
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
        ServerErrorFailure(e.toString()),
      );
    }
  }
}
