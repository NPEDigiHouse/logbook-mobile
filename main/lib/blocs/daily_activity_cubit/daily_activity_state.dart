part of 'daily_activity_cubit.dart';

class DailyActivityState {
  final RequestState? requestState;
  final RequestState? stateVerifyDailyActivity;
  final StudentDailyActivityResponse? studentDailyActivity;
  final StudentDailyActivityResponse? dailyActivityBySupervisor;
  final StudentActivityPerweekResponse? studentActivityPerweek;
  final DailyActivityStudent? activityPerweekBySupervisor;
  final bool isDailyActivityUpdated;
  final bool isDailyActivityVerifiedById;
  final bool isAddWeekSuccess;
  final List<ListWeekItem>? weekItems;
  final List<DailyActivityStudent>? dailyActivityStudents;
  final StudentDailyActivityPerDays? activityPerDays;
  final bool isEditWeekSuccess;
  final bool isRemoveWeekSuccess;
  final bool isEditStatusWeek;
  final RequestState fetchState;
  final String? errorMessage;

  DailyActivityState({
    this.studentDailyActivity,
    this.requestState,
    this.weekItems,
    this.errorMessage,
    this.fetchState = RequestState.init,
    this.dailyActivityStudents,
    this.isAddWeekSuccess = false,
    this.studentActivityPerweek,
    this.activityPerweekBySupervisor,
    this.isDailyActivityUpdated = false,
    this.isDailyActivityVerifiedById = false,
    this.dailyActivityBySupervisor,
    this.activityPerDays,
    this.isEditWeekSuccess = false,
    this.isRemoveWeekSuccess = false,
    this.isEditStatusWeek = false,
    this.stateVerifyDailyActivity = RequestState.init,
  });

  DailyActivityState copyWith({
    RequestState? requestState,
    StudentDailyActivityResponse? studentDailyActivity,
    StudentDailyActivityResponse? dailyActivityBySupervisor,
    StudentActivityPerweekResponse? studentActivityPerweek,
    DailyActivityStudent? activityPerweekBySupervisor,
    StudentDailyActivityPerDays? activityPerDays,
    bool isDailyActivityUpdated = false,
    bool isDailyActivityVerifiedById = false,
    List<ListWeekItem>? weekItems,
    bool isAddWeekSuccess = false,
    bool isEditWeekSuccess = false,
    bool isRemoveWeekSuccess = false,
    RequestState? fetchState,
    bool isEditStatusWeek = false,
    String? errorMessage,
    List<DailyActivityStudent>? dailyActivityStudents,
    RequestState stateVerifyDailyActivity = RequestState.init,
  }) {
    return DailyActivityState(
        errorMessage: errorMessage ?? this.errorMessage,
        isEditWeekSuccess: isEditWeekSuccess,
        fetchState: fetchState ?? RequestState.init,
        isRemoveWeekSuccess: isRemoveWeekSuccess,
        isEditStatusWeek: isEditStatusWeek,
        activityPerDays: activityPerDays ?? this.activityPerDays,
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
        dailyActivityStudents:
            dailyActivityStudents ?? this.dailyActivityStudents);
  }
}
