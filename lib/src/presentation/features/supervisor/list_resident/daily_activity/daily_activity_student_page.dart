import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/widgets/head_resident_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
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
      ..getDailyActivitiesBySupervisor(studentId: widget.student.studentId!);
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
                        if (state.studentDailyActivity != null)
                          return SpacingColumn(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            horizontalPadding: 16,
                            spacing: 20,
                            children: [
                              ...List.generate(
                                  state.studentDailyActivity!.weeks!.length,
                                  (index) {
                                final i = state
                                    .studentDailyActivity!.dailyActivities!
                                    .indexWhere((element) =>
                                        element.weekName ==
                                        state.studentDailyActivity!
                                            .weeks![index].weekName);
                                print(state.studentDailyActivity!.weeks![index]
                                    .toJson());
                                return DailyActivityHomeCard(
                                  studentId: widget.student.id,
                                  isSupervisor: true,
                                  startDate:
                                      DateTime.fromMillisecondsSinceEpoch(state
                                              .studentDailyActivity!
                                              .weeks![index]
                                              .startDate! *
                                          1000),
                                  status: state.studentDailyActivity!
                                          .weeks![index].status ??
                                      false,
                                  // checkInCount: 2,
                                  week:
                                      state.studentDailyActivity!.weeks![index],
                                  dailyActivity: i == -1
                                      ? null
                                      : state.studentDailyActivity!
                                          .dailyActivities![i],
                                  endDate: DateTime.fromMillisecondsSinceEpoch(
                                      state.studentDailyActivity!.weeks![index]
                                              .endDate! *
                                          1000),
                                );
                              }),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        return CustomLoading();
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
