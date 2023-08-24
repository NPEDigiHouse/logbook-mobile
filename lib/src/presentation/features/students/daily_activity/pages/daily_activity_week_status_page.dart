import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/create_daily_activity_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyActivityWeekStatusPage extends StatefulWidget {
  final String dailyActivityId;
  final int weekName;

  const DailyActivityWeekStatusPage(
      {super.key, required this.dailyActivityId, required this.weekName});

  @override
  State<DailyActivityWeekStatusPage> createState() =>
      _DailyActivityWeekStatusPageState();
}

class _DailyActivityWeekStatusPageState
    extends State<DailyActivityWeekStatusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<DailyActivityCubit>(context)
        ..getStudentActivityPerweek(id: widget.dailyActivityId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity - Week ${widget.weekName}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<DailyActivityCubit, DailyActivityState>(
          builder: (context, state) {
            if (state.studentActivityPerweek != null) {
              return SpacingColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                horizontalPadding: 16,
                spacing: 20,
                children: [
                  Container(
                    width: AppSize.getAppWidth(context),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Week ${state.studentActivityPerweek!.weekName}',
                              style: textTheme.titleLarge,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: state.studentActivityPerweek!
                                            .verificationStatus ==
                                        'VERIFIED'
                                    ? successColor
                                    : errorColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    state.studentActivityPerweek!
                                                .verificationStatus ==
                                            'VERIFIED'
                                        ? Icons.verified_rounded
                                        : Icons.hourglass_bottom_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${state.studentActivityPerweek?.verificationStatus}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                        child: SvgPicture.asset(
                                            AssetPath.getIcon(
                                                'emoji_alfa.svg'))),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${state.studentActivityPerweek!.alpha}',
                                      style: textTheme.titleMedium?.copyWith(
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
                                        child: SvgPicture.asset(
                                            AssetPath.getIcon(
                                                'emoji_hadir.svg'))),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      '${state.studentActivityPerweek!.attend}',
                                      style: textTheme.titleMedium?.copyWith(
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
                    final data = state.studentActivityPerweek!.activities!;
                    return DailyActivityStatusCard(
                      id: data[index].id!,
                      verificationStatus: data[index].verificationStatus!,
                      day: data[index].day!,
                      dailyActivityId: widget.dailyActivityId,
                      status: data[index].activityStatus!,
                    );
                  }).toList(),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class DailyActivityStatusCard extends StatelessWidget {
  final String? dailyActivityId;
  final String id;
  final String day;
  final String verificationStatus;
  final String status;
  const DailyActivityStatusCard(
      {super.key,
      required this.dailyActivityId,
      required this.id,
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
      onTap: () => context.navigateTo(CreateDailyActivityPage(
        modelId: id,
        id: dailyActivityId!,
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
