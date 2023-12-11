import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:main/widgets/top_stat_card.dart';

class StudentFinalScorePage extends StatefulWidget {
  final String departmentName;
  const StudentFinalScorePage({
    super.key,
    required this.departmentName,
  });

  @override
  State<StudentFinalScorePage> createState() => _StudentFinalScorePageState();
}

class _StudentFinalScorePageState extends State<StudentFinalScorePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssesmentCubit>(context).getStudentFinalScore();
  }

  final Map<String, String> mapTitle = {
    'CBT': 'CBT Test',
    'SCIENTIFIC_ASSESMENT': 'Case Report',
    'PERSONAL_BEHAVIOUR': 'Personal Behavior',
    'MINI_CEX': 'Mini-CEX',
    'OSCE': 'OSCE Test',
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Grade"),
      ).variant(),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
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
                      child: Builder(builder: (context) {
                        if (state.finalScore?.finalScore != null) {
                          return SpacingColumn(
                            horizontalPadding: 16,
                            spacing: 12,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              FinalGradeTopStatCard(
                                title: 'Final Grade Statistic',
                                totalGrade: getTotalGrades(
                                    state.finalScore!.finalScore ?? 0),
                              ),
                              if (state.finalScore!.assesments != null) ...[
                                for (int i = 0;
                                    i < state.finalScore!.assesments!.length;
                                    i++)
                                  Builder(
                                    builder: (context) {
                                      if (state.finalScore!.assesments![i].type!
                                              .contains('OSCE') &&
                                          (widget.departmentName
                                                  .toUpperCase()
                                                  .contains('FORENSIK') ||
                                              widget.departmentName
                                                      .toUpperCase() ==
                                                  'IKM-IKK')) {
                                        return const SizedBox.shrink();
                                      }
                                      return FinalGradeScoreCard(
                                        type: mapTitle[state.finalScore!
                                                .assesments![i].type] ??
                                            '-',
                                        score: state.finalScore!.assesments![i]
                                                .score ??
                                            0,
                                        proportion: state.finalScore!
                                                .assesments![i].weight ??
                                            0,
                                      );
                                    },
                                  ),
                              ],
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }
                        return const EmptyData(
                            title: 'No Final Score Data',
                            subtitle:
                                'Final score has not been processed by CEU');
                      }),
                    );
                  }
                  return const SliverToBoxAdapter(child: CustomLoading());
                },
              ),
            ],
          ),
        );
      }),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
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
                        constraints: const BoxConstraints(
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
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: proportion != null
                              ? const Color(0xFF219ABF)
                              : scaffoldBackgroundColor,
                          border: proportion != null
                              ? null
                              : Border.all(
                                  width: 1,
                                  color: secondaryColor,
                                ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
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
                  const SizedBox(
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
            const SectionDivider(
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
