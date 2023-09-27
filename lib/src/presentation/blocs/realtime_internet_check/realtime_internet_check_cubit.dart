import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'realtime_internet_check_state.dart';

class RealtimeInternetCheckCubit extends Cubit<RealtimeInternetCheckState> {
  StreamSubscription? connectivitySubscription;
  RealtimeInternetCheckCubit() : super(RealtimeInternetCheckInitial());

  Future<void> onCheckConnectionRealtime() async {
    final Connectivity connectivity = Connectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        emit(RealtimeInternetCheckGain());
      } else {
        emit(RealtimeInternetCheckLost());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
