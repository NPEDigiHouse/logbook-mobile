import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:flutter/material.dart';

abstract class AuthDataSource {
  Future<void> register(
      {required String username,
      required String studentId,
      required String password,
      String? fullname,
      required String email});
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;

  AuthDataSourceImpl({required this.dio});

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
      print(response.statusCode);
      switch (response.statusCode) {
        case 400:
          throw BadRequestFailure(response.data);
        case 401:
          throw UnauthorizedFailure(response.data);
        case 500:
          throw ServerErrorFailure(response.data);
        default:
      }
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }
}
