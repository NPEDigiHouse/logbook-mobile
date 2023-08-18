import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class GetDiagnosisTypesUsecase {
  final ClinicalRecordRepository repository;

  GetDiagnosisTypesUsecase({required this.repository});

  Future<Either<Failure, List<DiagnosisTypesModel>>> execute(
      {required String unitId}) async {
    return await repository.getDiagnosisTypes(unitId: unitId);
  }
}
