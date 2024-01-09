// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:common/features/personal_data/widgets/change_profile_photo.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:students/features/menu/profile/widgets/personal_data_form.dart';

class DepartmentDataPage extends StatefulWidget {
  final String userId;
  const DepartmentDataPage({super.key, required this.userId});

  @override
  State<DepartmentDataPage> createState() => _DepartmentDataPageState();
}

class _DepartmentDataPageState extends State<DepartmentDataPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<UserCubit>(context).getUserCredential();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Department Data'),
        backgroundColor: scaffoldBackgroundColor.withAlpha(200),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.userCredential != null) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  PersonalDataForm(
                    title: 'DPK',
                    dataMap: {
                      'Supervising DPK':
                          state.userCredential!.student!.supervisingDPKName,
                      'Examiner DPK':
                          state.userCredential!.student!.examinerDPKName,
                    },
                    section: 3,
                  ),
                  PersonalDataForm(
                    title: 'Station',
                    dataMap: {
                      'Period and length of station (Weeks)': state
                          .userCredential!.student!.periodLengthStation
                          .toString(),
                      'RS Station': state.userCredential!.student!.rsStation,
                      'PKM Station': state.userCredential!.student!.pkmStation,
                    },
                    section: 4,
                  ),
                ],
              ),
            );
          }
          return const CustomLoading();
        },
      ),
    );
  }
}
