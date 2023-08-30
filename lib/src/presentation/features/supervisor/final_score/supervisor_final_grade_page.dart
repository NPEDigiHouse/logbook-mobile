import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/input_score_modal.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/top_stat_card.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorFinalGrade extends StatefulWidget {
  final StudentUnitModel finalGrade;
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
          unitId: widget.finalGrade.activeUnitId!,
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
      'B+': 0xFF7AB28C,
      'B': 0xFF9FAE78,
      'B-': 0xFFC4A763,
      'C+': 0xFFE8A04E,
      'C': 0xFFFFCB51,
      'C-': 0xFFE79D6B,
      'D': 0xFFC28B86,
      'E': 0xFFD1495B,
    };
    String scoreLevel;
    if (grades * 100 >= 90) {
      scoreLevel = 'A';
    } else if (grades * 100 >= 85) {
      scoreLevel = 'B+';
    } else if (grades * 100 >= 80) {
      scoreLevel = 'B';
    } else if (grades * 100 >= 75) {
      scoreLevel = 'B-';
    } else if (grades * 100 >= 70) {
      scoreLevel = 'C+';
    } else if (grades * 100 >= 65) {
      scoreLevel = 'C';
    } else if (grades * 100 >= 60) {
      scoreLevel = 'C-';
    } else if (grades * 100 >= 55) {
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
                unitId: widget.finalGrade.activeUnitId!,
                studentId: widget.finalGrade.studentId!)
          ]);
        },
        child: BlocBuilder<AssesmentCubit, AssesmentState>(
          builder: (context, state) {
            if (state.finalScore != null)
              return SingleChildScrollView(
                child: SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
                    SizedBox(
                      height: 16,
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
                        FinalGradeScoreCard(
                          type:
                              mapTitle[state.finalScore!.assesments![i].type] ??
                                  '-',
                          score: state.finalScore!.assesments![i].score ?? 0,
                          proportion:
                              state.finalScore!.assesments![i].weight ?? 0,
                        ),
                    ],
                    SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => InputFinalScoreDialog(
                                studentId: widget.finalGrade.studentId!,
                                unitId: widget.finalGrade.activeUnitId!,
                                type: FinalScoreType.cbt,
                                initScore: state.finalScore!.assesments!
                                        .firstWhere(
                                            (element) => element.type == 'CBT')
                                        .score ??
                                    0,
                              ),
                            );
                          },
                          child: Text('Update CBT Score')),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: secondaryColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => InputFinalScoreDialog(
                                studentId: widget.finalGrade.studentId!,
                                unitId: widget.finalGrade.activeUnitId!,
                                type: FinalScoreType.osce,
                                initScore: state.finalScore!.assesments!
                                        .firstWhere(
                                            (element) => element.type == 'OSCE')
                                        .score ??
                                    0,
                              ),
                            );
                          },
                          child: Text('Update OSCE Score')),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              );
            return Center(
              child: CircularProgressIndicator(),
            );
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
                    height: 12,
                  ),
                  // Text(
                  //   'Exam date',
                  //   style: textTheme.bodySmall?.copyWith(
                  //     color: primaryTextColor,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Text(
                  //   date,
                  //   style: textTheme.bodySmall?.copyWith(
                  //     color: secondaryTextColor,
                  //   ),
                  // ),
                ],
              ),
            ),
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
            )
          ],
        ),
      ),
    );
  }
}
