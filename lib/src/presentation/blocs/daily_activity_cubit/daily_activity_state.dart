part of 'daily_activity_cubit.dart';

class DailyActivityState {
  final RequestState? requestState;
  final RequestState? stateVerifyDailyActivity;
  final StudentDailyActivityResponse? studentDailyActivity;
  final StudentDailyActivityResponse? dailyActivityBySupervisor;
  final StudentActivityPerweekResponse? studentActivityPerweek;
  final StudentActivityPerweekResponse? activityPerweekBySupervisor;
  final bool isDailyActivityUpdated;
  final bool isDailyActivityVerifiedById;
  final bool isAddWeekSuccess;
  final List<ListWeekItem>? weekItems;

  DailyActivityState({
    this.studentDailyActivity,
    this.requestState,
    this.weekItems,
    this.isAddWeekSuccess = false,
    this.studentActivityPerweek,
    this.activityPerweekBySupervisor,
    this.isDailyActivityUpdated = false,
    this.isDailyActivityVerifiedById = false,
    this.dailyActivityBySupervisor,
    this.stateVerifyDailyActivity = RequestState.init,
  });

  DailyActivityState copyWith({
    RequestState? requestState,
    StudentDailyActivityResponse? studentDailyActivity,
    StudentDailyActivityResponse? dailyActivityBySupervisor,
    StudentActivityPerweekResponse? studentActivityPerweek,
    StudentActivityPerweekResponse? activityPerweekBySupervisor,
    bool isDailyActivityUpdated = false,
    bool isDailyActivityVerifiedById = false,
    List<ListWeekItem>? weekItems,
    bool isAddWeekSuccess = false,
    RequestState stateVerifyDailyActivity = RequestState.init,
  }) {
    return DailyActivityState(
      studentDailyActivity: studentDailyActivity ?? this.studentDailyActivity,
      activityPerweekBySupervisor:
          activityPerweekBySupervisor ?? this.activityPerweekBySupervisor,
      dailyActivityBySupervisor:
          dailyActivityBySupervisor ?? this.dailyActivityBySupervisor,
      requestState: requestState ?? RequestState.init,
      isAddWeekSuccess: isAddWeekSuccess,
      isDailyActivityUpdated: isDailyActivityUpdated,
      weekItems: weekItems ?? this.weekItems,
      studentActivityPerweek:
          studentActivityPerweek ?? this.studentActivityPerweek,
      isDailyActivityVerifiedById: isDailyActivityVerifiedById,
      stateVerifyDailyActivity: stateVerifyDailyActivity,
    );
  }
}
