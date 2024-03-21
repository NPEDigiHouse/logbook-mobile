import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/units/student_department_recap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/headers/form_section_header.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/spacing_row.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class StudentRecapPage extends StatefulWidget {
  final String studentId;
  const StudentRecapPage({super.key, required this.studentId});

  @override
  State<StudentRecapPage> createState() => _StudentRecapPageState();
}

class _StudentRecapPageState extends State<StudentRecapPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => BlocProvider.of<StudentCubit>(context)
        .getStudentRecap(studentId: widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Department Recap'),
      ),
      body: SafeArea(
          child:
              BlocSelector<StudentCubit, StudentState, StudentDepartmentRecap?>(
        selector: (state) => state.studentDepartmentRecap,
        builder: (context, state) {
          if (state == null) {
            return const CustomLoading();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SpacingColumn(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DepartmentHeader(
                  unitName: state.unitName ?? '',
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (state.isCompleted ?? false)
                            ? successColor
                            : errorColor,
                        borderRadius: BorderRadius.circular(80),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            (state.isCompleted ?? false)
                                ? Icons.verified
                                : Icons.hourglass_top_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (state.isCompleted ?? false)
                                ? 'Completed'
                                : 'Uncompleted',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                StudentDepartmentHeader(
                  studentName: state.studentName ?? '',
                  studentId: state.studentId ?? '',
                ),
                ExpanseCustom(
                  title: 'Daily Activity Recap',
                  isVerified: (state.dailyActivityStat ?? 0) > 70,
                  path: 'summarize_rounded.svg',
                  children: [
                    Builder(
                      builder: (context) {
                        Map<String, double> dataMap = {
                          "Attend":
                              (state.dailyActivityAttendNum ?? 0).toDouble(),
                          "Not Attend":
                              (state.dailyActivityNotAttendNum ?? 0).toDouble(),
                          "Pending":
                              (state.dailyActivityPendingNum ?? 0).toDouble(),
                        };
                        final colorList = <Color>[
                          primaryColor,
                          errorColor,
                          dividerColor,
                        ];
                        return SpacingRow(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: PieChart(
                                      dataMap: dataMap,
                                      animationDuration:
                                          const Duration(milliseconds: 800),
                                      chartLegendSpacing: 32,
                                      chartRadius: 100,
                                      colorList: colorList,
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 20,
                                      legendOptions: LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.right,
                                        // legendShape: BoxShape.circle,
                                        showLegends: false,
                                        legendTextStyle: textTheme.bodySmall!,
                                      ),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: false,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Center(
                                      child: Text(
                                        '${(state.dailyActivityStat ?? 0).toStringAsFixed(2)}%',
                                        style: textTheme.titleLarge?.copyWith(
                                          color:
                                              (state.dailyActivityStat ?? 0) >
                                                      70
                                                  ? primaryColor
                                                  : errorColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SpacingColumn(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...dataMap.entries.map((e) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.value.toString(),
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: e.key == 'Pending'
                                              ? Colors.grey
                                              : e.key == 'Attend'
                                                  ? primaryColor
                                                  : errorColor,
                                        ),
                                      ),
                                      Text(
                                        e.key,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: primaryTextColor,
                                        ),
                                      )
                                    ],
                                  );
                                }).toList()
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
                ExpanseCustom(
                  title: 'Submission',
                  path: 'case_icon.svg',
                  isVerified: (state.caseVerifiedCount ?? 0) > 0 ||
                      (state.skillVerifiedCount ?? 0) > 0 ||
                      (state.cstVerifiedCount ?? 0) > 0 ||
                      (state.sglVerifiedCount ?? 0) > 0 ||
                      (state.clinicalRecordVerifiedCount ?? 0) > 0 ||
                      (state.scientificSessionVerifiedCount ?? 0) > 0,
                  children: [
                    SpacingRow(
                      spacing: 12,
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon('diversity_3_rounded.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.sglSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Small Group Learning',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.sglVerifiedCount ==
                                              state.sglSubmitCount
                                          ? successColor
                                          : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.sglVerifiedCount ==
                                                  state.sglSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.sglVerifiedCount ==
                                                  state.sglSubmitCount
                                              ? 'Completed'
                                              : '${(state.sglSubmitCount ?? 0) - (state.sglVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon(
                                      'medical_information_rounded.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.cstSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Clinical Skill Training',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.cstVerifiedCount ==
                                              state.cstSubmitCount
                                          ? successColor
                                          : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.cstVerifiedCount ==
                                                  state.cstSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.cstVerifiedCount ==
                                                  state.cstSubmitCount
                                              ? 'Completed'
                                              : '${(state.cstSubmitCount ?? 0) - (state.cstVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SpacingRow(
                      spacing: 12,
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon(
                                      'clinical_notes_rounded.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.clinicalRecordSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Clinical Record',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          state.clinicalRecordVerifiedCount ==
                                                  state
                                                      .clinicalRecordSubmitCount
                                              ? successColor
                                              : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.clinicalRecordVerifiedCount ==
                                                  state
                                                      .clinicalRecordSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.clinicalRecordVerifiedCount ==
                                                  state
                                                      .clinicalRecordSubmitCount
                                              ? 'Completed'
                                              : '${(state.clinicalRecordSubmitCount ?? 0) - (state.clinicalRecordVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon('biotech_rounded.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.scientificSessionSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Scientific Session',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.scientificSessionVerifiedCount ==
                                              state.scientificSessionSubmitCount
                                          ? successColor
                                          : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.scientificSessionVerifiedCount ==
                                                  state
                                                      .scientificSessionSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.scientificSessionVerifiedCount ==
                                                  state
                                                      .scientificSessionSubmitCount
                                              ? 'Completed'
                                              : '${(state.scientificSessionSubmitCount ?? 0) - (state.scientificSessionVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SpacingRow(
                      spacing: 12,
                      children: [
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon('case_icon.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.caseSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Acquired Cases',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.caseVerifiedCount ==
                                              state.caseSubmitCount
                                          ? successColor
                                          : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.caseVerifiedCount ==
                                                  state.caseSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.caseVerifiedCount ==
                                                  state.caseSubmitCount
                                              ? 'Completed'
                                              : '${(state.caseSubmitCount ?? 0) - (state.caseVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: dividerColor)),
                          child: SpacingColumn(
                            spacing: 4,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: SvgPicture.asset(
                                  AssetPath.getIcon('skill_icon.svg'),
                                  color: scaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${state.skillSubmitCount}',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Performed Skills',
                                style: textTheme.bodySmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: state.skillVerifiedCount ==
                                              state.skillSubmitCount
                                          ? successColor
                                          : secondaryTextColor,
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          state.skillVerifiedCount ==
                                                  state.skillSubmitCount
                                              ? Icons.verified
                                              : Icons.hourglass_top_rounded,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.skillVerifiedCount ==
                                                  state.skillSubmitCount
                                              ? 'Completed'
                                              : '${(state.skillSubmitCount ?? 0) - (state.skillVerifiedCount ?? 0)} Unverified',
                                          style: textTheme.labelSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
                ExpanseCustom(
                  title: 'Final Score',
                  path: 'feed_rounded.svg',
                  isVerified: state.isFinalScoreShow ?? false,
                  children: [
                    if (state.isFinalScoreShow ?? false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Builder(builder: (context) {
                            final totalGrade =
                                getTotalGrades(state.finalScore ?? 0);
                            return SemicircularIndicator(
                              contain: true,
                              radius: 100,
                              progress: totalGrade != null
                                  ? totalGrade!.value / 100
                                  : 0,
                              strokeCap: StrokeCap.round,
                              color: totalGrade != null
                                  ? totalGrade!.gradientScore.color
                                  : onDisableColor,
                              bottomPadding: 0,
                              backgroundColor: const Color(0xFFB0EAFC),
                              child: Column(
                                children: [
                                  Text(
                                    totalGrade != null
                                        ? 'Avg: ${(totalGrade.value).toStringAsFixed(2)}'
                                        : '-',
                                    style: textTheme.bodyMedium?.copyWith(),
                                  ),
                                  Text(
                                    totalGrade != null
                                        ? totalGrade!.gradientScore.title
                                        : 'Unknown',
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: secondaryTextColor,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.hourglass_top_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Waiting for Assessment',
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}

class ExpanseCustom extends StatelessWidget {
  final String title;
  final String path;
  final bool isVerified;
  final List<Widget> children;
  const ExpanseCustom({
    super.key,
    required this.title,
    required this.path,
    this.isVerified = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: primaryTextColor,
          collapsedIconColor: primaryTextColor,
          tilePadding: const EdgeInsets.only(
            left: 6,
            right: 10,
          ),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          title: FormSectionHeader(
            label: title,
            pathPrefix: path,
            padding: 0,
            isVerified: isVerified,
          ),
          children: children,
        ),
      ),
    );
  }
}
