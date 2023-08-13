import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_post_model.dart';

abstract class ClinicalRecordsDatasource {
  Future<void> uploadClinicalRecord({
    required ClinicalRecordPostModel clinicalRecordPostModel,
  });
  Future<void> uploadClinicalRecordAttachment({required String filePath});
}

class ClinicalRecordsDatasourceImpl implements ClinicalRecordsDatasource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ClinicalRecordsDatasourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadClinicalRecord(
      {required ClinicalRecordPostModel clinicalRecordPostModel}) async {
    try {
      final response = await dio.post(ApiService.baseUrl + '/clinical-records',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization":
                  'Bearer ${base64Encode(utf8.encode('admin:admin'))}'
            },
          ),
          data: clinicalRecordPostModel.toJson());
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadClinicalRecordAttachment(
      {required String filePath}) async {
    final credential = await preferenceHandler.getCredential();
    FormData formData = FormData.fromMap({
      'attachments': await MultipartFile.fromFile(filePath),
    });
    try {
      final response =
          await dio.post(ApiService.baseUrl + '/clinical-records/attachments',
              options: Options(
                headers: {
                  "content-type": 'multipart/form-data',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: formData);
      if (response != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
