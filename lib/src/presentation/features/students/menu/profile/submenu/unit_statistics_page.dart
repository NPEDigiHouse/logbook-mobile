import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_card.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_field.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_section.dart';

class UnitStatisticsPage extends StatelessWidget {
  const UnitStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Unit Statistics'),
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
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            UnitStatisticsCard(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  iconColor: primaryTextColor,
                  collapsedIconColor: primaryTextColor,
                  tilePadding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
                  childrenPadding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  leading: CircleAvatar(
                    radius: 32,
                    foregroundImage: AssetImage(
                      AssetPath.getImage('profile_default.png'),
                    ),
                  ),
                  title: Text(
                    'Khairun Nisa',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: const Text(
                    'Student',
                    style: TextStyle(color: primaryColor),
                  ),
                  children: const <Widget>[
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEFF0F9),
                    ),
                    SizedBox(height: 8),
                    UnitStatisticsField(
                      label: 'Student Id',
                      value: '1903102849319041',
                    ),
                    UnitStatisticsField(
                      label: 'Email',
                      value: '1903102849319041',
                    ),
                    UnitStatisticsField(
                      label: 'Phone',
                      value: '+6282198246668',
                    ),
                    UnitStatisticsField(
                      label: 'Address',
                      value: 'Jln Kebangsaan no.7 Makassar',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            UnitStatisticsCard(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: <Widget>[
                  Text(
                    'Current Unit',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const Text('Obstetrics and Gynecology'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 6,
                      thickness: 6,
                      color: onDisableColor,
                    ),
                  ),
                  const UnitStatisticsSection(
                    titleText: 'Diagnosis Skills',
                    titleIconPath: 'skill_outlined.svg',
                    percentage: 73.0,
                    statistics: {
                      'Total Diagnosis Skill': 169,
                      'Performed': 108,
                      'Not Performed': 51,
                    },
                    detailStatistics: {
                      1: [
                        'Corneal reflex (4A)',
                        'Dolorit Sit Amet (4A)',
                        'Assessment of Pain Sensation (4A)',
                        'Lorem Ipsum (4A)',
                      ],
                      2: [
                        'Corneal reflex (4A)',
                        'Dolorit Sit Amet (4A)',
                        'Assessment of Pain Sensation (4A)',
                        'Lorem Ipsum (4A)',
                      ],
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 6,
                      thickness: 6,
                      color: onDisableColor,
                    ),
                  ),
                  const UnitStatisticsSection(
                    titleText: 'Acquired Cases',
                    titleIconPath: 'attach_resume_male_outlined.svg',
                    percentage: 45.0,
                    statistics: {
                      'Total Acquired Case': 169,
                      'Identified Case': 96,
                      'Unidentified Case': 40,
                    },
                    detailStatistics: {
                      3: [
                        'Corneal reflex (4A)',
                        'Dolorit Sit Amet (4A)',
                        'Assessment of Pain Sensation (4A)',
                        'Lorem Ipsum (4A)',
                      ],
                    },
                  ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
