import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:path/path.dart';

abstract class UserDataSource {
  Future<UserCredential> getUserCredential();
  Future<String> uploadProfilePicture(String path);
  Future<void> updateFullName({required String fullname});
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  UserDataSourceImpl({required this.dio, required this.preferenceHandler});
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
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
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

  @override
  Future<String> uploadProfilePicture(String path) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(
        ApiService.baseUrl + '/users/pic',
        options: Options(
          headers: {
            "content-type": 'multipart/form-data',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: FormData.fromMap(
          {
            'pic': await MultipartFile.fromFile(
              path,
              filename: basename(path),
            ),
          },
        ),
      );
      print(response);
      if (response.statusCode == 201) {
        return await response.data['data'];
      }
      // throw Exception();
      return await response.data['data'];
    } catch (e) {
      print("ini" + e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> updateFullName({required String fullname}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/users',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: {
          'fullname': fullname,
        },
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
