import 'dart:io';
import 'dart:ui';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/custom_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_form.dart';
import 'package:permission_handler/permission_handler.dart';

class PersonalDataPage extends StatefulWidget {
  final String userId;
  const PersonalDataPage({super.key, required this.userId});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  Future<void> uploadFile(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        File file = File(result.files.single.path!);
        try {
          BlocProvider.of<ProfileCubit>(context)
            ..uploadProfilePic(path: file.path);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    } else if (status.isDenied) {
      // Pengguna menolak izin, Anda dapat memberi tahu pengguna untuk mengaktifkannya di pengaturan
      print('Storage permission is denied');
    } else if (status.isPermanentlyDenied) {
      // Pengguna secara permanen menolak izin, arahkan pengguna ke pengaturan aplikasi
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<ProfileCubit>(context)
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
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.successUploadProfilePic) {
            BlocProvider.of<ProfileCubit>(context)..getProfilePic();
          }
        },
        builder: (context, state) {
          if (state.userCredential != null) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => uploadFile(context),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              if (state.stateProfilePic ==
                                  RequestState.loading) {
                                return CustomShimmer(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  width: 100,
                                  height: 100,
                                ));
                              }
                              if (state.profilePic != null) {
                                return CircleAvatar(
                                  radius: 50,
                                  foregroundImage:
                                      MemoryImage(state.profilePic!),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 50,
                                  foregroundImage: AssetImage(
                                    AssetPath.getImage('profile_default.png'),
                                  ),
                                );
                              }
                            },
                          ),
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
                              border:
                                  Border.all(color: scaffoldBackgroundColor),
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
                              ? ReusableFunctionHelper.datetimeToString(
                                  DateTime.fromMillisecondsSinceEpoch(state
                                          .userCredential!
                                          .student!
                                          .graduationDate! *
                                      1000))
                              : '',
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
                  PersonalDataForm(
                    title: 'Academic Adviser and DPK',
                    dataMap: {
                      'Academic Adviser':
                          state.userCredential!.student!.academicSupervisorName,
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
          return CustomLoading();
        },
      ),
    );
  }
}
