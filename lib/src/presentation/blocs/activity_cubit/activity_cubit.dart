import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/activity_datasource.dart';
import 'package:elogbook/src/data/models/activity/activity_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final ActivityDataSource datasource;
  ActivityCubit({required this.datasource}) : super(ActivityState());

  Future<void> getActivityLocations() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await datasource.getActivityLocations();
      try {
        emit(state.copyWith(
          activityLocations: result,
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

  Future<void> getActivityNames() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await datasource.getActivityNames();
      try {
        emit(state.copyWith(
          activityNames: result,
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
}
