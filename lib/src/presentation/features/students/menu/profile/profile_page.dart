import 'dart:math';

import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
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
      BlocProvider.of<DepartmentCubit>(
        context,
      )..getActiveDepartment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SuccessDeleteAccount) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Success Delete Account'),
              backgroundColor: successColor,
            ),
          );
        }
      },
      child: CustomScrollView(
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
                                      ],
                                    );
                                  } else {
                                    return CircleAvatar(
                                      radius: 50,
                                      foregroundImage: AssetImage(
                                        AssetPath.getImage(
                                            'profile_default.png'),
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
                  Text(
                    'Student',
                    style: textTheme.bodyLarge?.copyWith(
                      color: secondaryColor,
                    ),
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
                  BlocBuilder<DepartmentCubit, DepartmentState>(
                    builder: (context, state1) {
                      if (state1 is GetActiveDepartmentSuccess)
                        return BlocBuilder<ProfileCubit, ProfileState>(
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
                  // const SizedBox(height: 14),
                  // BlocBuilder<ProfileCubit, ProfileState>(
                  //   builder: (context, state) {
                  //     if (state.requestState == RequestState.data) {
                  //       return ProfileItemMenuCard(
                  //         iconPath: 'file_export_filled.svg',
                  //         title: 'Export Data',
                  //         onTap: () => context.navigateTo(ExportDataPage(
                  //           memoryImage: state.profilePic,
                  //         )),
                  //       );
                  //     } else {
                  //       return SizedBox.shrink();
                  //     }
                  //   },
                  // ),

                  const SizedBox(height: 14),
                  ProfileItemMenuCard(
                    iconPath: 'delete_icon.svg',
                    title: 'Delete Account',
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => InputFinalScoreDialog(),
                      );
                    },
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
      ),
    );
  }
}

class InputFinalScoreDialog extends StatefulWidget {
  const InputFinalScoreDialog({
    super.key,
  });

  @override
  State<InputFinalScoreDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<InputFinalScoreDialog> {
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
                      BlocProvider.of<AuthCubit>(context)..deleteAccount();
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
