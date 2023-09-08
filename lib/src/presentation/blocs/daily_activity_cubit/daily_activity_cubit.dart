import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/daily_activity_datasource.dart';
import 'package:elogbook/src/data/models/daily_activity/daily_activity_post_model.dart';
import 'package:elogbook/src/data/models/daily_activity/list_week_item.dart';
import 'package:elogbook/src/data/models/daily_activity/post_week_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_activity_perweek_model.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'daily_activity_state.dart';

class DailyActivityCubit extends Cubit<DailyActivityState> {
  final DailyActivityDataSource dataSource;
  DailyActivityCubit({required this.dataSource}) : super(DailyActivityState());

  Future<void> addWeekByCoordinator({required PostWeek postWeek}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.addWeekByCoordinator(postWeek: postWeek);
      try {
        emit(state.copyWith(isAddWeekSuccess: true));
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

  Future<void> getListWeek({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getWeekByCoordinator(unitId: unitId);
      result.sort(
        (a, b) => a.weekName!.compareTo(b.weekName!),
      );
      try {
        emit(state.copyWith(weekItems: result));
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

  Future<void> getStudentDailyActivities() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentDailyActivities();
      try {
        emit(state.copyWith(
          studentDailyActivity: result,
          requestState: RequestState.data,
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

  Future<void> getDailyActivitiesBySupervisor(
      {required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.getDailyActivityBySupervisor(studentId: studentId);
      try {
        emit(state.copyWith(
          studentDailyActivity: result,
          requestState: RequestState.data,
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

  Future<void> getStudentActivityPerweek({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentActivityPerweek(id: id);
      try {
        emit(state.copyWith(
          studentActivityPerweek: result,
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

  Future<void> getActivityPerweekBySupervisor({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getActivityOfDailyActivity(id: id);
      try {
        emit(state.copyWith(
          studentActivityPerweek: result,
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

  Future<void> updateDailyActivity(
      {required String id, required DailyActivityPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateDailyActiviy(id: id, model: model);
      try {
        emit(state.copyWith(isDailyActivityUpdated: true));
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

  void reset() {
    emit(state.copyWith(
        stateVerifyDailyActivity: RequestState.init, weekItems: null));
  }

  Future<void> verifiyDailyActivityById(
      {required String id, required bool verifiedStatus}) async {
    try {
      emit(state.copyWith(
        stateVerifyDailyActivity: RequestState.loading,
      ));

      await dataSource.verifiyDailyActivityById(
          id: id, verifiedStatus: verifiedStatus);
      try {
        emit(state.copyWith(
            isDailyActivityUpdated: true,
            stateVerifyDailyActivity: RequestState.data));
      } catch (e) {
        emit(state.copyWith(stateVerifyDailyActivity: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          stateVerifyDailyActivity: RequestState.error,
        ),
      );
    }
  }
}
