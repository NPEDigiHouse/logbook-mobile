import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/helpers/handle_error_response.dart'
    as he;
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/data/models/user/user_token.dart';

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
  Future<void> refreshToken();
  Future<UserCredential> getUserCredential();

  Future<bool> isSignIn();
  Future<void> logout();
  Future<String> generateTokenResetPassword({required String email});
  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  });
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
        UserToken credential = await UserToken.fromJson(dataResponse.data);
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
      UserToken? credential = await preferenceHandler.getCredential();
      String? refreshToken = credential!.refreshToken;
      if (refreshToken == null) {
        // Handle jika refresh token tidak tersedia
        return;
      }

      final response =
          await dio.post(ApiService.baseUrl + '/users/refresh-token',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization":
                      'Basic ${base64Encode(utf8.encode('admin:admin'))}'
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                },
              ),
              data: {
            'refreshToken': refreshToken,
          });

      if (response.statusCode == 200) {
        final responseData =
            await DataResponse<Map<String, dynamic>>.fromJson(response.data);
        final newAccessToken = responseData.data['accessToken'];
        await preferenceHandler.setUserData(
            UserToken(accessToken: newAccessToken, refreshToken: refreshToken));
      } else {
        print(response.statusCode);
        // he.handleErrorResponse(response: response);
      }
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<bool> isSignIn() async {
    try {
      UserToken? credential = await preferenceHandler.getCredential();
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

  @override
  Future<String> generateTokenResetPassword({required String email}) async {
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/students/reset-password',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Basic ${base64Encode(utf8.encode('admin:admin'))}'
          },
        ),
        data: {
          'email': email,
        },
      );
      // print(response.data);
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            await DataResponse<Map<String, dynamic>>.fromJson(response.data)
                .data;
        return responseData['token'];
      }
      he.handleErrorResponse(response: response);
      throw ClientFailure(response.statusMessage ?? '');
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String otp,
    required String newPassword,
    required String token,
  }) async {
    try {
      // print(otp);
      // print(newPassword);
      // print(token);
      // print('Basic ${base64Encode(utf8.encode('admin:admin'))}');
      final response = await dio.post(
        ApiService.baseUrl + '/students/reset-password/$token',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Basic ${base64Encode(utf8.encode('admin:admin'))}'
          },
        ),
        data: {
          'otp': otp,
          'newPassword': newPassword,
        },
      );
      he.handleErrorResponse(response: response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<UserCredential> getUserCredential() async {
    try {
      final credential = await preferenceHandler.getCredential();
      // print(credential?.accessToken);
      print(credential?.accessToken);
      final response = await dio.get(
        ApiService.baseUrl + '/users',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          // followRedirects: false,
          // validateStatus: (status) {
          //   return status! < 500;
          // },
        ),
      );
      print(response.data);

      final dataResponse =
          await DataResponse<Map<String, dynamic>>.fromJson(response.data);
      UserCredential userCredential =
          UserCredential.fromJson(dataResponse.data);

      print(userCredential);
      return userCredential;
    } catch (e) {
      print("ERROR");
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
