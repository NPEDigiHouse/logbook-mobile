// ignore_for_file: void_checks, unnecessary_null_comparison

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:data/models/user/user_token.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:dio/dio.dart';

abstract class AuthDataSource {
  Future<Either<Failure, void>> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email});

  Future<Either<Failure, void>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, UserCredential>> getUserCredential();
  Future<Either<Failure, bool>> isSignIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String>> generateTokenResetPassword(
      {required String email});
  Future<Either<Failure, void>> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  AuthDataSourceImpl(
      {required this.dio,
      required this.tokenInterceptor,
      required this.preferenceHandler,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, void>> register({
    required String username,
    required String studentId,
    required String password,
    String? fullname,
    required String email,
  }) async {
    try {
      // Split First and Last Name
      String? firstName;
      String? lastName;
      if (fullname != null && fullname.isNotEmpty) {
        final splitName = fullname.split(' ');
        firstName = splitName.first;
        if (splitName.length > 1) {
          lastName = fullname.substring(firstName.length + 1, fullname.length);
        }
      }
      await dio.post(
        '${ApiService.baseUrl}/students',
        options: apiHeader.adminOptions(),
        data: {
          "username": username,
          "password": password,
          "studentId": studentId,
          "email": email,
          if (firstName != null) "firstName": firstName,
          if (lastName != null) "lastName": lastName,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> login(
      {required String username, required String password}) async {
    try {
      if (username == "admin") {
        throw const ClientFailure(
            "User with role admin cannot login in mobile app");
      }
      final response = await dio.post(
        '${ApiService.baseUrl}/users/login',
        options: apiHeader.loginOptions(username, password),
      );
      final dataResponse = DataResponse.fromJson(response.data);
      UserToken credential = UserToken.fromJson(dataResponse.data);
      await preferenceHandler.setUserData(credential);
      CredentialSaver.credential = credential;
      return const Right(true);
    } catch (e) {
      print(e.toString());
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignIn() async {
    try {
      UserToken? credential = await preferenceHandler.getCredential();

      return Right(credential != null);
    } catch (e) {
      print(e.toString());

      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await preferenceHandler.removeCredential();
      CredentialSaver.credential = null;
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, String>> generateTokenResetPassword(
      {required String email}) async {
    try {
      final response = await dio.post(
        '${ApiService.baseUrl}/students/reset-password',
        options: apiHeader.adminOptions(),
        data: {
          'email': email,
        },
      );
      final Map<String, dynamic> responseData =
          DataResponse<Map<String, dynamic>>.fromJson(response.data).data;
      return Right(responseData['token']);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  }) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/students/reset-password/$token',
        options: apiHeader.adminOptions(),
        data: {
          'otp': otp,
          'newPassword': newPassword,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> getUserCredential() async {
    try {
      const Duration timeoutDuration = Duration(seconds: 7);

      final response = await dio
          .get(
            '${ApiService.baseUrl}/users',
            options: await apiHeader.userOptions(),
          )
          .timeout(timeoutDuration);

      final dataResponse =
          DataResponse<Map<String, dynamic>>.fromJson(response.data);
      UserCredential userCredential =
          UserCredential.fromJson(dataResponse.data);
      return Right(userCredential);
    } catch (e) {
      print(e.toString());
      if (e is TimeoutException) {
        return Left(failure("Operation timed out"));
      } else {
        return Left(failure(e));
      }
    }
  }
}