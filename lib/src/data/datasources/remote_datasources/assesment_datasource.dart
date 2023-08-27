import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/assessment/list_scientific_assignment.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_detail_model.dart';
import 'package:elogbook/src/data/models/assessment/mini_cex_post_model.dart';
import 'package:elogbook/src/data/models/assessment/student_mini_cex.dart';
import 'package:elogbook/src/data/models/assessment/student_scientific_assignment.dart';

abstract class AssesmentDataSource {
  Future<void> addMiniCex({required MiniCexPostModel model});
  Future<void> addScientificAssignment({required MiniCexPostModel model});
  Future<MiniCexStudentDetail> getMiniCexDetail({required String id});
  Future<List<StudentScientificAssignment>> getStudentScientificAssignment(
      {required String studentId});
  Future<ListScientificAssignment> getScientificAssignmentDetail(
      {required String id});
  Future<StudentMiniCex> getStudetnMiniCex({required String studentId});
  Future<void> addScoreMiniCex(
      {required Map<String, dynamic> listItemRating,
      required String minicexId});
  Future<void> addScoreScientificAssignment(
      {required Map<String, dynamic> score, required String id});
}

class AssesmentDataSourceImpl implements AssesmentDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  AssesmentDataSourceImpl({required this.dio, required this.preferenceHandler});
  @override
  Future<void> addMiniCex({required MiniCexPostModel model}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/assesments/mini-cexs/',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: model.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<MiniCexStudentDetail> getMiniCexDetail({required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/assesments/mini-cexs/$id',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = MiniCexStudentDetail.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<StudentMiniCex> getStudetnMiniCex({required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/assesments/mini-cexs/students/$studentId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = StudentMiniCex.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addScoreMiniCex(
      {required Map<String, dynamic> listItemRating,
      required String minicexId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/assesments/mini-cexs/$minicexId/score/v2',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: listItemRating,
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

  @override
  Future<void> addScoreScientificAssignment(
      {required Map<String, dynamic> score, required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/assesments/scientific-assesments/$id/score',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: score,
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

  @override
  Future<ListScientificAssignment> getScientificAssignmentDetail(
      {required String id}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/assesments/scientific-assesments/$id',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = ListScientificAssignment.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentScientificAssignment>> getStudentScientificAssignment(
      {required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl +
            '/assesments/scientific-assesments/students/$studentId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentScientificAssignment> listData = dataResponse.data
          .map((e) => StudentScientificAssignment.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addScientificAssignment(
      {required MiniCexPostModel model}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.post(
        ApiService.baseUrl + '/assesments/scientific-assesments',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: model.toJson(),
      );
      print(response);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
