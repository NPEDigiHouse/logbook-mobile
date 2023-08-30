import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/assessment/list_scientific_assignment.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/clip_donut_painter.dart';
import 'package:elogbook/src/presentation/features/students/assesment/pages/widgets/title_assesment_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class ScientificAssignmentDetail extends StatefulWidget {
  final ListScientificAssignment ss;
  const ScientificAssignmentDetail({
    super.key,
    required this.ss,
  });

  @override
  State<ScientificAssignmentDetail> createState() =>
      _ScientificAssignmentDetailState();
}

class _ScientificAssignmentDetailState
    extends State<ScientificAssignmentDetail> {
  @override
  void initState() {
    super.initState();
  }

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
            title: scoreLevel, color: Color(scoreColors[scoreLevel]!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scientific Assignment"),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<AssesmentCubit>(context)
                  .getStudentScientificAssignment(),
            ]);
          },
          child: BlocBuilder<AssesmentCubit, AssesmentState>(
            builder: (context, state) {
              print(state);
              if (state.requestState == RequestState.loading)
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              if (state.scientificAssignmentDetail != null ||
                  state.requestState == RequestState.data)
                return Builder(builder: (context) {
                  if (state.scientificAssignmentDetail!.scores!.isNotEmpty) {
                    return SingleChildScrollView(
                      child: SpacingColumn(
                        horizontalPadding: 16,
                        spacing: 12,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          TitleAssesmentCard(
                            title: state.scientificAssignmentDetail
                                    ?.listScientificAssignmentCase ??
                                'Title',
                            subtitle:
                                state.scientificAssignmentDetail?.location ??
                                    'Unknown Location',
                          ),
                          TopStatCard(
                            title: 'Scientific Assignment Statistic',
                            totalGrade: getTotalGrades(
                                state.scientificAssignmentDetail!.grade != null
                                    ? state.scientificAssignmentDetail!.grade!
                                            .toDouble() /
                                        100
                                    : 0),
                          ),
                          ...[
                            ScientificGradeCard(
                              title: 'Presentation',
                              iconPath: 'assets/icons/presentation_icon.svg',
                              saScores: state
                                  .scientificAssignmentDetail!.scores!
                                  .where((element) =>
                                      element.type ==
                                      ScientificAssignmentType.SAJIAN)
                                  .toList()
                                  .map((e) => ItemRatingSA(
                                      indicator: e.name ?? '',
                                      score: e.score ?? 0))
                                  .toList(),
                            ),
                            ScientificGradeCard(
                              title: 'Presentation Style',
                              iconPath:
                                  'assets/icons/presentation_style_icon.svg',
                              saScores: state
                                  .scientificAssignmentDetail!.scores!
                                  .where((element) =>
                                      element.type ==
                                      ScientificAssignmentType.CARA_PENYAJIAN)
                                  .toList()
                                  .map((e) => ItemRatingSA(
                                      indicator: e.name ?? '',
                                      score: e.score ?? 0))
                                  .toList(),
                            ),
                            ScientificGradeCard(
                              title: 'Discussion',
                              iconPath: 'assets/icons/discussion_icon.svg',
                              saScores: state
                                  .scientificAssignmentDetail!.scores!
                                  .where((element) =>
                                      element.type ==
                                      ScientificAssignmentType.DISKUSI)
                                  .toList()
                                  .map((e) => ItemRatingSA(
                                      indicator: e.name ?? '',
                                      score: e.score ?? 0))
                                  .toList(),
                            ),
                          ],
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: EmptyData(
                        title: 'Waiting for assessment',
                        subtitle:
                            'the supervisor has not given a value for the mini cex',
                      ),
                    );
                  }
                });
              else
                return SizedBox(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('Load Mini Cex Score'),
                      ),
                    ],
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}

class ItemRatingSA {
  final String indicator;
  final int score;

  ItemRatingSA({
    required this.indicator,
    required this.score,
  });
}

class ScientificGradeCard extends StatelessWidget {
  const ScientificGradeCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.saScores,
  });

  final List<ItemRatingSA> saScores;
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      // padding: EdgeInsets.all(12),
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
        children: [
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(iconPath),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SectionDivider(),
          SpacingColumn(
            horizontalPadding: 16,
            children: [
              for (final data in saScores)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                      ),
                      Expanded(child: Text(data.indicator)),
                      Text(
                        data.score.toString(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ItemDivider(),
            ],
          ),
        ],
      ),
    );
  }
}

class TopStatCard extends StatelessWidget {
  final String title;
  final TotalGradeHelper? totalGrade;
  const TopStatCard({
    super.key,
    required this.totalGrade,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              bottom: 0,
              left: 8,
              child: CustomPaint(
                size: Size(
                    80,
                    (80 * 1.17)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: ClipDonutPainter(),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                SectionDivider(),
                SizedBox(
                  height: 12,
                ),
                SemicircularIndicator(
                  contain: true,
                  radius: 100,
                  progress: totalGrade != null ? totalGrade!.value : 0,
                  strokeCap: StrokeCap.round,
                  color: totalGrade != null
                      ? totalGrade!.gradientScore.color
                      : onDisableColor,
                  bottomPadding: 0,
                  backgroundColor: Color(0xFFB0EAFC),
                  child: Column(
                    children: [
                      Text(
                        totalGrade != null
                            ? totalGrade!.gradientScore.title
                            : 'Unknown',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalGrade != null
                            ? 'Avg : ${(totalGrade!.value * 100).toInt().toString()}'
                            : '-',
                        style: textTheme.bodyMedium?.copyWith(
                          color: secondaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TestGradeScoreCard extends StatelessWidget {
  const TestGradeScoreCard({
    super.key,
    required this.caseName,
    required this.score,
  });

  final String caseName;
  final int score;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  caseName,
                  maxLines: 2,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              SizedBox(
                width: 35,
                child: Text(
                  score.toString(),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
