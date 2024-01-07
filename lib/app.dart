import 'package:common/features/splash/splash_page.dart';
import 'package:core/app/app_settings.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/utils/keys.dart';
import 'package:main/main.exports.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:supervisor/features/assesment/providers/mini_cex_provider.dart';
import 'package:supervisor/features/assesment/providers/scientific_assignment_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes/light_theme.dart';
import 'injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<OnetimeInternetCheckCubit>()),
        BlocProvider(create: (_) => di.locator<RealtimeInternetCheckCubit>()),
        BlocProvider(create: (_) => di.locator<WrapperCubit>()),
        BlocProvider(create: (_) => di.locator<ResetPasswordCubit>()),
        BlocProvider(create: (_) => di.locator<RegisterCubit>()),
        BlocProvider(create: (_) => di.locator<LogoutCubit>()),
        BlocProvider(create: (_) => di.locator<LoginCubit>()),
        BlocProvider(create: (_) => di.locator<DeleteAccountCubit>()),
        BlocProvider(create: (_) => di.locator<DepartmentCubit>()),
        BlocProvider(create: (_) => di.locator<SupervisorsCubit>()),
        BlocProvider(create: (_) => di.locator<ClinicalRecordCubit>()),
        BlocProvider(create: (_) => di.locator<ScientificSessionCubit>()),
        BlocProvider(create: (_) => di.locator<SelfReflectionCubit>()),
        BlocProvider(create: (_) => di.locator<CompetenceCubit>()),
        BlocProvider(create: (_) => di.locator<SglCstCubit>()),
        BlocProvider(create: (_) => di.locator<UserCubit>()),
        BlocProvider(
            create: (_) => di.locator<SelfReflectionSupervisorCubit>()),
        BlocProvider(
            create: (_) => di.locator<ClinicalRecordSupervisorCubit>()),
        BlocProvider(
            create: (_) => di.locator<ScientificSessionSupervisorCubit>()),
        BlocProvider(create: (_) => di.locator<DailyActivityCubit>()),
        BlocProvider(create: (_) => di.locator<ActivityCubit>()),
        BlocProvider(create: (_) => di.locator<StudentCubit>()),
        BlocProvider(create: (_) => di.locator<AssesmentCubit>()),
        BlocProvider(create: (_) => di.locator<ReferenceCubit>()),
        BlocProvider(create: (_) => di.locator<SpecialReportCubit>()),
        BlocProvider(create: (_) => di.locator<HistoryCubit>()),
        ChangeNotifierProvider(create: (_) => di.locator<MiniCexProvider>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<ClinicalRecordDataNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<ScientificAssignmentProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: AppSettings.title,
        theme: lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
