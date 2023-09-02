import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/change_password_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/export_data_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/personal_data_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/unit_statistics_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/profile_item_menu_card.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final UserCredential credential;
  const ProfilePage({super.key, required this.credential});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<ProfileCubit>(context)
        ..getProfilePic()
        ..getUserCredential();
      BlocProvider.of<UnitCubit>(
        context,
      )..getActiveUnit();
    });
  }

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
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                if (state.profilePic != null) {
                                  return CircleAvatar(
                                    radius: 50,
                                    foregroundImage:
                                        MemoryImage(state.profilePic!),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: 50,
                                    foregroundImage: AssetImage(
                                      AssetPath.getImage('profile_default.png'),
                                    ),
                                  );
                                }
                              },
                            ),
                            // Positioned(
                            //   right: (AppSize.getAppWidth(context) / 2) - 54,
                            //   bottom: 5,
                            //   child: Container(
                            //     width: 32,
                            //     height: 32,
                            //     decoration: BoxDecoration(
                            //       color: primaryColor,
                            //       shape: BoxShape.circle,
                            //       border: Border.all(
                            //         color: scaffoldBackgroundColor,
                            //       ),
                            //     ),
                            //     child: Center(
                            //       child: SvgPicture.asset(
                            //         AssetPath.getIcon('camera_filled.svg'),
                            //         width: 16,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                Text(
                  widget.credential?.fullname ?? '-',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Student',
                  style: TextStyle(color: secondaryColor),
                ),
                const SizedBox(height: 28),
                ProfileItemMenuCard(
                  iconPath: 'person_filled.svg',
                  title: 'Personal Data',
                  onTap: () => context.navigateTo(PersonalDataPage(
                    userId: widget.credential!.id!,
                  )),
                ),
                const SizedBox(height: 14),
                BlocBuilder<UnitCubit, UnitState>(
                  builder: (context, state1) {
                    if (state1 is GetActiveUnitSuccess)
                      return BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return ProfileItemMenuCard(
                            iconPath: 'stats_chart_filled.svg',
                            title: 'Unit Statisics',
                            onTap: () => context.navigateTo(UnitStatisticsPage(
                              credential: widget.credential,
                              profilePic: state.profilePic,
                              activeUnitModel: state1.activeUnit,
                            )),
                          );
                        },
                      );
                    else
                      return SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 14),
                ProfileItemMenuCard(
                  iconPath: 'file_export_filled.svg',
                  title: 'Export Data',
                  onTap: () => context.navigateTo(const ExportDataPage()),
                ),
                // const SizedBox(height: 14),
                // ProfileItemMenuCard(
                //   iconPath: 'lock_filled.svg',
                //   title: 'Change Password',
                //   onTap: () => context.navigateTo(const ChangePasswordPage()),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
