import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class UploadClinicalRecordUsecase {
  final ClinicalRecordRepository repository;

  UploadClinicalRecordUsecase({required this.repository});

  Future<Either<Failure, void>> execute(
      {required ClinicalRecordPostModel model}) async {
    return await repository.uploadClinicalRecord(
        clinicalRecordPostModel: model);
  }
}
