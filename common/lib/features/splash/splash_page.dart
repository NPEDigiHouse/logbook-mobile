import 'dart:async';

import 'package:core/app/app_settings.dart';
import 'package:core/helpers/app_size.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';

import '../wrapper/wrapper.dart';
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
    // Will change page after two second
    super.didChangeDependencies();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Wrapper(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Container(
        width: AppSize.getAppWidth(context),
        height: AppSize.getAppHeight(context),
        color: primaryColor,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetPath.getIcon('logo.svg'),
                    width: 150,
                    height: 150,
                    color: scaffoldBackgroundColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "E-Logbook",
                    style: textTheme.headlineSmall?.copyWith(
                        color: scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              child: SizedBox(
                width: AppSize.getAppWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version ${AppSettings.appVersion}",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: scaffoldBackgroundColor),
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
