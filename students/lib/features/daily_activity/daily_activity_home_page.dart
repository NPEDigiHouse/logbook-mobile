import 'package:common/features/daily_activity/widgets/daily_activity_home_card.dart';
import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/skeleton/list_skeleton_template.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/spacing_column.dart';

class DailyActivityTempModel {
  final String day;
  final String? id;
  final DateTime dateTime;
  final ActivitiesStatus? dailyActivity;

  DailyActivityTempModel({
    required this.day,
    this.dailyActivity,
    this.id,
    required this.dateTime,
  });
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
    return BlocConsumer<DailyActivityCubit, DailyActivityState>(
        listenWhen: (previous, current) =>
            current.fetchState == RequestState.error &&
            current.errorMessage != null,
        listener: (context, state) {
          CustomAlert.error(message: state.errorMessage!, context: context);
        },
        builder: (context, state) {
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
                child: SingleChildScrollView(
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
                      Container(
                        width: AppSize.getAppWidth(context),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.12),
                              offset: const Offset(0, 2),
                              blurRadius: 20,
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                          color: scaffoldBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Overview',
                                  style: textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F7F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 84,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: variant2Color.withOpacity(
                                                .2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(
                                              Icons.hourglass_top_rounded,
                                              color: variant2Color,
                                              size: 12,
                                            )),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${state.studentDailyActivity?.inprocessDailyActivity ?? '...'}',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                        const Text('Pending'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F7F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 84,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: secondaryColor.withOpacity(
                                              .2,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          child: const Icon(
                                            Icons.verified_rounded,
                                            color: secondaryColor,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${state.studentDailyActivity?.verifiedDailyActivity ?? '...'}',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                        ),
                                        const Text('Verified'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Builder(builder: (context) {
                        if (state.fetchState == RequestState.loading) {
                          const ListSkeletonTemplate(
                            listHeight: [195, 195, 195, 195],
                            borderRadius: 12,
                          );
                        }
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
                                            .endDate!
                                            .toInt() *
                                        1000)
                                    : DateTime.now();
                                return DailyActivityHomeCard(
                                  isSupervisor: false,
                                  startDate: state
                                              .studentDailyActivity!
                                              .dailyActivities![index]
                                              .startDate !=
                                          null
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                          state
                                                  .studentDailyActivity!
                                                  .dailyActivities![index]
                                                  .startDate!
                                                  .toInt() *
                                              1000)
                                      : DateTime.now(),
                                  endDate: endDate,
                                  activeStatus: state.studentDailyActivity!
                                          .dailyActivities![index].status ??
                                      false,
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
                ),
              );
            }),
          );
        });
  }
}
