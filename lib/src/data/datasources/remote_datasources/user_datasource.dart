import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:path/path.dart';

abstract class UserDataSource {
  Future<UserCredential> getUserCredential();
  Future<String> uploadProfilePicture(String path);
  Future<void> removeProfilePicture();
  Future<void> updateFullName({required String fullname});
  Future<void> deleteUser();
  Future<void> changePassword({
    required String newPassword,
  });
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;
  final AuthPreferenceHandler pref;
  final ApiHeader apiHeader;

  UserDataSourceImpl(
      {required this.dio, required this.apiHeader, required this.pref});
  @override
  Future<UserCredential> getUserCredential() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<Map<String, dynamic>>.fromJson(response.data);
      UserCredential userCredential =
          UserCredential.fromJson(dataResponse.data);
      return userCredential;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<String> uploadProfilePicture(String path) async {
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
      return await response.data['data'];
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateFullName({required String fullname}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
        data: {
          'fullname': fullname,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await dio.delete(
        ApiService.baseUrl + '/users',
        options: await apiHeader.userOptions(),
      );

      await pref.removeCredential();
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> removeProfilePicture() async {
    try {
      await dio.delete(
        ApiService.baseUrl + '/users/pic',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> changePassword({required String newPassword}) async {
    try {
      await dio.put(ApiService.baseUrl + '/users',
          options: await apiHeader.userOptions(),
          data: {
            'password': newPassword,
          });
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
