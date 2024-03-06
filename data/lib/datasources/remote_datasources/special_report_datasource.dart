import 'package:data/models/special_reports/special_report_detail.dart';
import 'package:data/models/special_reports/special_report_on_list.dart';
import 'package:data/models/special_reports/special_report_response.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';

abstract class SpecialReportDataSource {
  Future<SpecialReportDetail> getSpecialReportDetail({required String id});
  Future<bool> deleteSpecialReport({required String id});
  Future<bool> updateSpecialReport(
      {required String id, required String content});
  Future<void> postSpecialReport({required String content});
  Future<List<SpecialReportOnList>> getSpecialReportBySupervisor(
      {required bool verified});
  Future<SpecialReportResponse> getSpecialReportByStudentId(
      {required String studentId});
  Future<void> verifySpecialReport(
      {required String solution, required String id});
}

class SpecialReportDataSourceImpl implements SpecialReportDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  SpecialReportDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<SpecialReportDetail> getSpecialReportDetail(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/problem-consultations/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SpecialReportDetail.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> postSpecialReport({required String content}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/problem-consultations/',
        options: await apiHeader.userOptions(),
        data: {
          'content': content,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<SpecialReportOnList>> getSpecialReportBySupervisor(
      {required bool verified}) async {
    try {
      final response = await dio.get(
          '${ApiService.baseUrl}/problem-consultations/',
          options: await apiHeader.userOptions(),
          data: {"verified": verified});
      print(response.data);
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SpecialReportOnList> listData = dataResponse.data
          .map((e) => SpecialReportOnList.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      print(e.toString());
      throw failure(e);
    }
  }

  @override
  Future<void> verifySpecialReport(
      {required String solution, required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/problem-consultations/$id',
        options: await apiHeader.userOptions(),
        data: {
          'rating': 5,
          'verified': solution,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<SpecialReportResponse> getSpecialReportByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/problem-consultations/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SpecialReportResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteSpecialReport({required String id}) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/problem-consultations/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> updateSpecialReport(
      {required String id, required String content}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/problem-consultations/$id/update',
        data: {
          'content': content,
        },
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }
}
