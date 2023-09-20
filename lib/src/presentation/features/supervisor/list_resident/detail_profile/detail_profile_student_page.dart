import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_card.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/widgets/unit_statistics_section.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailProfileStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const DetailProfileStudentPage({super.key, required this.student});

  @override
  State<DetailProfileStudentPage> createState() =>
      _DetailProfileStudentPageState();
}

class _DetailProfileStudentPageState extends State<DetailProfileStudentPage> {
  final GlobalKey keyCase = GlobalKey(debugLabel: 'keyCase');
  final GlobalKey keySkill = GlobalKey(debugLabel: 'keySkill');
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StudentCubit>(context)
      ..getStudentDetailById(studentId: widget.student.studentId!)
      ..getStatisticByStudentId(studentId: widget.student.studentId!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
  }

  TotalGradeHelper? getTotalGrades(double grades) {
    Map<String, int> scoreColors = {
      'A': 0xFF56B9A1,
      'A-': 0xFF7AB28C,
      'B+': 0xFF9FAE78,
      'B': 0xFFC4A763,
      'B-': 0xFFE8A04E,
      'C+': 0xFFFFCB51,
      'C': 0xFFE79D6B,
      'D': 0xFFC28B86,
      'E': 0xFFD1495B,
    };
    String scoreLevel;
    if (grades >= 85) {
      scoreLevel = 'A';
    } else if (grades >= 80) {
      scoreLevel = 'A-';
    } else if (grades > 75) {
      scoreLevel = 'B+';
    } else if (grades > 70) {
      scoreLevel = 'B';
    } else if (grades > 65) {
      scoreLevel = 'B-';
    } else if (grades >= 60) {
      scoreLevel = 'C+';
    } else if (grades >= 50) {
      scoreLevel = 'C';
    } else if (grades >= 40) {
      scoreLevel = 'D';
    } else {
      scoreLevel = 'E';
    }

    return TotalGradeHelper(
      value: grades,
      gradientScore: ScoreGradientName(
        title: scoreLevel,
        color: Color(scoreColors[scoreLevel]!),
      ),
    );
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
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<StudentCubit, StudentState>(
                    builder: (context, state) {
                  if (state.studentStatistic != null) {
                    final stData = state.studentStatistic!;
                    return DepartmentStatisticsCard(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   'Current Department',
                          //   style: textTheme.titleMedium?.copyWith(
                          //     fontWeight: FontWeight.w600,
                          //     color: primaryColor,
                          //   ),
                          // ),
                          // Text(widget.activeDepartmentModel.unitName ?? ''),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 16),
                          //   child: Divider(
                          //     height: 6,
                          //     thickness: 6,
                          //     color: onDisableColor,
                          //   ),
                          // ),
                          if (stData.finalScore != null) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    AssetPath.getIcon('icon_final_grade.svg'),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Final Score',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Builder(builder: (context) {
                              final scoreData = getTotalGrades(
                                  (stData.finalScore ?? 0.0).toDouble());
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 24),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: scoreData?.gradientScore.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        scoreData!.gradientScore.title,
                                        style: textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        scoreData.value.toInt().toString(),
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 6,
                                thickness: 6,
                                color: onDisableColor,
                              ),
                            ),
                          ],
                          DepartmentStatisticsSection(
                            repaintKey: keySkill,
                            titleText: 'Diagnosis Skills',
                            titleIconPath: 'skill_outlined.svg',
                            percentage:
                                (stData.verifiedSkills! / stData.totalSkills!) *
                                    100,
                            statistics: {
                              'Total Diagnosis Skill': stData.totalSkills!,
                              'Performed': stData.verifiedSkills,
                              'Not Performed':
                                  stData.totalSkills! - stData.verifiedSkills!,
                            },
                            detailStatistics: {
                              1: [
                                ...stData.skills!
                                    .map((e) => e.skillName ?? '')
                                    .toList(),
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
                          DepartmentStatisticsSection(
                            repaintKey: keyCase,
                            titleText: 'Acquired Cases',
                            titleIconPath: 'attach_resume_male_outlined.svg',
                            percentage:
                                (stData.verifiedCases! / stData.totalCases!) *
                                    100,
                            statistics: {
                              'Total Acquired Case': stData.totalCases,
                              'Identified Case': stData.verifiedCases,
                              'Unidentified Case':
                                  stData.totalCases! - stData.verifiedCases!,
                            },
                            detailStatistics: {
                              1: [
                                ...stData.cases!
                                    .map((e) => e.caseName ?? '')
                                    .toList(),
                              ],
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return CustomLoading();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
