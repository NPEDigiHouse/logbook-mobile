import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
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
  final ApiHeader apiHeader;

  ProfileDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<void> updateUserProfile(
      {required UserProfilePostModel userProfilePostModel}) async {
    try {
      await dio.put(ApiService.baseUrl + '/users',
          options: await apiHeader.userOptions(),
          data: userProfilePostModel.toJson());
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateUserProfilePicture({required String path}) async {
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(path),
    });
    try {
      await dio.post(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.fileOptions(),
        data: formData,
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<Uint8List?> getUserProfilePicture() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.fileOptions(withType: true),
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
    try {
      await dio.put(ApiService.baseUrl + '/students',
          options: await apiHeader.userOptions(),
          data: studentDataPostModel.toJson());
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<Uint8List> getProfilePic({required String userId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users/${userId}/pic',
        options: await apiHeader.fileOptions(withType: true),
      );
      final List<int> bytes = response.data;
      return Uint8List.fromList(bytes);
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
