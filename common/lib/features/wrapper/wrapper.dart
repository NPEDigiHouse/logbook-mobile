import 'package:common/features/notification/notification_page.dart';
import 'package:coordinator/features/menu/main_menu.dart';
import 'package:core/app/app_settings.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:data/utils/notification_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/login_cubit/login_cubit.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:students/student_main.dart';
import 'package:supervisor/features/menu/main_menu.dart';

import '../auth/login_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  final bool isFromLogin;
  const Wrapper({super.key, this.isFromLogin = false});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  void initNotif(BuildContext context, UserRole role) async {
    await NotificationUtils.configureFirebaseMessaging(context, role);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<WrapperCubit, WrapperState>(
          builder: (context, state) {
            if (state is WrapperLoading) {
              if (widget.isFromLogin) {
                return const Scaffold(
                  body: CustomLoading(),
                );
              }
              return Scaffold(
                backgroundColor: scaffoldBackgroundColor,
                body: Container(
                  color: primaryColor,
                  width: AppSize.getAppWidth(context),
                  height: AppSize.getAppHeight(context),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.1),
                          ),
                          padding: const EdgeInsets.all(20),
                          width: 240,
                          height: 240,
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.2),
                          ),
                          padding: const EdgeInsets.all(20),
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.3),
                          ),
                          padding: const EdgeInsets.all(30),
                          width: 160,
                          height: 160,
                          child: SvgPicture.asset(
                            AssetPath.getIcon('logo.svg'),
                            width: 100,
                            height: 100,
                            color: scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        child: SizedBox(
                          width: AppSize.getAppWidth(context),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Version ${AppSettings.appVersion} (2024)",
                                    style: textTheme.bodyMedium?.copyWith(
                                        color: scaffoldBackgroundColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            if (state is CredentialExist) {
              final UserCredential credential = state.credential;
              switch (credential.role) {
                case 'SUPERVISOR' || 'DPK':
                  initNotif(context, UserRole.supervisor);
                  return const MainMenuSupervisor();
                case 'ER':
                  initNotif(context, UserRole.coordinator);
                  return const MainMenuCoordinator();
                case 'STUDENT':
                  initNotif(context, UserRole.student);
                  return const StudentMainMenu();
                default:
                  return const LoginPage();
              }
            }
            return const LoginPage();
          },
        );
      },
    );
  }
}
