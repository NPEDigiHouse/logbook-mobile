import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/daily_activity_week_status_page.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';
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

class DailyActivityPage extends StatelessWidget {
  const DailyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<DailyActivityTempModel> tempDailyActivies = [
      DailyActivityTempModel(
        week: 1,
        startDate: 'Agu 20',
        endDate: 'Agu 25',
        listAttendance: [1, 2, 1, 1, 3],
      ),
      DailyActivityTempModel(
        week: 2,
        startDate: 'Agu 27',
        endDate: 'Sep 02',
        listAttendance: [3, 1, 4, 1, 1],
      ),
      DailyActivityTempModel(
        week: 2,
        startDate: 'Sep 04',
        endDate: 'Sep 09',
        listAttendance: [1, 1, 0, 0, 0],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SpacingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          horizontalPadding: 16,
          spacing: 20,
          children: [
            UnitHeader(),
            ...List.generate(
              tempDailyActivies.length,
              (index) => DailyActivityHomeCard(
                dailyActivity: tempDailyActivies[index],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DailyActivityHomeCard extends StatelessWidget {
  final DailyActivityTempModel dailyActivity;
  const DailyActivityHomeCard({super.key, required this.dailyActivity});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () => context.navigateTo(DailyActivityWeekStatusPage(model: dailyActivity,)),
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
                  color: onDisableColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_bottom_rounded,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${dailyActivity.listAttendance.where((element) => element != 0).length} of 5 Uncompleted',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
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
            'Week ${dailyActivity.week}',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${dailyActivity.startDate} - ${dailyActivity.endDate}',
            style: textTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Builder(builder: (context) {
            List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
            List<String> emoji = [
              'emoji_hadir.svg',
              'sakit_emoji.svg',
              'izin_emoji.svg',
              'emoji_alfa.svg',
            ];
            return SpacingRow(
              onlyPading: true,
              spacing: 0,
              horizontalPadding: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: dailyActivity.listAttendance
                  .map(
                    (e) => Column(
                      children: [
                        Text(days[dailyActivity.listAttendance.indexOf(e)]),
                        SizedBox(
                          height: 4,
                        ),
                        if (e == 0)
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
                        if (e != 0)
                          SvgPicture.asset(
                            AssetPath.getIcon(emoji[e - 1]),
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
