import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/src/data/datasources/datasources.export.dart';
import 'package:elogbook/src/data/models/user/user_token.dart';

class TokenManager {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;
  final ApiHeader apiHeader;
  TokenManager(
      {required this.dio,
      required this.apiHeader,
      required this.preferenceHandler});

  String? getAccessToken() {
    final credential = CredentialSaver.credential;
    final accessToken = credential?.accessToken;
    return accessToken;
  }

  Future<String?> refreshAccessToken() async {
    try {
      final credential = CredentialSaver.credential;
      String? refreshToken = credential?.refreshToken;
      if (refreshToken == null) {
        return null;
      }
      final response = await dio.post(
          ApiService.baseUrl + '/users/refresh-token',
          options: apiHeader.adminOptions(),
          data: {
            'refreshToken': refreshToken,
          });

      final responseData =
          await DataResponse<Map<String, dynamic>>.fromJson(response.data);
      final newAccessToken = responseData.data['accessToken'];
      await preferenceHandler.setUserData(
          UserToken(accessToken: newAccessToken, refreshToken: refreshToken));
      CredentialSaver.credential = await preferenceHandler.getCredential();
      return newAccessToken;
    } catch (e) {
      return null;
    }
  }
}

class TokenInterceptor extends Interceptor {
  final TokenManager tokenManager;

  TokenInterceptor({required this.tokenManager});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final excludedUrls = [
      "${ApiService.baseUrl}/users/login",
      "${ApiService.baseUrl}/units",
    ];
    bool firstCondition = !excludedUrls.contains(options.uri.toString());
    bool secondCondition =
        !("${ApiService.baseUrl}/students" == options.uri.toString() &&
            options.method == "POST");
    bool thirdCondition = !(options.uri
        .toString()
        .contains("${ApiService.baseUrl}/students/reset-password"));

    if (firstCondition && secondCondition && thirdCondition) {
      final accessToken = tokenManager.getAccessToken();
      if (accessToken != null) {
        options.headers['authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final excludedUrls = [
      "${ApiService.baseUrl}/users/login",
      "${ApiService.baseUrl}/students",
      "${ApiService.baseUrl}/students/reset-password",
      "${ApiService.baseUrl}/units",
    ];
    if (err.response?.statusCode == 401 &&
        !excludedUrls.contains(err.requestOptions.uri.toString())) {
      final newAccessToken = await tokenManager.refreshAccessToken();
      if (newAccessToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
