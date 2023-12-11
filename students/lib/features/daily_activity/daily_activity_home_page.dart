import 'package:common/features/daily_activity/widgets/daily_activity_home_card.dart';
import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
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
              if (state.studentDailyActivity != null) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SpacingColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    horizontalPadding: 16,
                    spacing: 20,
                    children: [
                      DepartmentHeader(
                        unitName: widget.activeDepartmentModel.unitName!,
                      ),
                      ...List.generate(
                          state.studentDailyActivity!.weeks!.length, (index) {
                        final i = state.studentDailyActivity!.dailyActivities!
                            .indexWhere((element) =>
                                element.weekName ==
                                state.studentDailyActivity!.weeks![index]
                                    .weekName);

                        final endDate = DateTime.fromMillisecondsSinceEpoch(
                            state.studentDailyActivity!.weeks![index].endDate! *
                                1000);
                        return DailyActivityHomeCard(
                          isSupervisor: false,
                          startDate: DateTime.fromMillisecondsSinceEpoch(state
                                  .studentDailyActivity!
                                  .weeks![index]
                                  .startDate! *
                              1000),
                          endDate: endDate,
                          week: state.studentDailyActivity!.weeks![index],
                          status: state
                                  .studentDailyActivity!.weeks![index].status ??
                              false,
                          // checkInCount:
                          //     widget.activeDepartmentModel.countCheckIn!,
                          dailyActivity: i == -1
                              ? null
                              : state.studentDailyActivity!.dailyActivities![i],
                        );
                      })
                    ],
                  ),
                );
              }
              return const CustomLoading();
            },
          ),
        );
      }),
    );
  }
}
