import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_detail_model.dart';
import 'package:elogbook/src/data/models/scientific_session/scientific_session_on_list_model.dart';
import 'package:elogbook/src/data/models/scientific_session/verify_scientific_session_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'scientific_session_supervisor_state.dart';

class ScientificSessionSupervisorCubit
    extends Cubit<ScientificSessionSupervisorState> {
  final ScientificSessionDataSource datasource;

  ScientificSessionSupervisorCubit({required this.datasource})
      : super(ScientificSessionSupervisorState());

  Future<void> getScientificSessionList() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await datasource.getScientificSessionsBySupervisor();
      try {
        emit(state.copyWith(
          clinicalRecords: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
        requestState: RequestState.loading,
      ));

      final result =
          await datasource.getScientificSessionDetail(scientificSessionId: id);
      try {
        emit(state.copyWith(
          detailClinicalRecordModel: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
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
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
