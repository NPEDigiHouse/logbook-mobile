import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_detail.dart';

abstract class SpecialReportDataSource {
  Future<SpecialReportDetail> getSpecialReportDetail({required String id});
  Future<void> postSpecialReport({required String content});
}

class SpecialReportDataSourceImpl implements SpecialReportDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  SpecialReportDataSourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<SpecialReportDetail> getSpecialReportDetail(
      {required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/problem-consultations/$id',
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
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = SpecialReportDetail.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> postSpecialReport({required String content}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/problem-consultations/',
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
          'content': content,
        },
      );
      print(response.statusCode);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
