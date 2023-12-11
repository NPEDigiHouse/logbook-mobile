part of 'activity_cubit.dart';

class ActivityState {
  final RequestState? requestState;
  final List<ActivityModel>? activityLocations;
  final List<ActivityModel>? activityNames;

  ActivityState({
    this.activityLocations,
    this.activityNames,
    this.requestState,
  });

  ActivityState copyWith({
    RequestState? requestState,
    List<ActivityModel>? activityLocations,
    List<ActivityModel>? activityNames,
    bool isDailyActivityUpdated = false,
  }) {
    return ActivityState(
      activityLocations: activityLocations ?? this.activityLocations,
      requestState: requestState ?? RequestState.init,
      activityNames: activityNames ?? this.activityNames,
    );
  }
}
