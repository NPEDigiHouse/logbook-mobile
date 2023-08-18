import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class GetAffectedPartsUsecase {
  final ClinicalRecordRepository repository;

  GetAffectedPartsUsecase({required this.repository});

  Future<Either<Failure, List<AffectedPart>>> execute({required String unitId}) async {
    return await repository.getAffectedParts(unitId: unitId);
  }
}
