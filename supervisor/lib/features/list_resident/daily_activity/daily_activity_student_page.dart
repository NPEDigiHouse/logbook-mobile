import 'package:common/features/daily_activity/widgets/daily_activity_home_card.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/spacing_column.dart';

import '../widgets/head_resident_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyActivityTempModel {
  final String day;
  final String? id;
  final DateTime dateTime;
  final ActivitiesStatus? dailyActivity;

  DailyActivityTempModel(
      {required this.day, this.dailyActivity, this.id, required this.dateTime});
}

class DailyActivityStudentPage extends StatefulWidget {
  final SupervisorStudent student;
  const DailyActivityStudentPage({super.key, required this.student});

  @override
  State<DailyActivityStudentPage> createState() =>
      _DailyActivityStudentPageState();
}

class _DailyActivityStudentPageState extends State<DailyActivityStudentPage> {
  late ScrollController _scrollController;
  final ValueNotifier<String> title = ValueNotifier('Entry Details');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 160) {
        title.value = 'Entry Details';
      } else if (_scrollController.position.pixels >= 160) {
        title.value = widget.student.studentId ?? '';
      }
    });
    BlocProvider.of<DailyActivityCubit>(context)
        .getDailyActivitiesBySupervisor(studentId: widget.student.studentId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            controller: _scrollController,
            slivers: [
              ...getHeadSection(
                  title: title,
                  subtitle: 'Daily Activity',
                  student: widget.student),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    BlocBuilder<DailyActivityCubit, DailyActivityState>(
                      builder: (context, state) {
                        if (state.studentDailyActivity != null) {
                          return SpacingColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            horizontalPadding: 16,
                            spacing: 20,
                            children: [
                              if (state.studentDailyActivity?.dailyActivities !=
                                  null)
                                ...List.generate(
                                    state.studentDailyActivity!.dailyActivities!
                                        .length, (index) {
                                  final i = state
                                      .studentDailyActivity!.dailyActivities!
                                      .indexWhere((element) =>
                                          element.weekName ==
                                          state
                                              .studentDailyActivity!
                                              .dailyActivities![index]
                                              .weekName);
                                  return DailyActivityHomeCard(
                                    studentId: widget.student.id,
                                    isSupervisor: true,
                                    startDate:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            (state
                                                        .studentDailyActivity!
                                                        .dailyActivities![index]
                                                        .startDate ??
                                                    0) *
                                                1000),
                                    status: state.studentDailyActivity!
                                            .dailyActivities![index].status ??
                                        false,
                                    // checkInCount: 2,
                                    da: state.studentDailyActivity!
                                        .dailyActivities![index],
                                    dailyActivity: i == -1
                                        ? null
                                        : state.studentDailyActivity!
                                            .dailyActivities![i],
                                    endDate:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            (state
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
  }
}
