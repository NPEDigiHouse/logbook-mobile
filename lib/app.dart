import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/utils/keys.dart';
import 'package:elogbook/src/presentation/features/wrapper/wrapper.dart';
import 'package:elogbook/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: primaryColor,
        statusBarColor: primaryColor,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: AppSettings.title,
      theme: lightTheme,
      home: Wrapper(),
    );
  }
}
