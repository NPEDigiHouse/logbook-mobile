import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class GetExaminationTypesUsecase {
  final ClinicalRecordRepository repository;

  GetExaminationTypesUsecase({required this.repository});

  Future<Either<Failure, List<ExaminationTypesModel>>> execute(
      {required String unitId}) async {
    return await repository.getExaminationTypes(unitId: unitId);
  }
}
