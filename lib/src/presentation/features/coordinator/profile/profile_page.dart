import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/reusable_function_helper.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/profile/personal_data_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/about_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/change_password_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/contact_us_page.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/image_preview.dart';
import 'package:elogbook/src/presentation/widgets/profile_pic_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/profile_item_menu_card.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CoordinatorProfilePage extends StatefulWidget {
  const CoordinatorProfilePage({super.key});

  @override
  State<CoordinatorProfilePage> createState() => _CoordinatorProfilePageState();
}

class _CoordinatorProfilePageState extends State<CoordinatorProfilePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      BlocProvider.of<ProfileCubit>(context)..getProfilePic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: <Widget>[
            const MainAppBar(
              withLogout: false,
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: <Widget>[
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: primaryColor,
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
                                    top: 16,
                                    child: Column(
                                      children: <Widget>[
                                        BlocBuilder<ProfileCubit, ProfileState>(
                                          builder: (context, state) {
                                            if (state.profilePic != null &&
                                                state.rspp ==
                                                    RequestState.data) {
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () => context
                                                        .navigateTo(ImagePreview(
                                                            byte: state
                                                                .profilePic!,
                                                            tag:
                                                                'profile_image')),
                                                    child: Hero(
                                                      tag: 'profile_image',
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 2,
                                                              color:
                                                                  scaffoldBackgroundColor,
                                                              strokeAlign:
                                                                  BorderSide
                                                                      .strokeAlignOutside),
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: MemoryImage(
                                                              state.profilePic!,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return ProfilePicPlaceholder(
                                                  height: 100,
                                                  name: state.userCredential
                                                          ?.fullname ??
                                                      'U',
                                                  width: 100);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          state.userCredential?.fullname ??
                                              '...',
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'ID. ${state.userCredential?.supervisor?.supervisorId}',
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: onDisableColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Align(
                        child: Text(
                          'User Roles',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              label: Text('Medical Education Coordinator'),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            if (state.userCredential != null)
                              ...state.userCredential!.badges!
                                  .map(
                                    (e) => Row(
                                      children: [
                                        Chip(
                                          backgroundColor: primaryColor,
                                          side: BorderSide.none,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          labelStyle:
                                              textTheme.bodyMedium?.copyWith(
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
                    ),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state.userCredential != null) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                if (state.userCredential!.supervisor!.locations!
                                        .isNotEmpty ||
                                    state.userCredential!.supervisor!.units!
                                        .isNotEmpty) ...[
                                  Align(
                                    child: Text(
                                      'Department & Location',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                ],
                                if (state.userCredential!.supervisor!.locations!
                                    .isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place,
                                        size: 20,
                                        color: secondaryColor,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.userCredential!.supervisor!
                                              .locations!
                                              .join(','),
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: secondaryColor,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (state.userCredential!.supervisor!.units!
                                    .isNotEmpty) ...[
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_hospital_rounded,
                                        size: 20,
                                        color: secondaryColor,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${state.userCredential!.supervisor!.units!.join(',').toUpperCase()}",
                                          maxLines: 2,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    SectionDivider(),
                    const SizedBox(height: 16),
                    ProfileItemMenuCard(
                      iconPath: 'person_filled.svg',
                      title: 'Personal Data',
                      onTap: () {
                        context.navigateTo(LecturerPersonalDataPage());
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileItemMenuCard(
                      iconPath: 'lock_filled.svg',
                      title: 'Change Password',
                      onTap: () =>
                          context.navigateTo(const ChangePasswordPage()),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Align(
                        child: Text(
                          'About',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileItemMenuCard(
                      iconPath: 'about_icon.svg',
                      title: 'About E-Logbook',
                      onTap: () => context.navigateTo(const AboutPage()),
                    ),
                    const SizedBox(height: 12),
                    ProfileItemMenuCard(
                      iconPath: 'help_icon.svg',
                      title: 'Contact Us',
                      onTap: () => context.navigateTo(const ContactUsPage()),
                    ),
                    const SizedBox(height: 12),
                    ProfileItemMenuCard(
                        iconPath: 'rate_icon.svg',
                        title: 'Rate Us',
                        onTap: () => Utils.urlLauncher(Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=com.npedigital.elogbook'
                            : 'https://apps.apple.com/us/app/e-logbook-umi/id6463897571')),
                    const SizedBox(height: 16),
                    Text(
                      'E-Logbook FK UMI Versiion ${AppSettings.appVersion}',
                      style: textTheme.titleSmall?.copyWith(
                        color: onFormDisableColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProfileItemMenuCardVariant(
                      iconPath: 'delete_icon.svg',
                      title: 'Log Out',
                      onTap: () {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          title: 'Confirm Logout',
                          confirmBtnText: 'Confirm',
                          text: "Are you sure to sign out?",
                          onConfirmBtnTap: () async {
                            await BlocProvider.of<ProfileCubit>(context)
                                .reset();
                            await BlocProvider.of<AuthCubit>(context).logout();
                          },
                          confirmBtnColor: primaryColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
