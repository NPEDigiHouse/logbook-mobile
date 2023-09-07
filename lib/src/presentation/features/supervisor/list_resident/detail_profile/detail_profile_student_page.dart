import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_card.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_section.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    BlocProvider.of<StudentCubit>(context)
      ..getStudentDetailById(studentId: widget.student.studentId!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
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
                    child: BlocBuilder<StudentCubit, StudentState>(
                      builder: (context, state) {
                        if (state.studentDetail != null)
                          return SpacingColumn(
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
                                state.studentDetail!.email ?? '-',
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
                                state.studentDetail!.phoneNumber ?? '-',
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
                                state.studentDetail!.address ?? '-',
                                style: textTheme.titleMedium?.copyWith(
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          );
                        return CustomLoading();
                      },
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
            // SliverPadding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   sliver: SliverList(
            //     delegate: SliverChildListDelegate(
            //       [
            //         DepartmentStatisticsCard(
            //           padding: const EdgeInsets.symmetric(vertical: 24),
            //           child: Column(
            //             children: <Widget>[
            //               Text(
            //                 'Current Department',
            //                 style: textTheme.titleMedium?.copyWith(
            //                   fontWeight: FontWeight.w600,
            //                   color: primaryColor,
            //                 ),
            //               ),
            //               const Text('Obstetrics and Gynecology'),
            //               const Padding(
            //                 padding: EdgeInsets.symmetric(vertical: 16),
            //                 child: Divider(
            //                   height: 6,
            //                   thickness: 6,
            //                   color: onDisableColor,
            //                 ),
            //               ),
            //               const DepartmentStatisticsSection(
            //                 titleText: 'Diagnosis Skills',
            //                 titleIconPath: 'skill_outlined.svg',
            //                 percentage: 73.0,
            //                 statistics: {
            //                   'Total Diagnosis Skill': 169,
            //                   'Performed': 108,
            //                   'Not Performed': 51,
            //                 },
            //                 detailStatistics: {
            //                   1: [
            //                     'Corneal reflex (4A)',
            //                     'Dolorit Sit Amet (4A)',
            //                     'Assessment of Pain Sensation (4A)',
            //                     'Lorem Ipsum (4A)',
            //                   ],
            //                   2: [
            //                     'Corneal reflex (4A)',
            //                     'Dolorit Sit Amet (4A)',
            //                     'Assessment of Pain Sensation (4A)',
            //                     'Lorem Ipsum (4A)',
            //                   ],
            //                 },
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.symmetric(vertical: 16),
            //                 child: Divider(
            //                   height: 6,
            //                   thickness: 6,
            //                   color: onDisableColor,
            //                 ),
            //               ),
            //               const DepartmentStatisticsSection(
            //                 titleText: 'Acquired Cases',
            //                 titleIconPath: 'attach_resume_male_outlined.svg',
            //                 percentage: 45.0,
            //                 statistics: {
            //                   'Total Acquired Case': 169,
            //                   'Identified Case': 96,
            //                   'Unidentified Case': 40,
            //                 },
            //                 detailStatistics: {
            //                   3: [
            //                     'Corneal reflex (4A)',
            //                     'Dolorit Sit Amet (4A)',
            //                     'Assessment of Pain Sensation (4A)',
            //                     'Lorem Ipsum (4A)',
            //                   ],
            //                 },
            //               ),
            //             ],
            //           ),
            //         ),
            //         SizedBox(
            //           height: 16,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
