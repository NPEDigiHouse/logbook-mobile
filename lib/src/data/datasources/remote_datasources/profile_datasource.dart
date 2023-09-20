import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/students/student_post_model.dart';
import 'package:elogbook/src/data/models/user/user_profile_post_model.dart';

abstract class ProfileDataSource {
  Future<void> updateUserProfile(
      {required UserProfilePostModel userProfilePostModel});

  Future<void> updateStudentData(
      {required StudentPostModel studentDataPostModel});
  Future<void> updateUserProfilePicture({required String path});
  Future<Uint8List?> getUserProfilePicture();
  Future<Uint8List> getProfilePic({required String userId});
}

class ProfileDataSourceImpl extends ProfileDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ProfileDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<void> updateUserProfile(
      {required UserProfilePostModel userProfilePostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.put(ApiService.baseUrl + '/users',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: userProfilePostModel.toJson());
      // if (response != 201) {
      //   throw Exception();
      // }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateUserProfilePicture({required String path}) async {
    final credential = await preferenceHandler.getCredential();
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(path),
    });
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/users/pic',
        options: Options(
          headers: {
            "content-type": 'multipart/form-data',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: formData,
      );
      // if (response != 201) {
      //   throw Exception();
      // }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<Uint8List?> getUserProfilePicture() async {
    try {
      final credential = await preferenceHandler.getCredential();
      final response = await dio.get(
        ApiService.baseUrl + '/users/pic',
        options: Options(
          headers: {
            "content-type": 'multipart/form-data',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          responseType: ResponseType.bytes,
        ),
      );

      final List<int> bytes = response.data;
      return Uint8List.fromList(bytes);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateStudentData(
      {required StudentPostModel studentDataPostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.put(ApiService.baseUrl + '/students',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: studentDataPostModel.toJson());
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<Uint8List> getProfilePic({required String userId}) async {
    try {
      final credential = await preferenceHandler.getCredential();
      final response = await dio.get(
        ApiService.baseUrl + '/users/${userId}/pic',
        options: Options(
          headers: {
            "content-type": 'multipart/form-data',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          responseType: ResponseType.bytes,
        ),
      );
      print(response.statusCode);
      if (response.statusCode! >= 400) {
        throw Exception();
      } else {
        final List<int> bytes = response.data;
        return Uint8List.fromList(bytes);
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
