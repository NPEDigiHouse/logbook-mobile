import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/profile_item_menu_card.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const MainAppBar(),
        SliverFillRemaining(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('half_ellipse3.svg'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SvgPicture.asset(
                          AssetPath.getVector('circle_bg3.svg'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: -40,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 50,
                                foregroundImage: AssetImage(
                                  AssetPath.getImage('profile_default.png'),
                                ),
                              ),
                            ),
                            Positioned(
                              right: (AppSize.getAppWidth(context) / 2) - 54,
                              bottom: 5,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: scaffoldBackgroundColor,
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AssetPath.getIcon('camera_filled.svg'),
                                    width: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                Text(
                  'Khairun Nisa',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Supervisor',
                  style: TextStyle(color: secondaryColor),
                ),
                const SizedBox(height: 28),
                ProfileItemMenuCard(
                  iconPath: 'person_filled.svg',
                  title: 'Personal & Statistic',
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                ProfileItemMenuCard(
                  iconPath: 'file_export_filled.svg',
                  title: 'Export Data',
                  onTap: () {},
                ),
                const SizedBox(height: 14),
                ProfileItemMenuCard(
                  iconPath: 'lock_filled.svg',
                  title: 'Change Password',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
