import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:main/widgets/main_app_bar.dart';
import 'package:main/widgets/main_menu.dart';
import 'package:main/widgets/spacing_column.dart';

import '../daily_activity/daily_activity_page.dart';
import 'package:flutter/material.dart';
import '../weekly_grade/weekly_grade_page.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CoordinatorHomePage extends StatelessWidget {
  final UserCredential credential;
  const CoordinatorHomePage({super.key, required this.credential});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            child: SpacingColumn(
              horizontalPadding: 16,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: AppSize.getAppWidth(context) - 46,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: const Offset(6, 8),
                        color: primaryColor.withOpacity(.3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                          child: SvgPicture.asset(
                            AssetPath.getVector('ellipse_1.svg'),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('half_ellipse.svg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Hello, ${credential.fullname}',
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Let\'s Complete Some Tasks To Help Students',
                              style: TextStyle(color: backgroundColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    // Expanded(
                    //   child: MenuItem(
                    //     isVerification: false,
                    //     name: 'Daily Activity',
                    //     iconPath: 'icon_training.svg',
                    //     onTap: () => context
                    //         .navigateTo(const CoordinatorDailyActivityPage()),
                    //     status: 'Add Week',
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 12,
                    // ),
                    Expanded(
                      child: MenuItem(
                        isVerification: false,
                        name: 'Weekly Grades',
                        iconPath: 'exam_filled.svg',
                        onTap: () =>
                            context.navigateTo(const WeeklyGradePage()),
                        status: 'Input Score',
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // return MainMenu(
    //   username: credential.fullname ?? '',
    //   role: 'Coordinator',
    //   menuItems: <MenuItem>[
    //     MenuItem(
    //       isVerification: false,
    //       name: 'Weekly Grades',
    //       iconPath: 'exam_filled.svg',
    //       onTap: () => context.navigateTo(const WeeklyGradePage()),
    //     ),
    //   ],
    // );
  }
}