import 'package:common/features/daily_activity/widgets/daily_activity_home_card.dart';
import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/skeleton/list_skeleton_template.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';

class DailyActivityTempModel {
  final String day;
  final String? id;
  final DateTime dateTime;
  final ActivitiesStatus? dailyActivity;

  DailyActivityTempModel(
      {required this.day, this.dailyActivity, this.id, required this.dateTime});
}

class DailyActivityPage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const DailyActivityPage({super.key, required this.activeDepartmentModel});

  @override
  State<DailyActivityPage> createState() => _DailyActivityPageState();
}

class _DailyActivityPageState extends State<DailyActivityPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DailyActivityCubit>(context).getStudentDailyActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Activity'),
      ),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<DailyActivityCubit>(context)
                  .getStudentDailyActivities(),
            ]);
          },
          child: BlocBuilder<DailyActivityCubit, DailyActivityState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DepartmentHeader(
                      unitName: widget.activeDepartmentModel.unitName!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Builder(builder: (context) {
                      if ((state.studentDailyActivity?.dailyActivities !=
                          null)) {
                        return SpacingColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 20,
                          children: [
                            ...List.generate(
                                state.studentDailyActivity!.dailyActivities!
                                    .length, (index) {
                              final endDate = state.studentDailyActivity!
                                          .dailyActivities![index].endDate !=
                                      null
                                  ? DateTime.fromMillisecondsSinceEpoch(state
                                          .studentDailyActivity!
                                          .dailyActivities![index]
                                          .endDate! *
                                      1000)
                                  : DateTime.now();
                              return DailyActivityHomeCard(
                                isSupervisor: false,
                                startDate: state
                                            .studentDailyActivity!
                                            .dailyActivities![index]
                                            .startDate !=
                                        null
                                    ? DateTime.fromMillisecondsSinceEpoch(state
                                            .studentDailyActivity!
                                            .dailyActivities![index]
                                            .startDate! *
                                        1000)
                                    : DateTime.now(),
                                endDate: endDate,
                                da: state.studentDailyActivity!
                                    .dailyActivities![index],
                                status: state.studentDailyActivity!
                                        .dailyActivities![index].status ??
                                    false,
                                dailyActivity: state.studentDailyActivity!
                                    .dailyActivities![index],
                              );
                            })
                          ],
                        );
                      }
                      return const ListSkeletonTemplate(
                        listHeight: [195, 195, 195, 195],
                        borderRadius: 12,
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}