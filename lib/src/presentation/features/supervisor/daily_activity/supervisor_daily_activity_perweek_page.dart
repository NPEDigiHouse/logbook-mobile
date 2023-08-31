import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentDailyActivityWeekStatusPage extends StatefulWidget {
  final String dailyActivityId;
  final int weekName;

  const StudentDailyActivityWeekStatusPage(
      {super.key, required this.dailyActivityId, required this.weekName});

  @override
  State<StudentDailyActivityWeekStatusPage> createState() =>
      _StudentDailyActivityWeekStatusPageState();
}

class _StudentDailyActivityWeekStatusPageState
    extends State<StudentDailyActivityWeekStatusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<DailyActivityCubit>(context)
        ..getActivityPerweekBySupervisor(id: widget.dailyActivityId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyActivityCubit, DailyActivityState>(
      listener: (context, state) {
        if (state.stateVerifyDailyActivity == RequestState.data) {
          BlocProvider.of<DailyActivityCubit>(context)
            ..getActivityPerweekBySupervisor(id: widget.dailyActivityId)
            ..reset();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Daily Activity - Week ${widget.weekName}'),
          ),
          floatingActionButton: (state.studentActivityPerweek != null)
              ? SizedBox(
                  width: AppSize.getAppWidth(context) - 32,
                  child: state.studentActivityPerweek!.verificationStatus ==
                          'VERIFIED'
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: primaryColor),
                          ),
                          onPressed: () {
                            BlocProvider.of<DailyActivityCubit>(context)
                              ..verifiyDailyActivityById(
                                  id: widget.dailyActivityId,
                                  verifiedStatus: false);
                          },
                          child: Text('Cancel Verification'),
                        )
                      : FilledButton.icon(
                          onPressed: () {
                            BlocProvider.of<DailyActivityCubit>(context)
                              ..verifiyDailyActivityById(
                                  id: widget.dailyActivityId,
                                  verifiedStatus: true);
                          },
                          icon: Icon(Icons.verified),
                          label: Text('Verify Activity'),
                        ),
                )
              : SizedBox.shrink(),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                BlocProvider.of<DailyActivityCubit>(context)
                    .getActivityPerweekBySupervisor(id: widget.dailyActivityId),
              ]);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Builder(
                builder: (context) {
                  if (state.studentActivityPerweek != null) {
                    return SpacingColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      horizontalPadding: 16,
                      spacing: 12,
                      children: [
                        Container(
                          width: AppSize.getAppWidth(context),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.12),
                                offset: Offset(0, 2),
                                blurRadius: 20,
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                            color: scaffoldBackgroundColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Week ${state.studentActivityPerweek!.weekName}',
                                    style: textTheme.titleLarge,
                                  ),
                                  if (state.studentActivityPerweek!
                                          .verificationStatus ==
                                      'VERIFIED') ...[
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.verified,
                                      color: primaryColor,
                                    )
                                  ]
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF6F7F8),
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
                                                color: errorColor.withOpacity(
                                                  .2,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: SvgPicture.asset(
                                                  AssetPath.getIcon(
                                                      'emoji_alfa.svg'))),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${state.studentActivityPerweek!.alpha}',
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                          ),
                                          Text('Alpha'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF6F7F8),
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
                                                color: primaryColor.withOpacity(
                                                  .2,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: SvgPicture.asset(
                                                  AssetPath.getIcon(
                                                      'emoji_hadir.svg'))),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${state.studentActivityPerweek!.attend}',
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              height: 1,
                                            ),
                                          ),
                                          Text('Hadir'),
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
                            state.studentActivityPerweek!.activities!.length,
                            (index) {
                          final data =
                              state.studentActivityPerweek!.activities!;
                          data.sort(
                            (a, b) {
                              // Urutkan berdasarkan urutan hari dalam seminggu
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
                          return DailyActivityStatusCard(
                            verificationStatus: data[index].verificationStatus!,
                            day: data[index].day!,
                            status: data[index].activityStatus!,
                            detail: data[index].detail,
                          );
                        }).toList(),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    );
                  }
                  return CustomLoading();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class DailyActivityStatusCard extends StatelessWidget {
  final String? detail;
  final String day;
  final String verificationStatus;
  final String status;
  const DailyActivityStatusCard(
      {super.key,
      this.detail,
      required this.verificationStatus,
      required this.day,
      required this.status});

  @override
  Widget build(BuildContext context) {
    Map<String, String> emoji = {
      'ATTEND': 'emoji_hadir.svg',
      'SICK': 'sakit_emoji.svg',
      'NOT_ATTEND': 'emoji_alfa.svg',
    };
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () {},
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
            day,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
            ],
          ),
          Text(
            detail ?? '-',
            style: textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
