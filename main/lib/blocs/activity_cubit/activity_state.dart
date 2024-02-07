part of 'activity_cubit.dart';

class ActivityState {
  final RequestState? requestState;
  final RequestState checkState;
  final List<ActivityModel>? activityLocations;
  final List<ActivityModel>? activityNames;
  final LocationStatus locationStatus;

  ActivityState({
    this.activityLocations,
    this.activityNames,
    this.requestState,
    this.checkState = RequestState.init,
    this.locationStatus = LocationStatus.notChecked,
  });

  ActivityState copyWith({
    RequestState? requestState,
    RequestState checkState = RequestState.init,
    List<ActivityModel>? activityLocations,
    List<ActivityModel>? activityNames,
    LocationStatus locationStatus = LocationStatus.notChecked,
    bool isDailyActivityUpdated = false,
  }) {
    return ActivityState(
      activityLocations: activityLocations ?? this.activityLocations,
      requestState: requestState ?? RequestState.init,
      locationStatus: locationStatus,
      checkState: checkState,
      activityNames: activityNames ?? this.activityNames,
    );
  }
}

enum LocationStatus {
  insideArea,
  outsideArea,
  notChecked,
}
