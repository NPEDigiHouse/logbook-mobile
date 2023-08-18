import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class UploadClinicalRecordAttachmentUsecase {
  final ClinicalRecordRepository repository;

  UploadClinicalRecordAttachmentUsecase({required this.repository});

  Future<Either<Failure, String>> execute({required String path}) async {
    return await repository.uploadClinicalRecordAttachment(filePath: path);
  }
}
