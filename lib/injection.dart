import 'package:dio/dio.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/activity_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/assesment_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/clinical_record_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/competence_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/daily_activity_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/history_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/profile_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/reference_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/scientific_session_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/self_reflection_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/sglcst_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/special_report_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/user_datasource.dart';
import 'package:elogbook/src/data/repositories/auth_repository_impl.dart';
import 'package:elogbook/src/data/repositories/clinical_record_repository_impl.dart';
import 'package:elogbook/src/data/repositories/scientific_session_repository_impl.dart';
import 'package:elogbook/src/data/repositories/self_reflection_repository_datasource.dart';
import 'package:elogbook/src/data/repositories/supervisor_repository_impl.dart';
import 'package:elogbook/src/data/repositories/unit_repository_impl.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';
import 'package:elogbook/src/domain/repositories/clinical_record_repository.dart';
import 'package:elogbook/src/domain/repositories/scientific_sesion_repository.dart';
import 'package:elogbook/src/domain/repositories/self_reflection_repository.dart';
import 'package:elogbook/src/domain/repositories/supervisor_repository.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/generate_token_reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/get_credential_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/is_sign_in_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/logout_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_affected_parts_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_diagnosis_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_examination_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_management_roles_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/get_management_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/upload_clinical_record_attachment_usecase.dart';
import 'package:elogbook/src/domain/usecases/clinical_record_usecases/upload_clinical_record_usecase.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/get_list_session_types_usecase.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/get_scientific_roles_usecase.dart';
import 'package:elogbook/src/domain/usecases/scientific_session_usecases/upload_scientific_session_usecase.dart';
import 'package:elogbook/src/domain/usecases/self_reflection_usecases/upload_self_reflection_usecase.dart';
import 'package:elogbook/src/domain/usecases/supervisor_usecases/get_all_supervisors_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/change_unit_active_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/check_in_active_unit_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/get_active_unit_usecase.dart';
import 'package:elogbook/src/presentation/blocs/activity_cubit/activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/competence_cubit/competence_cubit.dart';
import 'package:elogbook/src/presentation/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:elogbook/src/presentation/blocs/history_cubit/history_cubit.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
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
import 'package:elogbook/src/presentation/features/students/clinical_record/providers/clinical_record_data_notifier.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/mini_cex_provider.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/providers/scientific_assignment_provider.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  _injectRepository();
  _injectDatasource();
  _injectUsecases();
  _injectStateManagement();
  _injectExternalResources();
}

void _injectRepository() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<UnitRepository>(
    () => UnitReposityImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ScientificSessionRepository>(
    () => ScientificSessionRepositoryImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<SupervisorRepository>(
    () => SupervisorRepositoryImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ClinicalRecordRepository>(
    () => ClinicalRecordRepositoryImpl(
      dataSource: locator(),
    ),
  );
  locator.registerLazySingleton<SelfReflecttionRepository>(
    () => SelfReflectionRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void _injectDatasource() {
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<UnitDatasource>(
    () => UnitDatasourceImpl(
      dio: locator(),
      authDataSource: locator<AuthDataSource>(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<SupervisorsDataSource>(
    () => SupervisorsDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<HistoryDataSource>(
    () => HistoryDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<ClinicalRecordsDatasource>(
    () => ClinicalRecordsDatasourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<ReferenceDataSource>(
    () => ReferenceDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<SpecialReportDataSource>(
    () => SpecialReportDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<ScientificSessionDataSource>(
    () => ScientificSessionDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<SelfReflectionDataSource>(
    () => SelfReflectionDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<CompetenceDataSource>(
    () => CompetenceDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<SglCstDataSource>(
    () => SglCstDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<ProfileDataSource>(
    () => ProfileDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<DailyActivityDataSource>(
    () => DailyActivityDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<ActivityDataSource>(
    () => ActivityDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<StudentDataSource>(
    () => StudentDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
  locator.registerLazySingleton<AssesmentDataSource>(
    () => AssesmentDataSourceImpl(
      dio: locator(),
      preferenceHandler: locator(),
    ),
  );
}

void _injectUsecases() {
  //Auth Usecase
  locator.registerLazySingleton(
    () => RegisterUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => LoginUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => LogoutUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => IsSignInUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => ResetPasswordUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GenerateTokenResetPasswordUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => FetchUnitsUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetActiveUnitUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => ChangeActiveUnitUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetCredentialUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => CheckInActiveUnitUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetAllSupervisorsUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetAffectedPartsUsecase(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetDiagnosisTypesUsecase(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetExaminationTypesUsecase(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetManagementRolesUsecase(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetManagementTypesUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UploadClinicalRecordAttachmentUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UploadClinicalRecordUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UploadScientificSessionUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetListSessionTypesUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetScientificSessionRolesUsecase(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UploadSelfReflectionUsecase(
      repository: locator(),
    ),
  );
}

void _injectStateManagement() {
  //Auth
  locator.registerFactory(
    () => AuthCubit(
      registerUsecase: locator(),
      loginUsecase: locator(),
      isSignInUsecase: locator(),
      logoutUsecase: locator(),
      generateTokenResetPasswordUsecase: locator(),
      resetPasswordUsecase: locator(),
      getCredentialUsecase: locator(),
    ),
  );

  locator.registerFactory(
    () => UnitCubit(
      fetchUnitsUsecase: locator(),
      changeActiveUnitUsecase: locator(),
      getActiveUnitUsecase: locator(),
      checkInActiveUnitUsecase: locator(),
      datasource: locator(),
    ),
  );
  locator.registerFactory(
    () => SupervisorsCubit(
      getAllSupervisorsUsecase: locator(),
      dataSource: locator(),
      profileDataSource: locator(),
    ),
  );
  locator.registerFactory(
    () => ClinicalRecordCubit(
      getAffectedPartsUsecase: locator(),
      getDiagnosisTypesUsecase: locator(),
      getExaminationTypesUsecase: locator(),
      getManagementRolesUsecase: locator(),
      getManagementTypesUsecase: locator(),
      uploadClinicalRecordAttachmentUsecase: locator(),
      uploadClinicalRecordUsecase: locator(),
      clinicalRecordsDatasource: locator(),
    ),
  );
  locator.registerFactory(
    () => ScientificSessionCubit(
      getListSessionTypesUsecase: locator(),
      getScientificSessionRolesUsecase: locator(),
      uploadScientificSessionUsecase: locator(),
      ds: locator(),
    ),
  );
  locator.registerFactory(
    () => SelfReflectionCubit(
      selfReflectionUsecase: locator(),
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
    () => ProfileCubit(
      dataSource: locator(),
      userDataSource: locator(),
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
    ),
  );
  locator.registerFactory(
    () => HistoryCubit(
      dataSource: locator(),
    ),
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
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton<AuthPreferenceHandler>(
      () => AuthPreferenceHandler());
}
