import 'package:flutter/material.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/dummy_models.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/in_out_reporting_list.dart';

class CheckReportPage extends StatelessWidget {
  final String title;
  final int iconQuarterTurns;
  final List<StudentCheckReport> students;

  const CheckReportPage({
    super.key,
    required this.title,
    required this.iconQuarterTurns,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return students.isEmpty
        ? const Center(
            child: Text('No data yet.'),
          )
        : InOutReportingList(
            title: title,
            iconQuarterTurns: iconQuarterTurns,
            students: students,
          );
  }
}
