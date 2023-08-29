import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_detail.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_on_list.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_response.dart';

abstract class SpecialReportDataSource {
  Future<SpecialReportDetail> getSpecialReportDetail({required String id});
  Future<void> postSpecialReport({required String content});
  Future<List<SpecialReportOnList>> getSpecialReportBySupervisor();
  Future<SpecialReportResponse> getSpecialReportByStudentId(
      {required String studentId});
  Future<void> verifySpecialReport(
      {required String solution, required String id});
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

  @override
  Future<List<SpecialReportOnList>> getSpecialReportBySupervisor() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
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
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SpecialReportOnList> listData = dataResponse.data
          .map((e) => SpecialReportOnList.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySpecialReport(
      {required String solution, required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
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
        data: {
          'rating': 5,
          'verified': solution,
        },
      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<SpecialReportResponse> getSpecialReportByStudentId(
      {required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/problem-consultations/students/$studentId',
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

      final result = SpecialReportResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
