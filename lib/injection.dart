import 'package:data/datasources/remote_datasources/notification_datasource.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:dio/dio.dart';
import 'package:main/blocs/notification_cubit/notification_cubit.dart';
import 'package:main/main.exports.dart';
import 'package:data/data.exports.dart';
import 'package:get_it/get_it.dart';
import 'package:students/features/clinical_record/providers/clinical_record_data_notifier.dart';
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
  locator.registerLazySingleton<NotificationDataSource>(
    () => NotificationDataSourceImpl(
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
    () => SupervisorCubit2(
      dataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ClinicalRecordCubit(
      clinicalRecordsDatasource: locator(),
      studentCubit: locator(),
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
    () => NotificationCubit(
      dataSource: locator(),
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
    () => ClinicalRecordDataNotifier(),
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
