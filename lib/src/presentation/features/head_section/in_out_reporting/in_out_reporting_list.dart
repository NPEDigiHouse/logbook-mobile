import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/check_report_bottom_sheet.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/dummy_models.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/in_out_reporting_item.dart';

class InOutReportingList extends StatelessWidget {
  final String title;
  final int iconQuarterTurns;
  final List<StudentCheckReport> students;

  const InOutReportingList({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 20,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final hasSeparator = index != students.length - 1;
                final bottom = hasSeparator ? 12.0 : 0.0;

                return Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: InOutReportingItem(
                    student: students[index],
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => CheckReportBottomSheet(
                        title: title,
                        iconQuarterTurns: iconQuarterTurns,
                        student: students[index],
                      ),
                    ),
                  ),
                );
              },
              childCount: students.length,
            ),
          ),
        ),
      ],
    );
  }
}
