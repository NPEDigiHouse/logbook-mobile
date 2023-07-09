import 'package:dio/dio.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/auth_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/unit_datasource.dart';
import 'package:elogbook/src/data/repositories/auth_repository_impl.dart';
import 'package:elogbook/src/data/repositories/unit_repository_impl.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';
import 'package:elogbook/src/domain/repositories/unit_repository.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/generate_token_reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/is_sign_in_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/logout_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/reset_password_usecase.dart';
import 'package:elogbook/src/domain/usecases/unit_usecases/fetch_units_usecase.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
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
    ),
  );

  locator.registerFactory(
    () => UnitCubit(
      fetchUnitsUsecase: locator(),
    ),
  );
}

void _injectExternalResources() {
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton<AuthPreferenceHandler>(
      () => AuthPreferenceHandler());
}
