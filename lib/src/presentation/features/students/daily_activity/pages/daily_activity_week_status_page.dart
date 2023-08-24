import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/daily_activity_home_page.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/create_daily_activity_page.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyActivityWeekStatusPage extends StatelessWidget {
  final DailyActivityTempModel model;

  const DailyActivityWeekStatusPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Week ${model.week}'),
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
              model.listAttendance.where((element) => element != 0).length,
              (index) => DailyActivityStatusCard(
                attendance: model.listAttendance[index],
                day: dummyData[index],
                status: 'Verified',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DailyActivityStatusCard extends StatelessWidget {
  final String day;
  final String status;
  final int attendance;
  const DailyActivityStatusCard(
      {super.key,
      required this.status,
      required this.day,
      required this.attendance});

  @override
  Widget build(BuildContext context) {
    List<String> emoji = [
      'emoji_hadir.svg',
      'sakit_emoji.svg',
      'izin_emoji.svg',
      'emoji_alfa.svg',
    ];
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () => context.navigateTo(CreateDailyActivityPage()),
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
            AssetPath.getIcon(emoji[attendance - 1]),
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
          Text(
            '20 Feb 2023, 23:59 WIB',
            style: textTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          SizedBox(
            height: 16,
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
                      text: status,
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
