import 'dart:ui';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_form.dart';

class PersonalDataPage extends StatefulWidget {
  final UserCredential userData;
  const PersonalDataPage({super.key, required this.userData});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: <Widget>[
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.profilePic != null) {
                        return CircleAvatar(
                          radius: 50,
                          foregroundImage: MemoryImage(state.profilePic!),
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: scaffoldBackgroundColor),
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
                'Fullname': widget.userData.student!.fullName ?? '',
                'Clinic ID': widget.userData.student!.clinicId,
                'Preclinic ID': widget.userData.student!.preClinicId,
                'S.Ked Graduation Date':
                    ReusableFunctionHelper.datetimeToString(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.userData.student!.graduationDate! * 1000)),
              },
            ),
            PersonalDataForm(
              title: 'Contact',
              dataMap: {
                'Phone Number/Whatsapp': widget.userData.student!.phoneNumber,
                'Email': widget.userData.email,
                'Address': widget.userData.student!.address,
              },
            ),
            PersonalDataForm(
              title: 'Academic Adviser and DPK',
              dataMap: {
                'Academic Adviser':
                    widget.userData.student!.academicSupervisorName,
                'Supervising DPK': widget.userData.student!.supervisingDPKName,
                'Examiner DPK': widget.userData.student!.examinerDPKName,
              },
            ),
            PersonalDataForm(
              title: 'Station',
              dataMap: {
                'Period and length of station':
                    widget.userData.student!.priodLengthStation.toString(),
                'RS Station': widget.userData.student!.rsStation,
                'PKM Station': widget.userData.student!.pkmStation,
              },
            ),
          ],
        ),
      ),
    );
  }
}
