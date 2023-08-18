import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_data.dart';
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
