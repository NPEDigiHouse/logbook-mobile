import 'package:data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:data/datasources/remote_datasources/activity_datasource.dart';
import 'package:data/datasources/remote_datasources/assesment_datasource.dart';
import 'package:data/datasources/remote_datasources/auth_datasource.dart';
import 'package:data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:data/datasources/remote_datasources/competence_datasource.dart';
import 'package:data/datasources/remote_datasources/daily_activity_datasource.dart';
import 'package:data/datasources/remote_datasources/history_datasource.dart';
import 'package:data/datasources/remote_datasources/reference_datasource.dart';
import 'package:data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:data/datasources/remote_datasources/special_report_datasource.dart';
import 'package:data/datasources/remote_datasources/student_datasource.dart';
import 'package:data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:data/datasources/remote_datasources/unit_datasource.dart';
import 'package:data/datasources/remote_datasources/user_datasource.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:dio/dio.dart';
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
import 'package:get_it/get_it.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_notifier2.dart';
import 'package:supervisor/features/assesment/providers/mini_cex_provider.dart';
import 'package:supervisor/features/assesment/providers/scientific_assignment_provider.dart';

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
    () => DeleteAccountCubit(
      userDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => LoginCubit(
      authDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => LogoutCubit(
      authDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => RegisterCubit(
      authDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ResetPasswordCubit(
      authDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => WrapperCubit(
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
  locator.registerLazySingleton(() => ApiHeader());
  locator.registerLazySingleton<AuthPreferenceHandler>(
      () => AuthPreferenceHandler());
}
