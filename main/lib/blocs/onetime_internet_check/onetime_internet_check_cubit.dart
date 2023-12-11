import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'onetime_internet_check_state.dart';

class OnetimeInternetCheckCubit extends Cubit<OnetimeInternetCheckState> {
  OnetimeInternetCheckCubit() : super(OnetimeInternetCheckInitial());

  Future<void> onCheckConnectionOnetime() async {
    final Connectivity connectivity = Connectivity();
    emit(OnetimeInternetCheckLoading());
    var result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      emit(OnetimeInternetCheckGain());
    } else {
      emit(OnetimeInternetCheckLost());
    }
  }
}
