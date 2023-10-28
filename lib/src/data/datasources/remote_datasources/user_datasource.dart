import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/services/token_manager.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/data/models/user/user_profile_post_model.dart';
import 'package:path/path.dart';

abstract class UserDataSource {
  Future<Either<Failure, void>> updateUserProfilePicture(
      {required String path});
  Future<Either<Failure, Uint8List?>> getUserProfilePicture();
  Future<Either<Failure, Uint8List>> getProfilePic({required String userId});
  Future<Either<Failure, UserCredential>> getUserCredential();
  Future<Either<Failure, void>> updateUserProfile(
      {required UserProfilePostModel userProfilePostModel});
  Future<Either<Failure, String>> uploadProfilePicture(String path);
  Future<Either<Failure, void>> removeProfilePicture();
  Future<Either<Failure, void>> updateFullName({required String fullname});
  Future<Either<Failure, void>> deleteUser();
  Future<Either<Failure, void>> changePassword({required String newPassword});
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;
  final AuthPreferenceHandler pref;
  final TokenInterceptor tokenInterceptor;

  final ApiHeader apiHeader;

  UserDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader,
      required this.pref}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, UserCredential>> getUserCredential() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<Map<String, dynamic>>.fromJson(response.data);
      UserCredential userCredential =
          UserCredential.fromJson(dataResponse.data);
      return Right(userCredential);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String path) async {
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.userOptions(),
        data: FormData.fromMap(
          {
            'pic': await MultipartFile.fromFile(
              path,
              filename: basename(path),
            ),
          },
        ),
      );
      return Right(await response.data['data']);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateFullName(
      {required String fullname}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
        data: {
          'fullname': fullname,
        },
      );
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      await dio.delete(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
      );

      await pref.removeCredential();
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeProfilePicture() async {
    try {
      await dio.delete(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.userOptions(),
      );
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      {required String newPassword}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
        data: {
          'password': newPassword,
        },
      );
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(
      {required UserProfilePostModel userProfilePostModel}) async {
    try {
      await dio.put(ApiService.baseUrl + '/users',
          options: await apiHeader.userOptions(),
          data: userProfilePostModel.toJson());
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfilePicture(
      {required String path}) async {
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(path),
    });
    try {
      await dio.post(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.fileOptions(),
        data: formData,
      );
      return Right(true);
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> getUserProfilePicture() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.fileOptions(withType: true),
      );

      final List<int> bytes = response.data;
      return Right(Uint8List.fromList(bytes));
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getProfilePic(
      {required String userId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users/${userId}/pic',
        options: await apiHeader.fileOptions(withType: true),
      );
      final List<int> bytes = response.data;
      return Right(Uint8List.fromList(bytes));
    } catch (e) {
      return Left(ClientFailure(e.toString()));
    }
  }
}
