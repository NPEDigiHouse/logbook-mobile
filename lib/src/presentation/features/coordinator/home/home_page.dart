import 'package:flutter/material.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/weekly_grade_page.dart';
import 'package:elogbook/src/presentation/widgets/main_menu.dart';

class CoordinatorHomePage extends StatelessWidget {
  const CoordinatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenu(
      username: 'Khairun Nisa',
      role: 'Coordinator',
      menuItems: <MenuItem>[
        // MenuItem(
        //   name: 'Tasks',
        //   iconPath: 'round_task_filled.svg',
        //   onTap: () {},
        // ),
        MenuItem(
          isVerification: false,
          name: 'Weekly Grades',
          iconPath: 'exam_filled.svg',
          onTap: () => context.navigateTo(const WeeklyGradePage()),
        ),
        // MenuItem(
        //   name: 'Special Report',
        //   iconPath: 'problem_rounded.svg',
        //   onTap: () {},
        // ),
      ],
    );
  }
}
