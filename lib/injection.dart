import 'package:dio/dio.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/history_cubit/history_cubit.dart';
import 'package:elogbook/src/presentation/blocs/onetime_internet_check/onetime_internet_check_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:elogbook/src/presentation/blocs/realtime_internet_check/realtime_internet_check_cubit.dart';
import 'package:elogbook/src/presentation/blocs/reference/reference_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_cubit/scientific_session_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/blocs/student_cubit/student_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:get_it/get_it.dart';

import 'src/data/datasources/datasources.export.dart';

final locator = GetIt.instance;

void init() {
  _injectDatasource();
  _injectStateManagement();
  _injectExternalResources();
}

void _injectDatasource() {
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      dio: locator(),
      tokenInterceptor: locator(),
      preferenceHandler: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<DepartmentDatasource>(
    () => DepartmentDatasourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      authDataSource: locator<AuthDataSource>(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<SupervisorsDataSource>(
    () => SupervisorsDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<HistoryDataSource>(
    () => HistoryDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<ClinicalRecordsDatasource>(
    () => ClinicalRecordsDatasourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<ReferenceDataSource>(
    () => ReferenceDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<SpecialReportDataSource>(
    () => SpecialReportDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<ScientificSessionDataSource>(
    () => ScientificSessionDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<SelfReflectionDataSource>(
    () => SelfReflectionDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<CompetenceDataSource>(
    () => CompetenceDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<SglCstDataSource>(
    () => SglCstDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );

  locator.registerLazySingleton<DailyActivityDataSource>(
    () => DailyActivityDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<ActivityDataSource>(
    () => ActivityDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<StudentDataSource>(
    () => StudentDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
  locator.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
      pref: locator(),
    ),
  );
  locator.registerLazySingleton<AssesmentDataSource>(
    () => AssesmentDataSourceImpl(
      tokenInterceptor: locator(),
      dio: locator(),
      apiHeader: locator(),
    ),
  );
}

void _injectStateManagement() {
  //Auth
  locator.registerFactory(
    () => AuthCubit(
      authDataSource: locator(),
      userDataSource: locator(),
    ),
  );

  locator.registerFactory(
    () => DepartmentCubit(
      datasource: locator(),
    ),
  );
  locator.registerFactory(
    () => SupervisorsCubit(
      dataSource: locator(),
      profileDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ClinicalRecordCubit(
      clinicalRecordsDatasource: locator(),
    ),
  );
  locator.registerFactory(
    () => ScientificSessionCubit(
      ds: locator(),
    ),
  );
  locator.registerFactory(
    () => SelfReflectionCubit(
      ds: locator(),
    ),
  );
  locator.registerFactory(
    () => AssesmentCubit(
      dataSource: locator(),
      studentDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => CompetenceCubit(
      competenceDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => SglCstCubit(
      dataSource: locator(),
      studentDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => UserCubit(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ClinicalRecordSupervisorCubit(
      datasource: locator(),
    ),
  );
  locator.registerFactory(
    () => ScientificSessionSupervisorCubit(
      datasource: locator(),
    ),
  );
  locator.registerFactory(
    () => SelfReflectionSupervisorCubit(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => DailyActivityCubit(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ActivityCubit(
      datasource: locator(),
    ),
  );
  locator.registerFactory(
    () => StudentCubit(
      dataSource: locator(),
      dataSourceSp: locator(),
    ),
  );

  locator.registerFactory(
    () => HistoryCubit(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => OnetimeInternetCheckCubit(),
  );
  locator.registerFactory(
    () => RealtimeInternetCheckCubit(),
  );

  locator.registerFactory(
    () => MiniCexProvider(),
  );
  locator.registerFactory(
    () => ClinicalRecordDataNotifier2(),
  );
  locator.registerFactory(
    () => ScientificAssignmentProvider(),
  );
  locator.registerFactory(
    () => ReferenceCubit(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => SpecialReportCubit(
      specialReportDataSource: locator(),
      studentDataSource: locator(),
    ),
  );
}

void _injectExternalResources() {
  locator.registerLazySingleton<TokenManager>(() => TokenManager(
      dio: locator(), apiHeader: locator(), preferenceHandler: locator()));
  locator.registerLazySingleton<TokenInterceptor>(
      () => TokenInterceptor(tokenManager: locator()));
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton(() => ApiHeader(preference: locator()));
  locator.registerLazySingleton<AuthPreferenceHandler>(
      () => AuthPreferenceHandler());
}
