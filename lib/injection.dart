import 'package:dio/dio.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/repositories/auth_repository_impl.dart';
import 'package:elogbook/src/data/repositories/supervisor_repository_impl.dart';
import 'package:elogbook/src/data/repositories/unit_repository_impl.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';
import 'package:elogbook/src/domain/repositories/supervisor_repository.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/generate_token_reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/get_credential_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/is_sign_in_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/logout_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/supervisor_usecases/get_all_supervisors_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/change_unit_active_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/check_in_active_unit_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/get_active_unit_usecase.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
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
  locator.registerLazySingleton<SupervisorRepository>(
    () => SupervisorRepositoryImpl(
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
    ),
  );
  locator.registerFactory(
    () => SupervisorsCubit(
      getAllSupervisorsUsecase: locator(),
    ),
  );
}

void _injectExternalResources() {
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton<AuthPreferenceHandler>(
      () => AuthPreferenceHandler());
}
