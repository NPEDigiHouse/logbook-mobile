import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/helpers/handle_error_response.dart'
    as he;
import 'package:elogbook/src/data/models/user/user_credential.dart';

abstract class AuthDataSource {
  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email});

  Future<void> login({
    required String username,
    required String password,
  });

  Future<bool> isSignIn();
  Future<void> logout();
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  AuthDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email}) async {
    try {
      final response = await dio.post(ApiService.baseUrl + '/students',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization":
                  'Basic ${base64Encode(utf8.encode('admin:admin'))}'
            },
          ),
          data: {
            "username": username,
            "password": password,
            "studentId": studentId,
            "email": email,
          });
      he.handleErrorResponse(
        response: response,
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> login(
      {required String username, required String password}) async {
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/users/login',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization":
                'Basic ${base64Encode(utf8.encode('$username:$password'))}'
          },
        ),
      );

      if (response.statusCode == 200) {
        final dataResponse = await DataResponse.fromJson(response.data);
        UserCredential credential =
            await UserCredential.fromJson(dataResponse.data);
        await preferenceHandler.setUserData(credential);
      }
      he.handleErrorResponse(
        response: response,
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  Future<void> refreshToken() async {
    try {
      UserCredential? credential = await preferenceHandler.getCredential();
      String? refreshToken = credential!.refreshToken;
      if (refreshToken == null) {
        // Handle jika refresh token tidak tersedia
        return;
      }

      final response = await dio.post(
        ApiService.baseUrl + '/refresh-token',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Basic ${base64Encode(utf8.encode('admin:admin'))}'
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final newAccessToken = responseData['accessToken'];

        await preferenceHandler.setUserData(UserCredential(
            accessToken: newAccessToken, refreshToken: refreshToken));
      } else {
        he.handleErrorResponse(response: response);
      }
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<bool> isSignIn() async {
    try {
      UserCredential? credential = await preferenceHandler.getCredential();
      return credential != null;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await preferenceHandler.removeCredential();
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
