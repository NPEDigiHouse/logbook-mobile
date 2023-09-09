import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/create_daily_activity_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyActivityWeekStatusPage extends StatefulWidget {
  final Week week;
  final int weekName;
  final int checkInCount;

  const DailyActivityWeekStatusPage(
      {super.key,
      required this.week,
      required this.weekName,
      required this.checkInCount});

  @override
  State<DailyActivityWeekStatusPage> createState() =>
      _DailyActivityWeekStatusPageState();
}

class _DailyActivityWeekStatusPageState
    extends State<DailyActivityWeekStatusPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DailyActivityCubit>(context)
      ..getDailyActivityDays(weekId: widget.week.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity - Week ${widget.weekName}'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: BlocConsumer<DailyActivityCubit, DailyActivityState>(
                listener: (context, state) {
                  if (state.isDailyActivityUpdated) {
                    BlocProvider.of<DailyActivityCubit>(context)
                      ..getDailyActivityDays(weekId: widget.week.id!);
                    BlocProvider.of<DailyActivityCubit>(context)
                        .getStudentDailyActivities();
                  }
                },
                builder: (context, state) {
                  if (state.activityPerDays != null)
                    return SingleChildScrollView(
                      child: SpacingColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        horizontalPadding: 16,
                        spacing: 20,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          // Container(
                          //   width: AppSize.getAppWidth(context),
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 16, horizontal: 20),
                          //   decoration: BoxDecoration(
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.black.withOpacity(.12),
                          //         offset: Offset(0, 2),
                          //         blurRadius: 20,
                          //       )
                          //     ],
                          //     borderRadius: BorderRadius.circular(12),
                          //     color: scaffoldBackgroundColor,
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             'Week ${widget.weekName}',
                          //             style: textTheme.titleLarge,
                          //           ),
                          //           // Container(
                          //           //   padding: EdgeInsets.symmetric(
                          //           //     horizontal: 12,
                          //           //     vertical: 4,
                          //           //   ),
                          //           //   decoration: BoxDecoration(
                          //           //     borderRadius: BorderRadius.circular(50),
                          //           //     color: state.studentActivityPerweek!
                          //           //                 .verificationStatus ==
                          //           //             'VERIFIED'
                          //           //         ? successColor
                          //           //         : state.studentActivityPerweek!
                          //           //                     .verificationStatus ==
                          //           //                 'UNVERIFIED'
                          //           //             ? errorColor
                          //           //             : onFormDisableColor,
                          //           //   ),
                          //           //   child: Row(
                          //           //     crossAxisAlignment:
                          //           //         CrossAxisAlignment.center,
                          //           //     children: [
                          //           //       Icon(
                          //           //         state.studentActivityPerweek!
                          //           //                     .verificationStatus ==
                          //           //                 'VERIFIED'
                          //           //             ? Icons.verified_rounded
                          //           //             : state.studentActivityPerweek!
                          //           //                         .verificationStatus ==
                          //           //                     'UNVERIFIED'
                          //           //                 ? Icons.close_rounded
                          //           //                 : Icons
                          //           //                     .hourglass_bottom_rounded,
                          //           //         color: Colors.white,
                          //           //         size: 16,
                          //           //       ),
                          //           //       SizedBox(
                          //           //         width: 4,
                          //           //       ),
                          //           //       Text(
                          //           //         '${state.studentActivityPerweek?.verificationStatus}',
                          //           //         style: textTheme.bodySmall?.copyWith(
                          //           //           color: Colors.white,
                          //           //         ),
                          //           //       ),
                          //           //     ],
                          //           //   ),
                          //           // ),
                          //         ],
                          //       ),
                          //       SizedBox(
                          //         height: 12,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: Color(0xFFF6F7F8),
                          //                 borderRadius: BorderRadius.circular(8),
                          //               ),
                          //               height: 84,
                          //               child: Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: [
                          //                   Container(
                          //                       width: 24,
                          //                       height: 24,
                          //                       decoration: BoxDecoration(
                          //                         color: primaryColor.withOpacity(
                          //                           .2,
                          //                         ),
                          //                         shape: BoxShape.circle,
                          //                       ),
                          //                       padding: EdgeInsets.all(2),
                          //                       child: SvgPicture.asset(
                          //                           AssetPath.getIcon(
                          //                               'emoji_hadir.svg'))),
                          //                   SizedBox(
                          //                     height: 8,
                          //                   ),
                          //                   Text(
                          //                     '${state.studentActivityPerweek!.attend}',
                          //                     style:
                          //                         textTheme.titleMedium?.copyWith(
                          //                       fontWeight: FontWeight.bold,
                          //                       height: 1,
                          //                     ),
                          //                   ),
                          //                   Text('Hadir'),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             width: 8,
                          //           ),
                          //           Expanded(
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: Color(0xFFF6F7F8),
                          //                 borderRadius: BorderRadius.circular(8),
                          //               ),
                          //               height: 84,
                          //               child: Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: [
                          //                   Container(
                          //                       width: 24,
                          //                       height: 24,
                          //                       decoration: BoxDecoration(
                          //                         color: errorColor.withOpacity(
                          //                           .2,
                          //                         ),
                          //                         shape: BoxShape.circle,
                          //                       ),
                          //                       padding: EdgeInsets.all(2),
                          //                       child: SvgPicture.asset(
                          //                           AssetPath.getIcon(
                          //                               'emoji_alfa.svg'))),
                          //                   SizedBox(
                          //                     height: 8,
                          //                   ),
                          //                   Text(
                          //                     '${state.studentActivityPerweek!.alpha}',
                          //                     style:
                          //                         textTheme.titleMedium?.copyWith(
                          //                       fontWeight: FontWeight.bold,
                          //                       height: 1,
                          //                     ),
                          //                   ),
                          //                   Text('Tidak Hadir'),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          ...List.generate(state.activityPerDays!.days!.length,
                              (index) {
                            final List<DailyActivityTempModel> listDays = [];

                            final data = state.activityPerDays!.days!;
                            data.sort(
                              (a, b) {
                                final daysOfWeek = [
                                  'SUNDAY',
                                  'MONDAY',
                                  'TUESDAY',
                                  'WEDNESDAY',
                                  'THURSDAY',
                                  'FRIDAY',
                                  'SATURDAY'
                                ];
                                return daysOfWeek
                                    .indexOf(a.day!)
                                    .compareTo(daysOfWeek.indexOf(b.day!));
                              },
                            );
                            for (var d in data) {
                              ActivitiesStatus? tempD;
                              if (state.activityPerDays!.activities!.indexWhere(
                                      (element) => element.day == d.day) !=
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
                                ),
                              );
                            }
                            return DailyActivityStatusCard(
                              id: listDays[index].id!,
                              supervisorName:
                                  listDays[index].dailyActivity == null
                                      ? null
                                      : 'supervisorName',
                              verificationStatus:
                                  listDays[index].dailyActivity == null
                                      ? 'PENDING'
                                      : listDays[index]
                                              .dailyActivity!
                                              .verificationStatus ??
                                          'PENDING',
                              day: listDays[index].day!,
                              dailyActivityId: widget.week.id,
                              status: listDays[index].dailyActivity == null
                                  ? null
                                  : listDays[index]
                                      .dailyActivity!
                                      .activityStatus,
                              checkInCount: widget.checkInCount,
                              activity: listDays[index].dailyActivity == null
                                  ? null
                                  : listDays[index].dailyActivity!.activityName,
                            );
                          }).toList(),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    );
                  // if (state.studentActivityPerweek != null) {

                  // }
                  return CustomLoading();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyActivityStatusCard extends StatelessWidget {
  final String? dailyActivityId;
  final String id;
  final String day;
  final String? activity;
  final String verificationStatus;
  final String? status;
  final String? supervisorName;
  final int checkInCount;
  const DailyActivityStatusCard({
    super.key,
    this.supervisorName,
    required this.dailyActivityId,
    required this.id,
    this.activity,
    required this.verificationStatus,
    required this.day,
    required this.checkInCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, String> emoji = {
      'ATTEND': 'emoji_hadir.svg',
      'SICK': 'sakit_emoji.svg',
      'NOT_ATTEND': 'emoji_alfa.svg',
      'HOLIDAY': 'icon_holiday.svg',
    };
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: checkInCount == 0 && verificationStatus != 'VERIFIED'
          ? () => context.navigateTo(CreateDailyActivityPage(
                dayId: id,
                id: dailyActivityId!,
              ))
          : null,
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
          if (status == null)
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
              AssetPath.getIcon(emoji[status]!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          SizedBox(
            height: 16,
          ),
          Text(
            activity ?? '',
            style: textTheme.bodyMedium
                ?.copyWith(height: 1.1, color: onFormDisableColor),
          ),
          Text(
            day,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // RichText(
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   text: TextSpan(
          //     style: textTheme.bodyMedium?.copyWith(
          //       color: primaryTextColor,
          //     ),
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: 'Activity :\t',
          //         style: TextStyle(
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       TextSpan(text: activity ?? '-'),
          //     ],
          //   ),
          // ),
          SizedBox(
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
                      text: verificationStatus,
                      style: textTheme.titleSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                child: Text(
                  'Your Activity',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
