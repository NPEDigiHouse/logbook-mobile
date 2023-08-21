import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/head_section/in_out_reporting/in_out_reporting_page.dart';
import 'package:elogbook/src/presentation/widgets/main_menu.dart';

class HeadSectionHomePage extends StatelessWidget {
  const HeadSectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenu(
      username: 'Khairun Nisa',
      role: 'Head of Division',
      menuItems: <MenuItem>[
        MenuItem(
          name: 'Tasks',
          iconPath: 'round_task_filled.svg',
          onTap: () {},
        ),
        MenuItem(
          name: 'In-Out Reporting',
          iconPath: 'file_arrow_up_down_filled.svg',
          onTap: () => context.navigateTo(const InOutReportingPage()),
        ),
      ],
    );
  }
}
