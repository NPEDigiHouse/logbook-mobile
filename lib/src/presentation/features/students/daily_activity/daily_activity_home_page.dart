import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/daily_activity/student_daily_activity_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/daily_activity_week_status_page.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyActivityTempModel {
  final int week;
  final String startDate;
  final String endDate;
  final List<int> listAttendance;

  DailyActivityTempModel(
      {required this.week,
      required this.startDate,
      required this.endDate,
      required this.listAttendance});
}

class DailyActivityPage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const DailyActivityPage({super.key, required this.activeUnitModel});

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
      body: RefreshIndicator(
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
                    UnitHeader(
                      unitName: widget.activeUnitModel.unitName!,
                    ),
                    Container(
                      width: AppSize.getAppWidth(context),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6F7F8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 84,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        child: Icon(
                                          Icons.summarize,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${state.studentDailyActivity!.inprocessDailyActivity! + state.studentDailyActivity!.unverifiedDailyActivity! + state.studentDailyActivity!.verifiedDailyActivity!}',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                      Text('Total'),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          size: 18,
                                          color: variant2Color,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${state.studentDailyActivity!.inprocessDailyActivity!}',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                      Text('Uncompleted'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: successColor.withOpacity(
                                            .2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.verified_rounded,
                                          size: 18,
                                          color: successColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${state.studentDailyActivity!.verifiedDailyActivity!}',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                      Text('Verified'),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        child: Icon(
                                          Icons.hourglass_bottom_rounded,
                                          size: 18,
                                          color: errorColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${state.studentDailyActivity!.unverifiedDailyActivity!}',
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                        ),
                                      ),
                                      Text('Unverified'),
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
                      state.studentDailyActivity!.dailyActivities!.length,
                      (index) => DailyActivityHomeCard(
                        dailyActivity:
                            state.studentDailyActivity!.dailyActivities![index],
                        checkInCount: widget.activeUnitModel.countCheckIn!,
                      ),
                    )
                  ],
                ),
              );
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class DailyActivityHomeCard extends StatelessWidget {
  final int checkInCount;
  final StudentDailyActivityModel dailyActivity;
  const DailyActivityHomeCard({super.key, required this.dailyActivity, required this.checkInCount});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () => context.navigateTo(DailyActivityWeekStatusPage(
        dailyActivityId: dailyActivity.dailyActivityId!,
        weekName: dailyActivity.weekName!,
        checkInCount: checkInCount,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: dailyActivity.verificationStatus == 'VERIFIED'
                      ? successColor
                      : errorColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      dailyActivity.verificationStatus == 'VERIFIED'
                          ? Icons.verified_rounded
                          : Icons.hourglass_bottom_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${dailyActivity.verificationStatus}',
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
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Week ${dailyActivity.weekName}',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   '${dailyActivity.} - ${dailyActivity.endDate}',
          //   style: textTheme.bodyMedium?.copyWith(
          //     color: secondaryTextColor,
          //   ),
          // ),
          // SizedBox(
          //   height: 16,
          // ),
          Builder(builder: (context) {
            Map<String, String> emoji = {
              'ATTEND': 'emoji_hadir.svg',
              'SICK': 'sakit_emoji.svg',
              'NOT_ATTEND': 'emoji_alfa.svg',
            };
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
        ],
      ),
    );
  }
}
