import 'package:dartz/dartz.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';

class GetManagementRolesUsecase {
  final ClinicalRecordRepository repository;

  GetManagementRolesUsecase({required this.repository});

  Future<Either<Failure, List<ManagementRoleModel>>> execute() async {
    return await repository.getManagementRoles();
  }
}
