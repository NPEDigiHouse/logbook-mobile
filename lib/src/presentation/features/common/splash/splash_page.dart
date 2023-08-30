import 'dart:async';

import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/src/presentation/features/common/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.transparent,
      body: Image.asset(
        'assets/splash.png',
        width: AppSize.getAppWidth(context),
        height: AppSize.getAppHeight(context),
        fit: BoxFit.cover,
      ),
    );
  }
}
