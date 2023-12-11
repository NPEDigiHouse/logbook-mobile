import 'package:common/splash/splash_page.dart';
import 'package:core/app/app_settings.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/utils/keys.dart';
import 'package:main/blocs/activity_cubit/activity_cubit.dart';
import 'package:main/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:main/blocs/competence_cubit/competence_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/blocs/delete_account_cubit/delete_account_cubit.dart';
import 'package:main/blocs/history_cubit/history_cubit.dart';
import 'package:main/blocs/login_cubit/login_cubit.dart';
import 'package:main/blocs/logout_cubit/logout_cubit.dart';
import 'package:main/blocs/onetime_internet_check/onetime_internet_check_cubit.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';
import 'package:main/blocs/realtime_internet_check/realtime_internet_check_cubit.dart';
import 'package:main/blocs/reference/reference_cubit.dart';
import 'package:main/blocs/register_cubit/register_cubit.dart';
import 'package:main/blocs/reset_password_cubit/reset_password_cubit.dart';
import 'package:main/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:main/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:main/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:main/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:main/blocs/special_report/special_report_cubit.dart';
import 'package:main/blocs/student_cubit/student_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/blocs/wrapper_cubit/wrapper_cubit.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:supervisor/assesment/providers/scientific_assignment_provider.dart';

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
            create: (_) => di.locator<ClinicalRecordDataNotifier2>()),
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
