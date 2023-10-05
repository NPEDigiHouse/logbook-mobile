import 'package:elogbook/src/data/models/supervisors/student_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/weekly_grade_score_dialog.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/widgets/cards/weekly_grade_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_student_header.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyGradeDetailPage extends StatefulWidget {
  final StudentDepartmentModel student;

  const WeeklyGradeDetailPage({super.key, required this.student});

  @override
  State<WeeklyGradeDetailPage> createState() => _WeeklyGradeDetailPageState();
}

class _WeeklyGradeDetailPageState extends State<WeeklyGradeDetailPage> {
  @override
  void initState() {
    BlocProvider.of<AssesmentCubit>(context)
      ..reset()
      ..getWeeklyAssesment(
          studentId: widget.student.studentId!,
          unitId: widget.student.activeDepartmentId!);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    if (grades >= 85) {
      scoreLevel = 'A';
    } else if (grades >= 80) {
      scoreLevel = 'A-';
    } else if (grades > 75) {
      scoreLevel = 'B+';
    } else if (grades > 70) {
      scoreLevel = 'B';
    } else if (grades > 65) {
      scoreLevel = 'B-';
    } else if (grades >= 60) {
      scoreLevel = 'C+';
    } else if (grades >= 50) {
      scoreLevel = 'C';
    } else if (grades >= 40) {
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
      appBar: AppBar(),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppSize.getAppHeight(context),
        ),
        child: RefreshIndicator(
          onRefresh: () => Future.wait([
            BlocProvider.of<AssesmentCubit>(context).getWeeklyAssesment(
                studentId: widget.student.studentId!,
                unitId: widget.student.activeDepartmentId!),
          ]),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<AssesmentCubit, AssesmentState>(
                  builder: (context, state) {
                    if (state.weeklyAssesment != null) {
                      if (state.weeklyAssesment!.assesments!.isNotEmpty)
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              StudentDepartmentHeader(
                                  unitName:
                                      widget.student.activeDepartmentName ?? '',
                                  studentName: widget.student.studentName ?? '',
                                  studentId: widget.student.studentId ?? ''),
                              const SizedBox(height: 16),
                              Text(
                                'Weekly Assesments',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (_, i) {
                                  final grades =
                                      state.weeklyAssesment!.assesments![i];
                                  return WeeklyGradeCard(
                                    startTime: grades.startDate,
                                    endTime: grades.endDate,
                                    totalGrade: getTotalGrades(
                                        (grades.score ?? 0).toDouble())!,
                                    attendNum: grades.attendNum ?? 0,
                                    notAttendNum: grades.notAttendNum ?? 0,
                                    week: grades.weekNum ?? 0,
                                    score: grades.score!.toDouble(),
                                    onTap: () => showDialog(
                                      context: context,
                                      barrierLabel: '',
                                      barrierDismissible: false,
                                      builder: (_) => WeeklyGradeScoreDialog(
                                        week: grades.weekNum ?? 0,
                                        score: grades.score!.toDouble(),
                                        id: grades.id!,
                                        activeDepartmentId:
                                            widget.student.activeDepartmentId!,
                                        studentId: widget.student.studentId!,
                                      ),
                                    ),
                                    status: grades.verificationStatus ?? '',
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemCount:
                                    state.weeklyAssesment!.assesments!.length,
                              ),
                            ],
                          ),
                        );
                      return EmptyData(
                          title: 'No Weekly Assesment',
                          subtitle:
                              'Student must be verify one or more daily activity before');
                    }
                    return CustomLoading();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
