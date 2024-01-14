import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/realtime_internet_check/realtime_internet_check_cubit.dart';
import 'package:main/widgets/custom_alert.dart';

class CheckInternetRealtime extends StatefulWidget {
  final Widget child;
  const CheckInternetRealtime({super.key, required this.child});

  @override
  State<CheckInternetRealtime> createState() => _CheckInternetRealtimeState();
}

class _CheckInternetRealtimeState extends State<CheckInternetRealtime> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RealtimeInternetCheckCubit>(context)
        .onCheckConnectionRealtime();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealtimeInternetCheckCubit, RealtimeInternetCheckState>(
      listener: (context, state) {
        if (state is RealtimeInternetCheckLost) {
          CustomAlert.error(
              message: 'Internet connection lost', context: context);
        } else if (state is RealtimeInternetCheckGain) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      },
      child: widget.child,
    );
  }
}
