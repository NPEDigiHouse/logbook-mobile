import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';

class ApiHeader {
  final AuthPreferenceHandler preference;
  ApiHeader({required this.preference});

  Options adminOptions() => Options(
        headers: {
          "content-type": 'application/json',
          "authorization": 'Basic ${base64Encode(utf8.encode('admin:admin'))}'
        },
      );

  Options loginOptions(String username, String password) => Options(
        headers: {
          "content-type": 'application/json',
          "authorization":
              'Basic ${base64Encode(utf8.encode('$username:$password'))}'
        },
      );

  Future<dynamic> userOptions({bool onlyHeader = false}) async {
    final credential = await preference.getCredential();
    final headers = {
      "content-type": 'application/json',
      "authorization": 'Bearer ${credential?.accessToken}'
    };
    return onlyHeader ? headers : Options(headers: headers);
  }

  Future<dynamic> fileOptions({bool withType = false}) async {
    final credential = await preference.getCredential();
    final headers = {
      "content-type": 'multipart/form-data',
      "authorization": 'Bearer ${credential?.accessToken}'
    };

    return withType
        ? Options(
            headers: headers,
            responseType: ResponseType.bytes,
          )
        : Options(headers: headers);
  }
}
