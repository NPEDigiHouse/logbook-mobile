import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/helpers/helper.dart';
import 'package:main/widgets/cards/weekly_grade_card.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_student_header.dart';

import 'weekly_grade_score_dialog.dart';
import 'package:flutter/material.dart';
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
                      if (state.weeklyAssesment!.assesments!.isNotEmpty) {
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

                                  final bool isPassed = DateTime.now().isAfter(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          grades.startDate! * 1000));

                                  return WeeklyGradeCard(
                                    startTime: grades.startDate,
                                    endTime: grades.endDate,
                                    isPassed: isPassed,
                                    totalGrade: getTotalGrades(
                                        ((grades.score ?? 0) * 100)
                                            .toDouble())!,
                                    attendNum: grades.attendNum ?? 0,
                                    notAttendNum: grades.notAttendNum ?? 0,
                                    week: grades.weekNum ?? 0,
                                    score: grades.score!.toDouble(),
                                    onTap: isPassed
                                        ? () => showDialog(
                                              context: context,
                                              barrierLabel: '',
                                              barrierDismissible: false,
                                              builder: (_) =>
                                                  WeeklyGradeScoreDialog(
                                                week: grades.weekNum ?? 0,
                                                score: grades.score!.toDouble(),
                                                id: grades.id!,
                                                activeDepartmentId: widget
                                                    .student
                                                    .activeDepartmentId!,
                                                studentId:
                                                    widget.student.studentId!,
                                              ),
                                            )
                                        : null,
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
                      }
                      return const EmptyData(
                          title: 'No Weekly Assesment',
                          subtitle:
                              'Student must be verify one or more daily activity before');
                    }
                    return const CustomLoading();
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
