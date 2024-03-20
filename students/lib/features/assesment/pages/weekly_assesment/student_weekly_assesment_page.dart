import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/cards/weekly_grade_card.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:main/widgets/clip_donut_painter.dart';

class StudentWeeklyAssementPage extends StatefulWidget {
  final bool isAlreadyCheckOut;
  const StudentWeeklyAssementPage({super.key, this.isAlreadyCheckOut = false});

  @override
  State<StudentWeeklyAssementPage> createState() =>
      _StudentWeeklyAssementPageState();
}

class _StudentWeeklyAssementPageState extends State<StudentWeeklyAssementPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        BlocProvider.of<AssesmentCubit>(context)..getStudentWeeklyAssesment());
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
          title: const Text("Weekly Assignments"),
        ).variant(),
        body: CheckInternetOnetime(child: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<AssesmentCubit>(context)
                    .getStudentWeeklyAssesment(),
              ]);
            },
            child: BlocBuilder<AssesmentCubit, AssesmentState>(
              builder: (context, state) {
                if (state.weeklyAssesment != null) {
                  if (state.weeklyAssesment!.assesments!.isNotEmpty) {
                    double avg = 0;
                    for (var e in state.weeklyAssesment!.assesments!) {
                      avg += e.score!;
                    }
                    avg /= state.weeklyAssesment!.assesments!.length;
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SpacingColumn(
                            horizontalPadding: 16,
                            spacing: 12,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              // _buildAttendanceOverview(context),
                              if (state.weeklyAssesment!.assesments!.isNotEmpty)
                                TopStatCard(
                                  title: 'Total Grades',
                                  totalGrade: getTotalGrades(avg),
                                ),
                              ...state.weeklyAssesment!.assesments!
                                  .map((element) {
                                if (element.startDate == null ||
                                    !(element.startDate! > 0)) {
                                  return const SizedBox.shrink();
                                }
                                final bool isPassed = !(DateTime.now().isBefore(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        (element.startDate ?? 0))));
                                return WeeklyGradeCard(
                                  isAlreadyCheckout: widget.isAlreadyCheckOut,
                                  startTime: element.startDate,
                                  endTime: element.endDate,
                                  isPassed: isPassed,
                                  totalGrade: getTotalGrades(
                                      (element.score ?? 0).toDouble())!,
                                  week: element.weekNum ?? 0,
                                  isStudent: true,
                                  // date: 'Senin, 27 Mar 2023',
                                  // place: 'RS Unhas',
                                  attendNum: element.attendNum ?? 0,
                                  notAttendNum: element.notAttendNum ?? 0,
                                  status: element.verificationStatus!,
                                  score: element.score!.toDouble(),
                                );
                              }).toList(),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const EmptyData(
                      title: 'No Data', subtitle: 'no daily activity verified');
                }
                return const CustomLoading();
              },
            ),
          );
        }));
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
                Builder(builder: (context) {
                  return SemicircularIndicator(
                    contain: true,
                    radius: 100,
                    progress: totalGrade != null ? totalGrade!.value / 100 : 0,
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
                        Builder(builder: (context) {
                          return Text(
                            totalGrade != null
                                ? 'Avg : ${totalGrade!.value.toStringAsFixed(2)}'
                                : '-',
                            style: textTheme.bodyMedium?.copyWith(
                              color: secondaryColor,
                            ),
                          );
                        })
                      ],
                    ),
                  );
                }),
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
