import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';

abstract class UserDataSource {
  Future<UserCredential> getUserCredential();
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
}
