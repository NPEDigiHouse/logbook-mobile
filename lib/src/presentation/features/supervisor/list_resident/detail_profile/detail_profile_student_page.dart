import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_card.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_section.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class DetailProfileStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const DetailProfileStudentPage({super.key, required this.student});

  @override
  State<DetailProfileStudentPage> createState() =>
      _DetailProfileStudentPageState();
}

class _DetailProfileStudentPageState extends State<DetailProfileStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = 'H071191049';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ...getHeadSection(
                title: title,
                subtitle: 'Detail Profile',
                student: widget.student),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                          blurRadius: 6,
                          color: Color(0xFFD4D4D4).withOpacity(.25),
                        ),
                        BoxShadow(
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                          blurRadius: 24,
                          color: Color(0xFFD4D4D4).withOpacity(.25),
                        ),
                      ],
                    ),
                    child: SpacingColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Student Name',
                          style: textTheme.bodyMedium?.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          widget.student.studentName ?? '',
                          style: textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Email',
                          style: textTheme.bodyMedium?.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          'mail@gmail.com',
                          style: textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Phone',
                          style: textTheme.bodyMedium?.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          '082198246668',
                          style: textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Address',
                          style: textTheme.bodyMedium?.copyWith(
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          'Jln Kebangsaan no.7 Makassar',
                          style: textTheme.titleMedium?.copyWith(
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 16,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
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
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}