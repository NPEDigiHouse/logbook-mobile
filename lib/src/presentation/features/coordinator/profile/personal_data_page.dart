import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/change_profile_photo.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:permission_handler/permission_handler.dart';

class LecturerPersonalDataPage extends StatefulWidget {
  const LecturerPersonalDataPage({super.key});

  @override
  State<LecturerPersonalDataPage> createState() =>
      _LecturerPersonalDataPageState();
}

class _LecturerPersonalDataPageState extends State<LecturerPersonalDataPage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Future<void> uploadFile(BuildContext context) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        File file = File(result.files.single.path!);
        try {
          BlocProvider.of<UserCubit>(context)
            ..uploadProfilePic(path: file.path);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    } else if (status.isDenied) {
      await Permission.storage.request();
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
            BlocProvider.of<UserCubit>(context)..getProfilePic();
          }
          if (state.successUpdateProfile) {
            FocusScope.of(context).unfocus();
            BlocProvider.of<UserCubit>(context)..getUserCredential();
          }
        },
        builder: (context, state) {
          if (state.userCredential != null) {
            fullnameController.text = state.userCredential!.fullname ?? '';
            usernameController.text = state.userCredential!.username ?? '-';
            userIdController.text =
                state.userCredential!.supervisor?.supervisorId ?? '-';
            emailController.text = state.userCredential!.email ?? '-';
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 40),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              builder: (ctx) => ChangeProfilePhotoSheet(
                                  onTap: () {
                                    uploadFile(context);
                                    Navigator.of(context).pop();
                                  },
                                  isProfilePhotoExist:
                                      state.profilePic != null &&
                                          state.rspp == RequestState.data)),
                          child: BlocBuilder<UserCubit, UserState>(
                            builder: (context, state) {
                              if (state.stateProfilePic ==
                                  RequestState.loading) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: primaryColor,
                                  )),
                                );
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
                  SpacingColumn(horizontalPadding: 16, spacing: 12, children: [
                    TextField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        label: Text('Full name'),
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        label: Text('Username'),
                        enabled: false,
                      ),
                    ),
                    TextField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        label: Text('User Id'),
                        enabled: false,
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        label: Text('Email'),
                        enabled: false,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FilledButton(
                            onPressed: () {
                              BlocProvider.of<UserCubit>(context)
                                ..updateFullName(
                                    fullname: fullnameController.text);
                            },
                            child: Text('Save'))
                        .fullWidth(),
                  ]),
                  SizedBox(
                    height: 16,
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
