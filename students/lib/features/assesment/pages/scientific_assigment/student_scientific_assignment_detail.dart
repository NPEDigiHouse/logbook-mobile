import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/assessment/list_scientific_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/item_divider.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:main/widgets/clip_donut_painter.dart';
import '../widgets/title_assesment_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scientific Assignment"),
      ).variant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<AssesmentCubit>(context)
                  .getStudentScientificAssignment(),
            ]);
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: BlocBuilder<AssesmentCubit, AssesmentState>(
                  builder: (context, state) {
                    if (state.requestState == RequestState.loading) {
                      return const CustomLoading();
                    }
                    if (state.scientificAssignmentDetail != null ||
                        state.requestState == RequestState.data) {
                      return SingleChildScrollView(
                        child: SpacingColumn(
                          horizontalPadding: 16,
                          spacing: 12,
                          children: [
                            const SizedBox(
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
                            Builder(builder: (context) {
                              if (state.scientificAssignmentDetail!.scores!
                                  .isNotEmpty) {
                                return SpacingColumn(spacing: 12, children: [
                                  TopStatCard(
                                    title: 'Scientific Assignment Statistic',
                                    totalGrade: getTotalGrades(state
                                                .scientificAssignmentDetail!
                                                .grade !=
                                            null
                                        ? state
                                            .scientificAssignmentDetail!.grade!
                                            .toDouble()
                                        : 0),
                                  ),
                                  ...[
                                    ScientificGradeCard(
                                      title: 'Presentation',
                                      iconPath:
                                          'assets/icons/presentation_icon.svg',
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
                                              ScientificAssignmentType
                                                  .CARA_PENYAJIAN)
                                          .toList()
                                          .map((e) => ItemRatingSA(
                                              indicator: e.name ?? '',
                                              score: e.score ?? 0))
                                          .toList(),
                                    ),
                                    ScientificGradeCard(
                                      title: 'Discussion',
                                      iconPath:
                                          'assets/icons/discussion_icon.svg',
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
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ]);
                              } else {
                                return const Center(
                                  child: EmptyData(
                                    title: 'Waiting for assessment',
                                    subtitle:
                                        'the supervisor has not given a value for the scientific assesment',
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Text('Load Scientific Assesment'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
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
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(iconPath),
                const SizedBox(
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
          const SizedBox(
            height: 12,
          ),
          const SectionDivider(),
          SpacingColumn(
            horizontalPadding: 16,
            children: [
              for (final data in saScores)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
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
              const ItemDivider(),
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
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const SectionDivider(),
                const SizedBox(
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
                  backgroundColor: const Color(0xFFB0EAFC),
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
                const SizedBox(
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
      constraints: const BoxConstraints(
        minHeight: 65,
      ),
      child: Container(
        width: AppSize.getAppWidth(context),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: const Color(0xFFD4D4D4).withOpacity(.25),
            ),
            BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: const Color(0xFFD4D4D4).withOpacity(.25),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(
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
              const SizedBox(
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
