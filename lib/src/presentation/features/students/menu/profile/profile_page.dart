import 'dart:io';
import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/helpers/utils.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/delete_account_cubit/delete_account_cubit.dart';
import 'package:elogbook/src/presentation/blocs/logout_cubit/logout_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/about_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/change_password_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/contact_us_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_alert.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:elogbook/src/presentation/widgets/image_preview.dart';
import 'package:elogbook/src/presentation/widgets/profile_pic_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/personal_data_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/profile/submenu/unit_statistics_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/widgets/profile_item_menu_card.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';

class ProfilePage extends StatefulWidget {
  final UserCredential credential;
  const ProfilePage({
    super.key,
    required this.credential,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<UserCubit>(context)..getProfilePic();
      BlocProvider.of<DepartmentCubit>(
        context,
      )..getActiveDepartment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteSuccess) {
          CustomAlert.success(
              message: 'Success Delete Account', context: context);
        }
      },
      child: CustomScrollView(
        slivers: <Widget>[
          MainAppBar(
            withLogout: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: <Widget>[
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
                              BlocBuilder<UserCubit, UserState>(
                                builder: (context, state) {
                                  if (state.profilePic != null &&
                                      state.rspp == RequestState.data) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () => context.navigateTo(
                                              ImagePreview(
                                                  byte: state.profilePic!,
                                                  tag: 'profile_image')),
                                          child: Hero(
                                            tag: 'profile_image',
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color:
                                                        scaffoldBackgroundColor,
                                                    strokeAlign: BorderSide
                                                        .strokeAlignOutside),
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
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return ProfilePicPlaceholder(
                                        height: 100,
                                        name: widget.credential.fullname ?? 'U',
                                        width: 100);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.credential?.fullname ?? '-',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'NIM. ${widget.credential.student?.studentId}',
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

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child:
                                BlocBuilder<DepartmentCubit, DepartmentState>(
                              builder: (context, state) {
                                return Text(
                                  state is GetActiveDepartmentSuccess
                                      ? state.activeDepartment.unitName ??
                                          'No Active Department'
                                      : '...',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ProfileItemMenuCard(
                    iconPath: 'person_filled.svg',
                    title: 'Personal Data',
                    onTap: () => context.navigateTo(PersonalDataPage(
                      userId: widget.credential!.id!,
                    )),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<DepartmentCubit, DepartmentState>(
                    builder: (context, state1) {
                      if (state1 is GetActiveDepartmentSuccess)
                        return BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            return ProfileItemMenuCard(
                              iconPath: 'stats_chart_filled.svg',
                              title: 'Department Statisics',
                              onTap: () =>
                                  context.navigateTo(DepartmentStatisticsPage(
                                credential: widget.credential,
                                profilePic: state.profilePic,
                                activeDepartmentModel: state1.activeDepartment,
                                stateProfilePic: state.rspp,
                              )),
                            );
                          },
                        );
                      else
                        return SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileItemMenuCard(
                    iconPath: 'lock_filled.svg',
                    title: 'Change Password',
                    onTap: () => context.navigateTo(const ChangePasswordPage()),
                  ),
                  // const SizedBox(height: 8),
                  // BlocBuilder<ProfileCubit, ProfileState>(
                  //   builder: (context, state) {
                  //     return ProfileItemMenuCard(
                  //       iconPath: 'file_export_filled.svg',
                  //       title: 'Export Data',
                  //       onTap: () => context.navigateTo(ExportDataPage(
                  //         memoryImage: state.requestState == RequestState.data
                  //             ? state.profilePic
                  //             : null,
                  //       )),
                  //     );
                  //   },
                  // ),
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
                    'E-Logbook FK UMI Version ${AppSettings.appVersion}',
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
                          await BlocProvider.of<UserCubit>(context).reset();
                          await BlocProvider.of<LogoutCubit>(context).logout();
                        },
                        confirmBtnColor: primaryColor,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileItemMenuCardVariant2(
                    iconPath: 'delete_icon.svg',
                    title: 'Delete Account',
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => DeleteAccountDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
  });

  @override
  State<DeleteAccountDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<DeleteAccountDialog> {
  final textController = TextEditingController();
  String keyConfirm = '';
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyConfirm = generateRandomString(4);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String generateRandomString(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random();
    String result = '';

    for (int i = 0; i < length; i++) {
      final index = random.nextInt(chars.length);
      result += chars[index];
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 36.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: FocusScope(
          node: _focusScopeNode,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: onFormDisableColor,
                      ),
                      tooltip: 'Close',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Delete Account',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                  ),
                ],
              ),
              ItemDivider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: Text(
                  'Type the text below to confirm account deletion',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: errorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  keyConfirm,
                  style: textTheme.titleMedium?.copyWith(
                    color: scaffoldBackgroundColor,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: errorColor,
                  ),
                  onPressed: () {
                    if (textController.text == keyConfirm) {
                      _focusScopeNode.unfocus();
                      BlocProvider.of<DeleteAccountCubit>(context)
                        ..deleteAccount();
                      context.back();
                    }
                  },
                  child: Text('Confirm'),
                ).fullWidth(),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
