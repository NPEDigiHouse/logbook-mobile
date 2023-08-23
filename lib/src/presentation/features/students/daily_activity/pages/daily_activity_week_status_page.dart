import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/create_daily_activity_page.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class DailyActivityWeekStatusPage extends StatelessWidget {
  const DailyActivityWeekStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week 3'),
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
              5,
              (index) => DailyActivityStatusCard(),
            )
          ],
        ),
      ),
    );
  }
}

class DailyActivityStatusCard extends StatelessWidget {
  const DailyActivityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dividerColor,
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                )),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Monday',
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
                      text: 'Waiting',
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
