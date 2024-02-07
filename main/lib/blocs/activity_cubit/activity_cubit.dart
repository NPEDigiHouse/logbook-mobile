import 'package:data/datasources/remote_datasources/activity_datasource.dart';
import 'package:data/models/activity/activity_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final ActivityDataSource datasource;
  ActivityCubit({required this.datasource}) : super(ActivityState());

  void init() {
    emit(state.copyWith(
        locationStatus: LocationStatus.notChecked,
        checkState: RequestState.init));
  }

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

  final double _radius = 300.0;

  Future<void> checkLocation(ActivityModel location) async {
    try {
      emit(state.copyWith(
        checkState: RequestState.loading,
      ));

      final currentPosition = await _determinePosition();
      if (currentPosition != null) {
        double distanceInMeters = Geolocator.distanceBetween(
            location.latitude ?? 0,
            location.longitude ?? 0,
            currentPosition.latitude,
            currentPosition.longitude);
        print(distanceInMeters);
        if (distanceInMeters <= _radius) {
          emit(state.copyWith(
              locationStatus: LocationStatus.insideArea,
              checkState: RequestState.data));
        } else {
          emit(state.copyWith(
              locationStatus: LocationStatus.outsideArea,
              checkState: RequestState.data));
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
