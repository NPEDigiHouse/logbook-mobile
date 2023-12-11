import 'package:data/datasources/remote_datasources/daily_activity_datasource.dart';
import 'package:data/models/daily_activity/daily_activity_post_model.dart';
import 'package:data/models/daily_activity/daily_activity_student.dart';
import 'package:data/models/daily_activity/list_week_item.dart';
import 'package:data/models/daily_activity/post_week_model.dart';
import 'package:data/models/daily_activity/student_activity_perweek_model.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/daily_activity/student_daily_activity_per_days.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

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
        emit(state.copyWith(
            requestState: RequestState.error,
            errorMessage: "Week already created"));
      }
    } catch (e) {
      emit(
        state.copyWith(
            requestState: RequestState.error,
            errorMessage: "Week already created"),
      );
    }
  }

  Future<void> editWeekByCoordinator(
      {required PostWeek postWeek, required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateWeek(postWeek: postWeek, id: id);
      try {
        emit(state.copyWith(isEditWeekSuccess: true));
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

  Future<void> deleteWeekByCoordinator({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.deleteWeek(id: id);
      try {
        emit(state.copyWith(isRemoveWeekSuccess: true));
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

  Future<void> changeWeekStatus(
      {required bool status, required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateStatus(status: status, id: id);
      try {
        emit(state.copyWith(isEditStatusWeek: true));
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

  Future<void> getListWeek({required String unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getWeekByCoordinator(unitId: unitId);
      result.sort(
        (a, b) => b.startDate!.compareTo(a.startDate!),
      );
      try {
        emit(state.copyWith(weekItems: result));
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

  Future<void> getDailyActivityDays({required String weekId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.getStudentDailyPerDaysActivities(weekId: weekId);

      try {
        emit(state.copyWith(activityPerDays: result));
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

  Future<void> getActivitiesByWeekIdStudentId(
      {required String weekId, required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getActivitiesByStudentIdAndWeekId(
          weekId: weekId, studentId: studentId);

      try {
        emit(state.copyWith(activityPerDays: result));
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

  Future<void> getDailyActivityStudentBySupervisor({String? unitId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.getDailyActivitiesBySupervisor(unitId: unitId);

      try {
        emit(state.copyWith(
            dailyActivityStudents: result, requestState: RequestState.data));
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

  Future<void> getStudentDailyActivities() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentDailyActivities();
      result.weeks?.sort(
        (a, b) {
          return a.weekName!.compareTo(b.weekName!);
        },
      );
      try {
        emit(state.copyWith(
          studentDailyActivity: result,
          requestState: RequestState.data,
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

  Future<void> getDailyActivitiesBySupervisor(
      {required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSource.getDailyActivityBySupervisor(studentId: studentId);
      result.weeks?.sort(
        (a, b) {
          return a.weekName!.compareTo(b.weekName!);
        },
      );
      try {
        emit(state.copyWith(
          studentDailyActivity: result,
          requestState: RequestState.data,
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
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getActivityDetailBySupervisor({required String id}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getActivityOfDailyActivity(id: id);
      try {
        emit(state.copyWith(
          activityPerweekBySupervisor: result,
          requestState: RequestState.data,
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

  Future<void> updateDailyActivity(
      {required String id, required DailyActivityPostModel model}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateDailyActiviy(dayId: id, model: model);
      try {
        emit(state.copyWith(isDailyActivityUpdated: true));
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
        id: id,
        verifiedStatus: verifiedStatus,
      );
      try {
        emit(state.copyWith(
          isDailyActivityUpdated: true,
          stateVerifyDailyActivity: RequestState.data,
          requestState: RequestState.loading,
        ));
      } catch (e) {
        emit(state.copyWith(stateVerifyDailyActivity: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          stateVerifyDailyActivity: RequestState.error,
        ),
      );
    }
  }
}
