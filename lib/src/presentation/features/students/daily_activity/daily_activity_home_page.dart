import 'dart:ui';

import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/common/no_internet/check_internet_onetime.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/daily_activity_week_status_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    BlocProvider.of<DailyActivityCubit>(context)..getStudentDailyActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
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
              if (state.studentDailyActivity != null)
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16),
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
                        print(
                            state.studentDailyActivity!.weeks![index].toJson());
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
              return CustomLoading();
            },
          ),
        );
      }),
    );
  }
}

class DailyActivityHomeCard extends StatelessWidget {
  final Week week;
  final DateTime startDate;
  final DateTime endDate;
  final DailyActivity? dailyActivity;
  final bool status;
  final bool isSupervisor;
  final String? studentId;
  const DailyActivityHomeCard(
      {super.key,
      this.studentId,
      required this.status,
      required this.isSupervisor,
      required this.endDate,
      required this.startDate,
      required this.week,
      this.dailyActivity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWellContainer(
          padding: EdgeInsets.all(16),
          radius: 12,
          onTap: () {
            if (DateTime.now().isBefore(startDate)) {
              return null;
            }
            context.navigateTo(
              DailyActivityWeekStatusPage(
                week: week,
                isSupervisor: isSupervisor,
                weekName: week.weekName!,
                // checkInCount: checkInCount,
                studentId: studentId,
                startDate: startDate,
                status: status ||
                    (!endDate.isBefore(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ))),
              ),
            );
          },
          color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                String status = 'PENDING';
                if (Utils.getIntervalOfData(week.startDate, week.endDate) + 1 ==
                    (dailyActivity == null
                        ? 0
                        : dailyActivity!.activitiesStatus!.length)) {
                  status = 'UNVERIFIED';
                  if (dailyActivity!.activitiesStatus!.indexWhere((element) =>
                          element.verificationStatus != 'VERIFIED') ==
                      -1) {
                    status = 'VERIFIED';
                  }
                }
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: status == 'VERIFIED'
                            ? successColor
                            : status == 'UNVERIFIED'
                                ? secondaryColor
                                : onFormDisableColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            status == 'VERIFIED'
                                ? Icons.verified_rounded
                                : Icons.hourglass_bottom_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${status}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                    )
                  ],
                );
              }),
              SizedBox(
                height: 16,
              ),
              Text(
                'Week ${week.weekName}',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${Utils.epochToStringDate(startTime: week.startDate!, endTime: week.endDate)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Builder(builder: (context) {
                Map<String, String> emoji = {
                  'ATTEND': 'emoji_hadir.svg',
                  'SICK': 'sakit_emoji.svg',
                  'NOT_ATTEND': 'emoji_alfa.svg',
                  'HOLIDAY': 'icon_holiday.svg',
                };
                final List<DailyActivityTempModel> listDays = [];
                final List<ActivitiesStatus> temp = dailyActivity != null
                    ? dailyActivity!.activitiesStatus!
                    : [];

                String firstDayName = Utils.epochToStringDate(
                  startTime: week.startDate!,
                  format: 'EEEE',
                );
                int interval =
                    Utils.getIntervalOfData(week.startDate, week.endDate);

                final daysOfWeek = [
                  'MONDAY',
                  'TUESDAY',
                  'WEDNESDAY',
                  'THURSDAY',
                  'FRIDAY',
                  'SATURDAY',
                  'SUNDAY',
                ];
                int startIndex = daysOfWeek.indexOf(firstDayName.toUpperCase());
                DateTime start = startDate;
                for (var i = 0; i < interval + 1; i++) {
                  ActivitiesStatus? tempD;
                  if (temp.indexWhere((element) =>
                          element.day == daysOfWeek[startIndex % 7]) !=
                      -1) {
                    tempD = temp.firstWhere(
                        (element) => element.day == daysOfWeek[startIndex % 7]);
                  }
                  listDays.add(
                    DailyActivityTempModel(
                      day: daysOfWeek[startIndex % 7],
                      dailyActivity: tempD,
                      dateTime: start,
                    ),
                  );
                  start = start.add(Duration(days: 1));
                  startIndex += 1;
                }

                return SpacingRow(
                  onlyPading: true,
                  spacing: 0,
                  horizontalPadding: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: listDays.map(
                    (e) {
                      print(week.weekName);
                      print(e.dailyActivity?.day);
                      print(e.dailyActivity?.activityStatus);
                      return Column(
                        children: [
                          Text(
                            e.day.substring(0, 3),
                            style: textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          if (e.dailyActivity == null &&
                              endDate.isBefore(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              )))
                            SvgPicture.asset(
                              AssetPath.getIcon(emoji['NOT_ATTEND']!),
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            )
                          else if (e.dailyActivity == null)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dividerColor,
                                border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignInside,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          else
                            SvgPicture.asset(
                              AssetPath.getIcon(
                                  emoji[e.dailyActivity!.activityStatus!]!),
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                        ],
                      );
                    },
                  ).toList(),
                );
              }),
            ],
          ),
        ),
        if (DateTime.now().isBefore(startDate))
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300]?.withOpacity(.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: 28,
                          color: primaryTextColor.withOpacity(.9),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'This week is still locked',
                          style: textTheme.bodyLarge?.copyWith(
                            color: primaryTextColor.withOpacity(.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
