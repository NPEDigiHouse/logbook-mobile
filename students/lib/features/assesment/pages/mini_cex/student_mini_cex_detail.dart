import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/dividers/section_divider.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';
import 'package:main/widgets/clip_donut_painter.dart';

class StudentMiniCexDetail extends StatefulWidget {
  final String id;
  const StudentMiniCexDetail({
    super.key,
    required this.id,
  });

  @override
  State<StudentMiniCexDetail> createState() => _StudentMiniCexDetailState();
}

class _StudentMiniCexDetailState extends State<StudentMiniCexDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssesmentCubit, AssesmentState>(
      builder: (context, state) {
        if (state.requestState == RequestState.loading) {
          return const SizedBox(
            height: 300,
            child: CustomLoading(),
          );
        }
        if (state.miniCexStudentDetail != null ||
            state.requestState == RequestState.data) {
          return Builder(builder: (context) {
            if (state.miniCexStudentDetail!.scores!.isNotEmpty) {
              return SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  TopStatCard(
                    title: 'Total Grades',
                    totalGrade:
                        getTotalGrades(state.miniCexStudentDetail!.grade!),
                  ),
                  ...List.generate(
                    state.miniCexStudentDetail!.scores!.length,
                    (index) => TestGradeScoreCard(
                        caseName:
                            state.miniCexStudentDetail!.scores![index].name ??
                                '',
                        score:
                            state.miniCexStudentDetail!.scores![index].score ??
                                0),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            } else {
              return const Center(
                child: EmptyData(
                  title: 'Waiting for assessment',
                  subtitle:
                      'the supervisor has not given a value for the mini cex',
                ),
              );
            }
          });
        } else {
          return SizedBox(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                OutlinedButton(
                  onPressed: () => BlocProvider.of<AssesmentCubit>(context)
                    ..getMiniCexStudentDetail(
                      id: widget.id,
                    ),
                  child: const Text('Load Mini Cex Score'),
                ),
              ],
            ),
          );
        }
      },
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
