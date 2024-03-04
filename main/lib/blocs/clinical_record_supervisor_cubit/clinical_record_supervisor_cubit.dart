import 'package:data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:data/models/clinical_records/clinical_record_list_model.dart';
import 'package:data/models/clinical_records/detail_clinical_record_model.dart';
import 'package:data/models/clinical_records/verify_clinical_record_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'clinical_record_supervisor_state.dart';

class ClinicalRecordSupervisorCubit
    extends Cubit<ClinicalRecordSupervisorState> {
  final ClinicalRecordsDatasource datasource;
  ClinicalRecordSupervisorCubit({required this.datasource})
      : super(ClinicalRecordSupervisorState());

  Future<void> getClinicalRecords(
      {String? unitId,
      int? page,
      String? query,
      bool onScroll = false,
      FilterType? type}) async {
    try {
      if (!onScroll) emit(state.copyWith(fetchState: RequestState.loading));
      final result = await datasource.getClinicalRecordsBySupervisor(
        filterType: type ?? FilterType.unverified,
        page: page,
        query: query,
        unitId: unitId,
      );

      try {
        if (page == 1 && !onScroll) {
          emit(state.copyWith(
              clinicalRecords: result, fetchState: RequestState.data));
        } else {
          emit(state.copyWith(
              clinicalRecords: result + state.clinicalRecords!,
              fetchState: RequestState.data));
        }
      } catch (e) {
        emit(state.copyWith(fetchState: RequestState.error));
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
        detailState: RequestState.loading,
      ));

      final result =
          await datasource.getDetailClinicalRecord(clinicalRecordId: id);
      emit(state.copyWith(
        detailClinicalRecordModel: result,
        detailState: RequestState.data,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          detailState: RequestState.error,
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
