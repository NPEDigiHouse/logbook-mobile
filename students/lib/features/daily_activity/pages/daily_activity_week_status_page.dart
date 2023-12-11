// ignore_for_file: prefer_null_aware_operators

import 'package:common/features/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/daily_activity/student_daily_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:students/features/daily_activity/daily_activity_home_page.dart';
import 'package:students/features/daily_activity/pages/create_daily_activity_page.dart';

class DailyActivityWeekStatusPage extends StatefulWidget {
  final Week week;
  final int weekName;
  final DateTime startDate;
  final bool isSupervisor;
  final String? studentId;
  // final int checkInCount;
  final bool status;

  const DailyActivityWeekStatusPage({
    super.key,
    required this.status,
    required this.isSupervisor,
    required this.startDate,
    required this.week,
    this.studentId,
    required this.weekName,
    // required this.checkInCount
  });

  @override
  State<DailyActivityWeekStatusPage> createState() =>
      _DailyActivityWeekStatusPageState();
}

class _DailyActivityWeekStatusPageState
    extends State<DailyActivityWeekStatusPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isSupervisor) {
      BlocProvider.of<DailyActivityCubit>(context)
          .getActivitiesByWeekIdStudentId(
              weekId: widget.week.id!, studentId: widget.studentId ?? '');
    } else {
      BlocProvider.of<DailyActivityCubit>(context)
          .getDailyActivityDays(weekId: widget.week.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity - Week ${widget.weekName}'),
      ),
      body: CheckInternetOnetime(child: (context) {
        return RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: BlocConsumer<DailyActivityCubit, DailyActivityState>(
                  listener: (context, state) {
                    if (state.isDailyActivityUpdated) {
                      if (widget.isSupervisor) {
                        BlocProvider.of<DailyActivityCubit>(context)
                            .getActivitiesByWeekIdStudentId(
                                weekId: widget.week.id!,
                                studentId: widget.studentId ?? '');
                      } else {
                        BlocProvider.of<DailyActivityCubit>(context)
                            .getDailyActivityDays(weekId: widget.week.id!);
                      }

                      BlocProvider.of<DailyActivityCubit>(context)
                          .getStudentDailyActivities();
                    }
                  },
                  builder: (context, state) {
                    if (state.activityPerDays != null) {
                      return SingleChildScrollView(
                        child: SpacingColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          horizontalPadding: 16,
                          spacing: 20,
                          children: [
                            const SizedBox(
                              height: 16,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Week ${widget.weekName}',
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                    color: primaryColor
                                                        .withOpacity(
                                                      .2,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: SvgPicture.asset(
                                                      AssetPath.getIcon(
                                                          'emoji_hadir.svg'))),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '${state.activityPerDays?.attend}',
                                                style: textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              ),
                                              const Text('Hadir'),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                    color:
                                                        errorColor.withOpacity(
                                                      .2,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  child: SvgPicture.asset(
                                                      AssetPath.getIcon(
                                                          'emoji_alfa.svg'))),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '${state.activityPerDays?.alpha}',
                                                style: textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              ),
                                              const Text('Tidak Hadir'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(
                                state.activityPerDays!.days!.length, (index) {
                              final List<DailyActivityTempModel> listDays = [];

                              final data = state.activityPerDays!.days!;
                              data.sort(
                                (a, b) {
                                  final daysOfWeek = [
                                    'MONDAY',
                                    'TUESDAY',
                                    'WEDNESDAY',
                                    'THURSDAY',
                                    'FRIDAY',
                                    'SATURDAY',
                                    'SUNDAY',
                                  ];
                                  return daysOfWeek
                                      .indexOf(a.day!)
                                      .compareTo(daysOfWeek.indexOf(b.day!));
                                },
                              );
                              DateTime start = widget.startDate;

                              for (var d in data) {
                                ActivitiesStatus? tempD;
                                if (state.activityPerDays!.activities!
                                        .indexWhere((element) =>
                                            element.day == d.day) !=
                                    -1) {
                                  tempD = state.activityPerDays!.activities!
                                      .firstWhere(
                                          (element) => element.day == d.day);
                                }
                                listDays.add(
                                  DailyActivityTempModel(
                                    day: d.day!,
                                    id: d.id,
                                    dailyActivity: tempD,
                                    dateTime: start,
                                  ),
                                );
                                start = start.add(const Duration(days: 1));
                              }
                              return DailyActivityStatusCard(
                                isSupervisor: widget.isSupervisor,
                                activeStatus: widget.status,
                                id: listDays[index].id!,
                                date: listDays[index].dateTime,
                                supervisorName:
                                    listDays[index].dailyActivity == null
                                        ? null
                                        : listDays[index]
                                            .dailyActivity
                                            ?.supervisorName,
                                verificationStatus:
                                    listDays[index].dailyActivity == null
                                        ? 'PENDING'
                                        : listDays[index]
                                                .dailyActivity!
                                                .verificationStatus ??
                                            'PENDING',
                                day: listDays[index].day,
                                dailyActivityId: widget.week.id,
                                status: listDays[index].dailyActivity == null
                                    ? null
                                    : listDays[index]
                                        .dailyActivity!
                                        .activityStatus,
                                // checkInCount: widget.checkInCount,
                                detail: listDays[index].dailyActivity == null
                                    ? null
                                    : listDays[index].dailyActivity?.detail,
                                activity: listDays[index].dailyActivity == null
                                    ? null
                                    : listDays[index]
                                        .dailyActivity!
                                        .activityName,
                                activitiesStatus: listDays[index].dailyActivity,
                              );
                            }).toList(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    }
                    // if (state.activityPerDays?!= null) {

                    // }
                    return const CustomLoading();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class DailyActivityStatusCard extends StatefulWidget {
  final bool isSupervisor;
  final DateTime? date;
  final String? dailyActivityId;
  final String id;
  final String day;
  final String? activity;
  final String verificationStatus;
  final String? status;
  final String? supervisorName;
  // final int checkInCount;
  final String? detail;
  final ActivitiesStatus? activitiesStatus;
  final bool activeStatus;
  const DailyActivityStatusCard({
    super.key,
    this.supervisorName,
    required this.isSupervisor,
    required this.date,
    required this.dailyActivityId,
    required this.id,
    this.activitiesStatus,
    this.activity,
    required this.activeStatus,
    this.detail,
    required this.verificationStatus,
    required this.day,
    // required this.checkInCount,
    required this.status,
  });

  @override
  State<DailyActivityStatusCard> createState() =>
      _DailyActivityStatusCardState();
}

class _DailyActivityStatusCardState extends State<DailyActivityStatusCard> {
  final ValueNotifier<bool> isShowDetail = ValueNotifier(false);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isShowDetail.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> emoji = {
      'ATTEND': 'emoji_hadir.svg',
      'SICK': 'sakit_emoji.svg',
      'NOT_ATTEND': 'emoji_alfa.svg',
      'HOLIDAY': 'icon_holiday.svg',
    };
    return InkWellContainer(
      padding: const EdgeInsets.all(16),
      radius: 12,
      onTap: widget.activeStatus &&
              widget.verificationStatus != 'VERIFIED' &&
              !widget.isSupervisor
          ? () => context.navigateTo(CreateDailyActivityPage(
                dayId: widget.id,
                id: widget.dailyActivityId!,
                activityStatus: widget.activitiesStatus,
              ))
          : null,
      color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.status == null &&
              widget.date!.isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              )))
            SvgPicture.asset(
              AssetPath.getIcon(emoji['NOT_ATTEND']!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          else if (widget.status == null)
            Container(
              width: 38,
              height: 38,
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
              AssetPath.getIcon(emoji[widget.status]!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.activity ??
                (widget.status == null
                    ? 'Unsubmitted'
                    : widget.status![0].toUpperCase() +
                        widget.status!.substring(1).toLowerCase()),
            style: textTheme.bodyMedium
                ?.copyWith(height: 1.1, color: onFormDisableColor),
          ),
          Text(
            widget.day,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: textTheme.bodyMedium?.copyWith(
                color: primaryTextColor,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Supervisor :\t',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: widget.supervisorName ?? '-'),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: textTheme.titleSmall?.copyWith(
                    color: primaryTextColor,
                  ),
                  text: 'Verify Status: ',
                  children: [
                    TextSpan(
                      text: widget.verificationStatus,
                      style: textTheme.titleSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ValueListenableBuilder(
                  valueListenable: isShowDetail,
                  builder: (context, val, _) {
                    if (widget.detail != null && widget.detail!.isNotEmpty) {
                      return InkWell(
                        onTap: () {
                          isShowDetail.value = !isShowDetail.value;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: val
                                    ? onFormDisableColor
                                    : primaryTextColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            val ? 'Dismiss' : 'Show Detail',
                            style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: val
                                    ? onFormDisableColor
                                    : primaryTextColor),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ValueListenableBuilder(
            valueListenable: isShowDetail,
            builder: (context, value, child) {
              if (value && widget.detail != null && widget.detail!.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: onFormDisableColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.detail ?? '',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
