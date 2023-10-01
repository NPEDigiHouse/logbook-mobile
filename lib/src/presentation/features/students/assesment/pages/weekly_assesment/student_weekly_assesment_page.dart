import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/common/no_internet/check_internet_onetime.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/cards/weekly_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

import '../../../../../widgets/dividers/section_divider.dart';
import '../widgets/clip_donut_painter.dart';

class StudentWeeklyAssementPage extends StatefulWidget {
  const StudentWeeklyAssementPage({super.key});

  @override
  State<StudentWeeklyAssementPage> createState() =>
      _StudentWeeklyAssementPageState();
}

class _StudentWeeklyAssementPageState extends State<StudentWeeklyAssementPage> {
  @override
  void initState() {
    print("object");
    // TODO: implement initState
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
          title: Text("Weekly Assignments"),
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
                print(state.weeklyAssesment);
                if (state.weeklyAssesment != null) {
                  if (state.weeklyAssesment!.assesments!.isNotEmpty) {
                    double avg = 0;
                    state.weeklyAssesment!.assesments!
                        .forEach((e) => avg += e.score!);
                    avg /= state.weeklyAssesment!.assesments!.length;
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SpacingColumn(
                            horizontalPadding: 16,
                            spacing: 12,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              // _buildAttendanceOverview(context),
                              if (state.weeklyAssesment!.assesments!.isNotEmpty)
                                TopStatCard(
                                  title: 'Total Grades',
                                  totalGrade: getTotalGrades(avg / 100),
                                ),
                              ...state.weeklyAssesment!.assesments!
                                  .map((element) {
                                return WeeklyGradeCard(
                                  totalGrade: getTotalGrades(
                                      (element.score ?? 0).toDouble() / 100)!,
                                  week: element.weekNum ?? 0,
                                  // date: 'Senin, 27 Mar 2023',
                                  // place: 'RS Unhas',
                                  attendNum: element.attendNum ?? 0,
                                  notAttendNum: element.notAttendNum ?? 0,
                                  status: element.verificationStatus!,
                                  score: element.score!.toDouble(),
                                );
                              }).toList(),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return EmptyData(
                      title: 'No Data', subtitle: 'no daily activity verified');
                }
                return CustomLoading();
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
                Builder(builder: (context) {
                  return SemicircularIndicator(
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
                        Builder(builder: (context) {
                          print(totalGrade?.value);
                          return Text(
                            totalGrade != null
                                ? 'Avg : ${(totalGrade!.value * 100).toInt().toString()}'
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

Container _buildAttendanceOverview(BuildContext context) {
  return Container(
    width: AppSize.getAppWidth(context),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.12),
          offset: Offset(0, 2),
          blurRadius: 20,
        )
      ],
      borderRadius: BorderRadius.circular(12),
      color: scaffoldBackgroundColor,
    ),
    child: Column(
      children: [
        Text(
          'Attendance Overview',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 84,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: errorColor.withOpacity(
                          .2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        AssetPath.getIcon('emoji_alfa.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '1',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text('Tidak Hadir'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F7F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 84,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(
                          .2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2),
                      child: SvgPicture.asset(
                        AssetPath.getIcon('emoji_hadir.svg'),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '1',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text('Hadir'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
