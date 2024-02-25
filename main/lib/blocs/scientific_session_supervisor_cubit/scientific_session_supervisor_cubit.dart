import 'package:data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:data/models/scientific_session/scientific_session_on_list_model.dart';
import 'package:data/models/scientific_session/verify_scientific_session_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'scientific_session_supervisor_state.dart';

class ScientificSessionSupervisorCubit
    extends Cubit<ScientificSessionSupervisorState> {
  final ScientificSessionDataSource datasource;

  ScientificSessionSupervisorCubit({required this.datasource})
      : super(ScientificSessionSupervisorState());

  Future<void> getScientificSessionList(
      {String? unitId,
      int? page,
      String? query,
      bool onScroll = false,
      FilterType? type}) async {
    try {
      final result = await datasource.getScientificSessionsBySupervisor(
        filterType: type ?? FilterType.unverified,
        page: page,
        query: query,
        unitId: unitId,
      );

      if (!onScroll) emit(state.copyWith(fetchState: RequestState.loading));

      if (page == 1 && !onScroll) {
        emit(state.copyWith(
            clinicalRecords: result, fetchState: RequestState.data));
      } else {
        emit(state.copyWith(
            clinicalRecords: result + state.listData!,
            fetchState: RequestState.data));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getScientificSessionDetail({required String id}) async {
    try {
      emit(state.copyWith(
        detailState: RequestState.loading,
      ));

      final result =
          await datasource.getScientificSessionDetail(scientificSessionId: id);
      result.fold(
          (l) => emit(
                state.copyWith(detailState: RequestState.error),
              ), (r) {
        emit(state.copyWith(
            detailClinicalRecordModel: r, detailState: RequestState.data));
      });
    } catch (e) {
      emit(
        state.copyWith(
          detailState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifyClinicalRecord(
      {required String id, required VerifyScientificSessionModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await datasource.verifyScientificSession(id: id, model: model);
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
