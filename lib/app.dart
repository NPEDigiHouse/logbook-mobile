import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elogbook/core/app/app_settings.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/utils/keys.dart';
import 'package:elogbook/src/presentation/features/common/wrapper/wrapper.dart';
import 'package:elogbook/themes/light_theme.dart';
import 'package:elogbook/injection.dart' as di;
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
        BlocProvider(create: (_) => di.locator<AuthCubit>()),
        BlocProvider(create: (_) => di.locator<UnitCubit>()),
        BlocProvider(create: (_) => di.locator<SupervisorsCubit>()),
        BlocProvider(create: (_) => di.locator<ClinicalRecordCubit>()),
        BlocProvider(create: (_) => di.locator<ScientificSessionCubit>()),
        BlocProvider(create: (_) => di.locator<SelfReflectionCubit>()),
        BlocProvider(create: (_) => di.locator<CompetenceCubit>()),
        BlocProvider(create: (_) => di.locator<SglCstCubit>()),
        BlocProvider(create: (_) => di.locator<ProfileCubit>()),
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
        ChangeNotifierProvider(create: (_) => di.locator<MiniCexProvider>()),
        ChangeNotifierProvider(create: (_) => di.locator<ClinicalRecordDataNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<ScientificAssignmentProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: AppSettings.title,
        theme: lightTheme,
        home: Wrapper(),
      ),
    );
  }
}
