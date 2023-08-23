import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/daily_activity/pages/daily_activity_week_status_page.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:elogbook/src/presentation/widgets/spacing_row.dart';
import 'package:flutter/material.dart';

class DailyActivityPage extends StatelessWidget {
  const DailyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              5,
              (index) => DailyActivityHomeCard(),
            )
          ],
        ),
      ),
    );
  }
}

class DailyActivityHomeCard extends StatelessWidget {
  const DailyActivityHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      padding: EdgeInsets.all(16),
      radius: 12,
      onTap: () => context.navigateTo(DailyActivityWeekStatusPage()),
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
                      '2 of 5 Uncompleted',
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
            'Week 3',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Feb 20 - Feb 24',
            style: textTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Builder(builder: (context) {
            List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
            return SpacingRow(
              onlyPading: true,
              spacing: 0,
              horizontalPadding: 12,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days
                  .map(
                    (e) => Column(
                      children: [
                        Text(e),
                        SizedBox(
                          height: 4,
                        ),
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
