import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_field.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/personal_data_section_header.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  late final ValueNotifier<bool> editableSections;

  @override
  void initState() {
    editableSections = ValueNotifier(false);

    super.initState();
  }

  @override
  void dispose() {
    editableSections.dispose();

    super.dispose();
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
      body: ValueListenableBuilder(
        valueListenable: editableSections,
        builder: (context, value, child) {
          return SingleChildScrollView(
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
                PersonalDataSectionHeader(
                  title: 'p',
                  icon: value ? Icons.edit_rounded : Icons.check_rounded,
                  onPressed: () {
                    editableSections.value = !value;
                  },
                ),
                buildPersonalDataSection(
                  sectionName: 'Student',
                  dataMap: {
                    'Fullname': 'Khairun Nisa',
                    'Clinic ID': '90123',
                    'Preclinic ID': '90123',
                    'S.Ked Graduation Date': '02/20/2023',
                  },
                ),
                buildPersonalDataSection(
                  sectionName: 'Contact',
                  dataMap: {
                    'Phone Number/Whatsapp': '+62 821 9824 6668',
                    'Email': 'Phantom26isn@gmail.com',
                    'Address': 'BTP Blok E No 159',
                  },
                ),
                buildPersonalDataSection(
                  sectionName: 'Academic Adviser and DPK',
                  dataMap: {
                    'Academic Adviser': 'Setia Budi S.Ked',
                    'Supervising DPK': 'Dr Bayu Ajid',
                    'Examiner DPK': 'Muhammad Devon S.Ked',
                  },
                ),
                buildPersonalDataSection(
                  sectionName: 'Station',
                  dataMap: {
                    'Period and length of station': '5 Months',
                    'RS Station': 'RS Hasanuddin',
                    'PKM Station': 'PKM Hasanuddin',
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column buildPersonalDataSection({
    required String sectionName,
    required Map<String, String> dataMap,
  }) {
    final labels = dataMap.keys.toList();
    final values = dataMap.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 16),
        for (var i = 0; i < dataMap.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PersonalDataField(
              label: labels[i],
              value: values[i],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}
