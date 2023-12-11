import 'package:data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:data/models/clinical_records/clinical_record_list_model.dart';
import 'package:data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:data/models/clinical_records/verify_clinical_record_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'clinical_record_supervisor_state.dart';

class ClinicalRecordSupervisorCubit
    extends Cubit<ClinicalRecordSupervisorState> {
  final ClinicalRecordsDatasource datasource;
  ClinicalRecordSupervisorCubit({required this.datasource})
      : super(ClinicalRecordSupervisorState());

  Future<void> getClinicalRecords() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await datasource.getClinicalRecordsBySupervisor();
      result.sort((a, b) =>
          (b.time ?? DateTime.now()).compareTo(a.time ?? DateTime.now()));

      try {
        emit(state.copyWith(
          clinicalRecords: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getDetailClinicalRecord({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await datasource.getDetailClinicalRecord(clinicalRecordId: id);
      try {
        emit(state.copyWith(
          detailClinicalRecordModel: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifyClinicalRecord(
      {required String id, required VerifyClinicalRecordModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await datasource.verifiyClinicalRecord(
          clinicalRecordId: id, model: model);
      try {
        emit(state.copyWith(successVerifyClinicalRecords: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
