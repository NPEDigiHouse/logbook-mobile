import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/final_score/widgets/top_stat_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailFinalScorePage extends StatefulWidget {
  const StudentDetailFinalScorePage({
    super.key,
  });

  @override
  State<StudentDetailFinalScorePage> createState() =>
      _StudentDetailFinalScorePageState();
}

class _StudentDetailFinalScorePageState
    extends State<StudentDetailFinalScorePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context)..getStudentFinalScore();
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
            BlocProvider.of<AssesmentCubit>(context).getStudentFinalScore(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            BlocBuilder<AssesmentCubit, AssesmentState>(
              builder: (context, state) {
                if (state.finalScore != null) {
                  return SliverToBoxAdapter(
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
                            Builder(builder: (context) {
                              if (state.finalScore!.assesments![i].type!
                                      .contains('OSCE') &&
                                  state.finalScore!.assesments![i].score ==
                                      null) {
                                return SizedBox.shrink();
                              }
                              return FinalGradeScoreCard(
                                type: mapTitle[state
                                        .finalScore!.assesments![i].type] ??
                                    '-',
                                score: state.finalScore!.assesments![i].score ??
                                    -1,
                                proportion:
                                    state.finalScore!.assesments![i].weight ??
                                        0,
                              );
                            }),
                        ],
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  );
                }
                return CustomLoading();
              },
            ),
          ],
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
            ]
          ],
        ),
      ),
    );
  }
}
