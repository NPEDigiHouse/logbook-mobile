import 'package:data/datasources/remote_datasources/activity_datasource.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
