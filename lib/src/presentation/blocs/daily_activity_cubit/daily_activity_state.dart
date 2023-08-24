part of 'daily_activity_cubit.dart';

class DailyActivityState {
  final RequestState? requestState;
  final StudentDailyActivityResponse? studentDailyActivity;
  final StudentActivityPerweekResponse? studentActivityPerweek;
  final bool isDailyActivityUpdated;

  DailyActivityState({
    this.studentDailyActivity,
    this.requestState,
    this.studentActivityPerweek,
    this.isDailyActivityUpdated = false,
  });

  DailyActivityState copyWith({
    RequestState? requestState,
    StudentDailyActivityResponse? studentDailyActivity,
    StudentActivityPerweekResponse? studentActivityPerweek,
    bool isDailyActivityUpdated = false,
  }) {
    return DailyActivityState(
      studentDailyActivity: studentDailyActivity ?? this.studentDailyActivity,
      requestState: requestState ?? RequestState.init,
      isDailyActivityUpdated: isDailyActivityUpdated,
      studentActivityPerweek:
          studentActivityPerweek ?? this.studentActivityPerweek,
    );
  }
}
