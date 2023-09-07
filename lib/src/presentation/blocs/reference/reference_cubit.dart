import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/reference_datasource.dart';
import 'package:elogbook/src/data/models/reference/reference_on_list_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'reference_state.dart';

class ReferenceCubit extends Cubit<ReferenceState> {
  final ReferenceDataSource dataSource;
  ReferenceCubit({required this.dataSource}) : super(ReferenceState());

  void reset() {
    emit(state.copyWith(rData: null));
  }

  Future<void> getListReference({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.getReferenceByDepartmentId(unitId: unitId);
      try {
        emit(state.copyWith(
          references: result,
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

  Future<void> getReferenceById(
      {required int id, required String fileName}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.downloadDataReference(id: id, filename: fileName);
      try {
        emit(state.copyWith(rData: result));
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
