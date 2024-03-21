import 'dart:async';

import 'package:common/features/auth/login_page.dart';
import 'package:common/features/notification/notification_page.dart';
import 'package:common/features/wrapper/wrapper.dart';
import 'package:coordinator/features/menu/main_menu.dart';
import 'package:core/app/app_settings.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:data/utils/notification_utils.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:students/student_main.dart';
import 'package:supervisor/features/menu/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<WrapperCubit>(context)
        ..reset()
        ..isSignIn();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Wrapper(),
        ),
      );
    });
  }

  void initNotif(BuildContext context, UserRole role) async {
    await NotificationUtils.configureFirebaseMessaging(context, role);
  }

  @override
  Widget build(BuildContext context) {
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
                          style: textTheme.bodyMedium
                              ?.copyWith(color: scaffoldBackgroundColor),
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
}
