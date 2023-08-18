import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_affected_parts_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_diagnosis_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_examination_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_management_roles_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_management_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/upload_clinical_record_attachment_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/upload_clinical_record_usecase.dart';

part 'clinical_record_state.dart';

class ClinicalRecordCubit extends Cubit<ClinicalRecordState> {
  final GetAffectedPartsUsecase getAffectedPartsUsecase;
  final GetDiagnosisTypesUsecase getDiagnosisTypesUsecase;
  final GetExaminationTypesUsecase getExaminationTypesUsecase;
  final GetManagementRolesUsecase getManagementRolesUsecase;
  final GetManagementTypesUsecase getManagementTypesUsecase;
  final UploadClinicalRecordAttachmentUsecase
      uploadClinicalRecordAttachmentUsecase;
  final UploadClinicalRecordUsecase uploadClinicalRecordUsecase;

  ClinicalRecordCubit({
    required this.getAffectedPartsUsecase,
    required this.getDiagnosisTypesUsecase,
    required this.getExaminationTypesUsecase,
    required this.getManagementRolesUsecase,
    required this.getManagementTypesUsecase,
    required this.uploadClinicalRecordAttachmentUsecase,
    required this.uploadClinicalRecordUsecase,
  }) : super(ClinicalRecordState());

  Future<void> getAffectedParts({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await getAffectedPartsUsecase.execute(unitId: unitId);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(affectedParts: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getDiagnosisTypes({required String unitId}) async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));

      final result = await getDiagnosisTypesUsecase.execute(unitId: unitId);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(diagnosisTypes: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getExaminationTypes({required String unitId}) async {
    try {
      emit(state.copyWith(requestState: RequestState.error));

      final result = await getExaminationTypesUsecase.execute(unitId: unitId);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(examinationTypes: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getManagementRoles() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await getManagementRolesUsecase.execute();

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(managementRoles: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getManagementTypes({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await getManagementTypesUsecase.execute(unitId: unitId);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(managementTypes: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadClinicalRecordAttachment({required String path}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await uploadClinicalRecordAttachmentUsecase.execute(path: path);

      result.fold((l) => emit(state.copyWith(requestState: RequestState.error)),
          (r) => emit(state.copyWith(pathAttachment: r)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> uploadClinicalRecord(
      {required ClinicalRecordPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await uploadClinicalRecordUsecase.execute(model: model);

      result.fold(
          (l) => emit(
                state.copyWith(requestState: RequestState.error),
              ), (r) {
        print("disiini");
        return emit(state.copyWith(clinicalRecordPostSuccess: true));
      });
    } catch (e) {
      print("iniasd");
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
