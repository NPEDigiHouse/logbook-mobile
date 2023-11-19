import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:elogbook/src/data/models/clinical_records/affected_part_model.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';
import 'package:elogbook/src/data/models/clinical_records/diagnosis_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/examination_types_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_role_model.dart';
import 'package:elogbook/src/data/models/clinical_records/management_types_model.dart';
part 'clinical_record_state.dart';

class ClinicalRecordCubit extends Cubit<ClinicalRecordState> {
  final ClinicalRecordsDatasource clinicalRecordsDatasource;

  ClinicalRecordCubit({
    required this.clinicalRecordsDatasource,
  }) : super(ClinicalRecordState());

  Future<void> getAffectedParts({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await clinicalRecordsDatasource.getAffectedParts(unitId: unitId);

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

      final result =
          await clinicalRecordsDatasource.getDiagnosisTypes(unitId: unitId);

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

  Future<void> deleteClinicalRecord({required String id}) async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));

      await clinicalRecordsDatasource.deleteClinicalRecord(id);
      emit(state.copyWith(
          requestState: RequestState.data, isDeleteClinicalRecord: true));
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

      final result =
          await clinicalRecordsDatasource.getExaminationTypes(unitId: unitId);

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

      final result = await clinicalRecordsDatasource.getManagementRoles();

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

      final result =
          await clinicalRecordsDatasource.getManagementTypes(unitId: unitId);

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

  Future<void> resetAttachment() async {
    emit(
      state.copyWith(
        pathAttachment: null,
        attachState: RequestState.init,
      ),
    );
  }

  Future<void> uploadClinicalRecordAttachment({required String path}) async {
    try {
      emit(state.copyWith(
        attachState: RequestState.loading,
      ));

      final result = await clinicalRecordsDatasource
          .uploadClinicalRecordAttachment(filePath: path);

      result.fold(
          (l) => emit(state.copyWith(attachState: RequestState.error)),
          (r) => emit(state.copyWith(
              pathAttachment: r, attachState: RequestState.data)));
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          attachState: RequestState.error,
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

      final result = await clinicalRecordsDatasource.uploadClinicalRecord(
          clinicalRecordPostModel: model);

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

  Future<void> addFeedback(
      {required String id, required String feedback}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await clinicalRecordsDatasource.makeFeedback(
          feedback: feedback, crId: id);

      emit(state.copyWith(isPostFeedbackSuccess: true));
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

  Future<void> crDownloadPath(
      {required String id, required String filaname}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final data = await clinicalRecordsDatasource.downloadFile(
          filename: filaname, crId: id);

      emit(state.copyWith(crDownloadPath: data));
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
