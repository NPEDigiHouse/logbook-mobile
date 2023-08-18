import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/in_out_reporting_list.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/in_out_reporting_page.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InOutReportingList(
      title: 'Check In Reporting',
      titleIcon: const RotatedBox(
        quarterTurns: 3,
        child: Icon(
          Icons.arrow_right_alt_rounded,
          color: primaryColor,
        ),
      ),
      students: [
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          true,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          false,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          false,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          true,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          false,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          true,
        ),
        StudentCheckReport(
          'H071191099',
          'Ahdini Zulfiana Abidin',
          '12 Jun 2023, 01:50 pm',
          true,
        ),
      ],
    );
  }
}
