import 'dart:async';

import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/common/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
      backgroundColor: primaryColor,
      body: Container(
        width: AppSize.getAppWidth(context),
        height: AppSize.getAppHeight(context),
        color: primaryColor,
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                AssetPath.getVector('splash_icon.svg'),
                width: 150,
                height: 150,
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
                          ?.copyWith(color: backgroundColor),
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
