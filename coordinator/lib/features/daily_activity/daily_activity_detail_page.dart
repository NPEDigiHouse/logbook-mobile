import 'package:common/features/daily_activity/widgets/daily_activity_home_card.dart';
import 'package:coordinator/features/daily_activity/add_week_dialog.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/headers/unit_student_header.dart';
import 'package:main/widgets/spacing_column.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/widgets/verify_dialog.dart';

class DailyActivityDetailPage extends StatefulWidget {
  final StudentDepartmentModel student;

  const DailyActivityDetailPage({super.key, required this.student});

  @override
  State<DailyActivityDetailPage> createState() =>
      _DailyActivityDetailPageState();
}

class _DailyActivityDetailPageState extends State<DailyActivityDetailPage> {
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();

    BlocProvider.of<DailyActivityCubit>(context)
        .getDailyActivitiesBySupervisor(studentId: widget.student.studentId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyActivityCubit, DailyActivityState>(
      listener: (context, state) {
        if (state.isEditStatusWeek ||
            state.isDelete == RequestState.data ||
            state.isSync == RequestState.data) {
          BlocProvider.of<DailyActivityCubit>(context)
              .getDailyActivitiesBySupervisor(
                  studentId: widget.student.studentId!);
        }
      },
      builder: (context, state) {
        final bool init = state.studentDailyActivity != null &&
            state.studentDailyActivity?.dailyActivities != null &&
            state.studentDailyActivity!.dailyActivities!.isNotEmpty;
        final DateTime endDate = init
            ? DateTime.fromMillisecondsSinceEpoch(
                state.studentDailyActivity?.dailyActivities?.last.endDate ?? 0)
            : DateTime.now();
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierLabel: '',
                barrierDismissible: false,
                builder: (_) => AddWeekDialog(
                  endDate: endDate,
                  weekNum: init
                      ? (state.studentDailyActivity!.dailyActivities!.last
                                  .weekName ??
                              0) +
                          1
                      : 1,
                  studentId: widget.student.id,
                  studentStudentId: widget.student.studentId,
                ),
              );
            },
            child: const Icon(Icons.add_rounded),
          ),
          appBar: AppBar(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  BlocProvider.of<DailyActivityCubit>(context)
                      .getDailyActivitiesBySupervisor(
                          studentId: widget.student.studentId!)
                ]);
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Builder(
                          builder: (context) {
                            if (state.isSync == RequestState.loading ||
                                state.requestState == RequestState.loading) {
                              return const CustomLoading();
                            }
                            if (state.studentDailyActivity != null) {
                              return SpacingColumn(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                horizontalPadding: 16,
                                spacing: 20,
                                children: [
                                  StudentDepartmentHeader(
                                      unitName:
                                          widget.student.activeDepartmentName ??
                                              '',
                                      studentName:
                                          widget.student.studentName ?? '',
                                      studentId:
                                          widget.student.studentId ?? ''),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Daily Activity',
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: FilledButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierLabel: '',
                                              barrierDismissible: false,
                                              builder: (_) => VerifyDialog(
                                                onTap: () {
                                                  context
                                                      .read<
                                                          DailyActivityCubit>()
                                                      .syncDailyActivity(
                                                          studentId: widget
                                                              .student
                                                              .studentId!);
                                                },
                                              ),
                                            );
                                          },
                                          style: FilledButton.styleFrom(
                                              backgroundColor: secondaryColor),
                                          icon: const Icon(
                                            Icons.sync,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'Sync',
                                            style: textTheme.titleSmall
                                                ?.copyWith(
                                                    color:
                                                        scaffoldBackgroundColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (state.studentDailyActivity
                                          ?.dailyActivities !=
                                      null)
                                    ...List.generate(
                                        state.studentDailyActivity!
                                            .dailyActivities!.length, (index) {
                                      final i = state.studentDailyActivity!
                                          .dailyActivities!
                                          .indexWhere((element) =>
                                              element.weekName ==
                                              state
                                                  .studentDailyActivity!
                                                  .dailyActivities![index]
                                                  .weekName);

                                      return DailyActivityHomeCard(
                                        isCoordinator: true,
                                        studentId: widget.student.id,
                                        isSupervisor: true,
                                        startDate: DateTime
                                            .fromMillisecondsSinceEpoch((state
                                                        .studentDailyActivity!
                                                        .dailyActivities![index]
                                                        .startDate ??
                                                    0) *
                                                1000),
                                        activeStatus: state
                                                .studentDailyActivity!
                                                .dailyActivities![index]
                                                .status ??
                                            false,
                                        status: state
                                                .studentDailyActivity!
                                                .dailyActivities![index]
                                                .status ??
                                            false,
                                        // checkInCount: 2,
                                        da: state.studentDailyActivity!
                                            .dailyActivities![index],
                                        dailyActivity: i == -1
                                            ? null
                                            : state.studentDailyActivity!
                                                .dailyActivities![i],
                                        endDate: DateTime
                                            .fromMillisecondsSinceEpoch((state
                                                        .studentDailyActivity!
                                                        .dailyActivities![index]
                                                        .endDate ??
                                                    0) *
                                                1000),
                                      );
                                    }),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              );
                            }
                            return const CustomLoading();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
