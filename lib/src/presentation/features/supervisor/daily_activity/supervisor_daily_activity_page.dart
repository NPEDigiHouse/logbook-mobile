import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/daily_activity/supervisor_daily_activity_perweek_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorDailyActivityPage extends StatefulWidget {
  final String studentId;
  const SupervisorDailyActivityPage({super.key, required this.studentId});

  @override
  State<SupervisorDailyActivityPage> createState() =>
      _SupervisorDailyActivityPageState();
}

class _SupervisorDailyActivityPageState
    extends State<SupervisorDailyActivityPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DailyActivityCubit>(context)
      ..getDailyActivitiesBySupervisor(studentId: widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<DailyActivityCubit>(context)
                .getDailyActivitiesBySupervisor(studentId: widget.studentId),
          ]);
        },
        child: BlocConsumer<DailyActivityCubit, DailyActivityState>(
          listener: (context, state) {
            if (state.stateVerifyDailyActivity == RequestState.data) {
              BlocProvider.of<DailyActivityCubit>(context)
                ..getDailyActivitiesBySupervisor(studentId: widget.studentId)
                ..reset();
            }
          },
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
                      unitName: 'Nama Department',
                    ),
                    ...List.generate(
                      state.studentDailyActivity!.dailyActivities!.length,
                      (index) => DailyActivityHomeCard(
                        dailyActivity:
                            state.studentDailyActivity!.dailyActivities![index],
                      ),
                    )
                  ],
                ),
              );
            return CustomLoading();
          },
        ),
      ),
    );
  }
}

class DailyActivityHomeCard extends StatelessWidget {
  final StudentDailyActivityModel dailyActivity;
  const DailyActivityHomeCard({super.key, required this.dailyActivity});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () => context.navigateTo(StudentDailyActivityWeekStatusPage(
        dailyActivityId: dailyActivity.dailyActivityId!,
        weekName: dailyActivity.weekName!,
      )),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                'Week ${dailyActivity.weekName}',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (dailyActivity.verificationStatus == 'VERIFIED') ...[
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.verified,
                  color: primaryColor,
                )
              ],
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Builder(builder: (context) {
            Map<String, String> emoji = {
              'ATTEND': 'emoji_hadir.svg',
              'SICK': 'sakit_emoji.svg',
              'NOT_ATTEND': 'emoji_alfa.svg',
            };
            dailyActivity.activitiesStatus!.sort(
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
            return SpacingRow(
              onlyPading: true,
              spacing: 0,
              horizontalPadding: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dailyActivity.activitiesStatus!
                  .map(
                    (e) => Column(
                      children: [
                        Text(e.day!.substring(0, 3)),
                        SizedBox(
                          height: 4,
                        ),
                        if (e.activityStatus == 'NOT_ATTEND')
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dividerColor,
                              border: Border.all(
                                strokeAlign: BorderSide.strokeAlignInside,
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        if (e.activityStatus != 'NOT_ATTEND')
                          SvgPicture.asset(
                            AssetPath.getIcon(emoji[e.activityStatus!]!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  )
                  .toList(),
            );
          }),
          SizedBox(
            height: 8,
          ),
          if (dailyActivity.verificationStatus == 'VERIFIED')
            OutlinedButton(
              onPressed: () {
                BlocProvider.of<DailyActivityCubit>(context)
                  ..verifiyDailyActivityById(
                      id: dailyActivity.dailyActivityId!,
                      verifiedStatus: false);
              },
              child: Text('Cancel'),
            )
          else
            FilledButton(
              onPressed: () {
                BlocProvider.of<DailyActivityCubit>(context)
                  ..verifiyDailyActivityById(
                      id: dailyActivity.dailyActivityId!, verifiedStatus: true);
              },
              child: Text('Verify'),
            )
        ],
      ),
    );
  }
}
