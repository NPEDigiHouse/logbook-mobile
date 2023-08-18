import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class GetManagementTypesUsecase {
  final ClinicalRecordRepository repository;

  GetManagementTypesUsecase({required this.repository});

  Future<Either<Failure, List<ManagementTypesModel>>> execute(
      {required String unitId}) async {
    return await repository.getManagementTypes(unitId: unitId);
  }
}
