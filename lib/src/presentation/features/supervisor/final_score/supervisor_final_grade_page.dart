import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/input_score_modal.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/top_stat_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorFinalGrade extends StatefulWidget {
  final StudentDepartmentModel finalGrade;

  const SupervisorFinalGrade({super.key, required this.finalGrade});

  @override
  State<SupervisorFinalGrade> createState() => _SupervisorFinalGradeState();
}

class _SupervisorFinalGradeState extends State<SupervisorFinalGrade> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)
      ..getFinalScore(
          unitId: widget.finalGrade.activeDepartmentId ?? '',
          studentId: widget.finalGrade.studentId!);
  }

  final Map<String, String> mapTitle = {
    'CBT': 'CBT Test',
    'SCIENTIFIC_ASSESMENT': 'Case Report',
    'PERSONAL_BEHAVIOUR': 'Personal Behavior',
    'MINI_CEX': 'Mini-CEX',
    'OSCE': 'OSCE Test',
  };

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
    if (grades * 100 >= 85) {
      scoreLevel = 'A';
    } else if (grades * 100 >= 80) {
      scoreLevel = 'A-';
    } else if (grades * 100 > 75) {
      scoreLevel = 'B+';
    } else if (grades * 100 > 70) {
      scoreLevel = 'B';
    } else if (grades * 100 > 65) {
      scoreLevel = 'B-';
    } else if (grades * 100 >= 60) {
      scoreLevel = 'C+';
    } else if (grades * 100 >= 50) {
      scoreLevel = 'C';
    } else if (grades * 100 >= 40) {
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
      appBar: AppBar(
        title: Text("Final Grade"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context).getFinalScore(
                unitId: widget.finalGrade.activeDepartmentId!,
                studentId: widget.finalGrade.studentId!)
          ]);
        },
        child: BlocConsumer<AssesmentCubit, AssesmentState>(
          listener: (context, state) {
            if (state.isSubmitFinalScoreSuccess) {
              BlocProvider.of<AssesmentCubit>(context)
                ..getFinalScore(
                    unitId: widget.finalGrade.activeDepartmentId ?? '',
                    studentId: widget.finalGrade.studentId!);
            }
          },
          builder: (context, state) {
            if (state.finalScore != null) {
              return SingleChildScrollView(
                child: SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 6,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                          BoxShadow(
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                              blurRadius: 24,
                              color: Color(0xFFD4D4D4).withOpacity(.25)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Name',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            widget.finalGrade.studentName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Student Id',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            widget.finalGrade.studentId ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Department',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            widget.finalGrade.activeDepartmentName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    FinalGradeTopStatCard(
                      title: 'Final Grade Statistic',
                      totalGrade:
                          getTotalGrades(state.finalScore!.finalScore ?? 0),
                    ),
                    if (state.finalScore!.assesments != null) ...[
                      for (int i = 0;
                          i < state.finalScore!.assesments!.length;
                          i++)
                        Builder(builder: (context) {
                          if (state.finalScore!.assesments![i].type!
                                  .contains('OSCE') &&
                              (widget.finalGrade.activeDepartmentName!
                                      .toUpperCase()
                                      .contains('FORENSIK') ||
                                  widget.finalGrade.activeDepartmentName
                                          ?.toUpperCase() ==
                                      'IKM-IKK')) {
                            return SizedBox.shrink();
                          }
                          return FinalGradeScoreCard(
                            type: mapTitle[
                                    state.finalScore!.assesments![i].type] ??
                                '-',
                            score: state.finalScore!.assesments![i].score ?? -1,
                            proportion:
                                state.finalScore!.assesments![i].weight ?? 0,
                          );
                        }),
                    ],
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: primaryColor),
                              onPressed: () {
                                print(state.finalScore!.assesments.toString());
                                showDialog(
                                  context: context,
                                  barrierLabel: '',
                                  barrierDismissible: false,
                                  builder: (_) => InputFinalScoreDialog(
                                    studentId: widget.finalGrade.studentId!,
                                    unitId:
                                        widget.finalGrade.activeDepartmentId!,
                                    type: FinalScoreType.cbt,
                                    initScore: state.finalScore!.assesments!
                                                .indexWhere((element) => element
                                                    .type!
                                                    .contains("CBT")) !=
                                            -1
                                        ? state.finalScore!.assesments!
                                                .firstWhere((element) => element
                                                    .type!
                                                    .contains("CBT"))
                                                .score ??
                                            0
                                        : 0,
                                  ),
                                );
                              },
                              child: Text('Update CBT')),
                        ),
                        if (!(widget.finalGrade.activeDepartmentName!
                                .toUpperCase()
                                .contains('FORENSIK') ||
                            widget.finalGrade.activeDepartmentName!
                                    .toUpperCase() ==
                                'IKM-IKK')) ...[
                          SizedBox(
                            width: 4,
                          ),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                  backgroundColor: primaryColor),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierLabel: '',
                                  barrierDismissible: false,
                                  builder: (_) => InputFinalScoreDialog(
                                    studentId: widget.finalGrade.studentId!,
                                    unitId:
                                        widget.finalGrade.activeDepartmentId!,
                                    type: FinalScoreType.osce,
                                    initScore: state.finalScore!.assesments!
                                                .indexWhere((element) => element
                                                    .type!
                                                    .contains("OSCE")) !=
                                            -1
                                        ? state.finalScore!.assesments!
                                                .firstWhere((element) => element
                                                    .type!
                                                    .contains("OSCE"))
                                                .score ??
                                            0
                                        : 0,
                                  ),
                                );
                              },
                              child: Text('Update OSCE')),
                        ],
                      ],
                    ),
                    if (state.finalScore!.assesments
                            ?.indexWhere((element) => element.score == null) ==
                        -1)
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: Builder(builder: (context) {
                          if (!state.finalScore!.verified!) {
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: variant2Color,
                              ),
                              onPressed: () {
                                BlocProvider.of<AssesmentCubit>(context)
                                  ..submitFinalScore(
                                      studentId: widget.finalGrade.studentId!,
                                      unitId:
                                          widget.finalGrade.activeDepartmentId!,
                                      status: true);
                              },
                              child: Text('Submit Final Score'),
                            );
                          } else {
                            return OutlinedButton(
                              onPressed: () {
                                print("va");
                                BlocProvider.of<AssesmentCubit>(context)
                                  ..submitFinalScore(
                                      studentId: widget.finalGrade.studentId!,
                                      unitId:
                                          widget.finalGrade.activeDepartmentId!,
                                      status: false);
                              },
                              child: Text('Cancel Submit'),
                            );
                          }
                        }),
                      ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              );
            }
            return CustomLoading();
          },
        ),
      ),
    );
  }
}

class FinalGradeScoreCard extends StatelessWidget {
  const FinalGradeScoreCard({
    super.key,
    required this.type,
    required this.score,
    this.proportion,
  });

  final String type;
  final double? proportion;

  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: Text(
                          type,
                          style: textTheme.titleMedium?.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: proportion != null
                              ? Color(0xFF219ABF)
                              : scaffoldBackgroundColor,
                          border: proportion != null
                              ? null
                              : Border.all(
                                  width: 1,
                                  color: secondaryColor,
                                ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          proportion != 0
                              ? '${(proportion! * 100).toInt()}%'
                              : 'Formatif',
                          style: textTheme.labelSmall?.copyWith(
                            color: proportion != null
                                ? scaffoldBackgroundColor
                                : secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (score == -1)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'The student has not yet taken this exam',
                        style: textTheme.bodySmall?.copyWith(
                          height: 1,
                          color: onFormDisableColor,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (score != -1) ...[
              SectionDivider(
                isVertical: true,
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Score',
                      style: textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    Text(
                      score.toStringAsFixed(0),
                      style: textTheme.headlineSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
