import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_form.dart';

class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({super.key});

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
                  CircleAvatar(
                    radius: 50,
                    foregroundImage: AssetImage(
                      AssetPath.getImage('profile_default.png'),
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
            const PersonalDataForm(
              title: 'Student',
              dataMap: {
                'Fullname': 'Khairun Nisa',
                'Clinic ID': '90123',
                'Preclinic ID': '90123',
                'S.Ked Graduation Date': '02/20/2023',
              },
            ),
            const PersonalDataForm(
              title: 'Contact',
              dataMap: {
                'Phone Number/Whatsapp': '+62 821 9824 6668',
                'Email': 'Phantom26isn@gmail.com',
                'Address': 'BTP Blok E No 159',
              },
            ),
            const PersonalDataForm(
              title: 'Academic Adviser and DPK',
              dataMap: {
                'Academic Adviser': 'Setia Budi S.Ked',
                'Supervising DPK': 'Dr Bayu Ajid',
                'Examiner DPK': 'Muhammad Devon S.Ked',
              },
            ),
            const PersonalDataForm(
              title: 'Station',
              dataMap: {
                'Period and length of station': null,
                'RS Station': null,
                'PKM Station': null,
              },
            ),
          ],
        ),
      ),
    );
  }
}
