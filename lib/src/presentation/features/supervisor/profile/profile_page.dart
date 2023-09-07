import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/profile/personal_data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
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
      BlocProvider.of<ProfileCubit>(context)..getProfilePic();
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
                        child: BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            print(state.rspp);
                            if (state.profilePic != null &&
                                state.rspp == RequestState.data) {
                              return Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 5,
                                          color: scaffoldBackgroundColor,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: MemoryImage(
                                          state.profilePic!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    foregroundImage: AssetImage(
                                      AssetPath.getImage('profile_default.png'),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          state.userCredential != null
                              ? state.userCredential!.fullname!
                              : '...',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (state.userCredential != null) {
                              if (state.userCredential!.supervisor!.locations!
                                  .isNotEmpty) {
                                return Text(
                                  state.userCredential!.supervisor!.locations!
                                      .join(','),
                                );
                              }
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        Builder(
                          builder: (context) {
                            if (state.userCredential != null) {
                              if (state.userCredential!.supervisor!.units!
                                  .isNotEmpty) {
                                return Text(
                                  state.userCredential!.supervisor!.units!
                                      .join(','),
                                );
                              }
                            }
                            return SizedBox.shrink();
                          },
                        )
                      ],
                    );
                  },
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Chip(
                    backgroundColor: primaryColor,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    labelStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                    label: Text(widget.credential.role ?? 'SUPERVISOR'),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  ...widget.credential.badges!
                      .map(
                        (e) => Row(
                          children: [
                            Chip(
                              backgroundColor: primaryColor,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              labelStyle: textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                              label: Text(e.name!),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      )
                      .toList()
                ]),
                const SizedBox(height: 12),
                ProfileItemMenuCard(
                  iconPath: 'person_filled.svg',
                  title: 'Personal Data',
                  onTap: () {
                    context.navigateTo(LecturerPersonalDataPage());
                  },
                ),
                // const SizedBox(height: 14),
                // ProfileItemMenuCard(
                //   iconPath: 'person_filled.svg',
                //   title: 'Statistic Data',
                //   onTap: () {},
                // ),
                // const SizedBox(height: 14),
                // ProfileItemMenuCard(
                //   iconPath: 'file_export_filled.svg',
                //   title: 'Export Data',
                //   onTap: () {},
                // ),
                // const SizedBox(height: 14),
                // ProfileItemMenuCard(
                //   iconPath: 'lock_filled.svg',
                //   title: 'Change Password',
                //   onTap: () {},
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
