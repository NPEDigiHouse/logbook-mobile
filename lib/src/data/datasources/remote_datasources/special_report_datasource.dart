import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
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
  final ApiHeader apiHeader;

  SpecialReportDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<SpecialReportDetail> getSpecialReportDetail(
      {required String id}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/problem-consultations/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = SpecialReportDetail.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> postSpecialReport({required String content}) async {
    try {
      await dio.post(
        ApiService.baseUrl + '/problem-consultations/',
        options: await apiHeader.userOptions(),
        data: {
          'content': content,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SpecialReportOnList>> getSpecialReportBySupervisor() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/problem-consultations/',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SpecialReportOnList> listData = dataResponse.data
          .map((e) => SpecialReportOnList.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySpecialReport(
      {required String solution, required String id}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/problem-consultations/$id',
        options: await apiHeader.userOptions(),
        data: {
          'rating': 5,
          'verified': solution,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<SpecialReportResponse> getSpecialReportByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/problem-consultations/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = SpecialReportResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
