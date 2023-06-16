import 'package:dio/dio.dart';
import 'package:elogbook/src/data/datasources/auth_datasource.dart';
import 'package:elogbook/src/data/repositories/auth_repository_impl.dart';
import 'package:elogbook/src/domain/repositories/auth_repository.dart';
import 'package:elogbook/src/domain/usecases/auth_usecases/auth_usecase.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
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
}

void _injectDatasource() {
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      dio: locator(),
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
}

void _injectStateManagement() {
  //Auth
  locator.registerFactory(
    () => AuthCubit(registerUsecase: locator()),
  );
}

void _injectExternalResources() {
  locator.registerLazySingleton(() => Dio());
}
