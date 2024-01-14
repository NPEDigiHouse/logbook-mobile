// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:common/features/file/file_management.dart';
import 'package:common/features/personal_data/widgets/change_profile_photo.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:students/features/menu/profile/widgets/personal_data_form.dart';

class PersonalDataPage extends StatefulWidget {
  final String userId;
  const PersonalDataPage({super.key, required this.userId});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<UserCubit>(context)
        ..getUserCredential()
        ..getProfilePic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Personal Data'),
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
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state.successUploadProfilePic) {
            BlocProvider.of<UserCubit>(context).getProfilePic();
          }
        },
        builder: (context, state) {
          if (state.userCredential != null) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Center(
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              builder: (ctx) => ChangeProfilePhotoSheet(
                                  onTap: () {
                                    FileManagement.uploadImage(
                                      context,
                                      (path) {
                                        BlocProvider.of<UserCubit>(context)
                                            .uploadProfilePic(path: path);
                                      },
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  isProfilePhotoExist:
                                      state.profilePic != null &&
                                          state.rspp == RequestState.data)),
                          child: Stack(
                            children: [
                              Builder(
                                builder: (context) {
                                  if (state.stateProfilePic ==
                                      RequestState.loading) {
                                    return CustomShimmer(
                                        child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      width: 100,
                                      height: 100,
                                    ));
                                  }
                                  if (state.profilePic != null &&
                                      state.rspp == RequestState.data) {
                                    return CircleAvatar(
                                      radius: 50,
                                      foregroundImage:
                                          MemoryImage(state.profilePic!),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      radius: 50,
                                      foregroundImage: AssetImage(
                                        AssetPath.getImage(
                                            'profile_default.png'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: scaffoldBackgroundColor),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AssetPath.getIcon('camera_filled.svg'),
                                      width: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 72),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '4x6 photo with green background in doctor\'s coat',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '(max 2mb)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  PersonalDataForm(
                    title: 'Student',
                    dataMap: {
                      'Fullname': state.userCredential!.fullname ?? '-',
                      'Clinic ID': state.userCredential!.student!.clinicId,
                      'Preclinic ID':
                          state.userCredential!.student!.preClinicId,
                      'S.Ked Graduation Date':
                          state.userCredential!.student!.graduationDate != null
                              ? Utils.datetimeToString(
                                  DateTime.fromMillisecondsSinceEpoch(state
                                          .userCredential!
                                          .student!
                                          .graduationDate! *
                                      1000))
                              : '',
                      'Academic Adviser':
                          state.userCredential!.student!.academicSupervisorName,
                    },
                    section: 1,
                  ),
                  PersonalDataForm(
                    title: 'Contact',
                    dataMap: {
                      'Phone Number/Whatsapp':
                          state.userCredential!.student!.phoneNumber,
                      'Email': state.userCredential!.email,
                      'Address': state.userCredential!.student!.address,
                    },
                    section: 2,
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
