import 'package:data/models/assessment/final_score_response.dart';
import 'package:data/models/assessment/list_scientific_assignment.dart';
import 'package:data/models/assessment/mini_cex_detail_model.dart';
import 'package:data/models/assessment/mini_cex_post_model.dart';
import 'package:data/models/assessment/personal_behavior_detail.dart';
import 'package:data/models/assessment/scientific_grade_item.dart';
import 'package:data/models/assessment/student_mini_cex.dart';
import 'package:data/models/assessment/student_scientific_assignment.dart';
import 'package:data/models/assessment/weekly_assesment_response.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';

abstract class AssesmentDataSource {
  Future<void> addMiniCex({required MiniCexPostModel model});
  Future<void> addScientificAssignment({required MiniCexPostModel model});
  Future<MiniCexStudentDetailModel> getMiniCexDetail({required String id});
  Future<PersonalBehaviorDetailModel> getPersonalBehaviorDetail(
      {required String id});
  Future<List<StudentScientificAssignment>> getStudentScientificAssignment(
      {required String studentId});
  Future<List<StudentScientificAssignment>> getStudentPersonalBehavior(
      {required String studentId});
  Future<ListScientificAssignment> getScientificAssignmentDetail(
      {required String id});
  Future<StudentMiniCex> getStudetnMiniCex({required String studentId});
  Future<void> addScoreMiniCex(
      {required Map<String, dynamic> listItemRating,
      required String minicexId});
  Future<void> verifyPersonalBehavior(
      {required int id, required bool status, required String pbId});
  Future<void> addScoreScientificAssignment(
      {required Map<String, dynamic> score, required String id});
  Future<FinalScoreResponse> getFinalScore(
      {required String unitId, required String studentId});
  Future<WeeklyAssesmentResponse> getWeeklyAssesment(
      {required String unitId, required String studentId});
  Future<void> scoreCbtOsce(
      {required String studentId,
      required String type,
      required String unitId,
      required double score});
  Future<void> scoreWeeklyAssesment({required String id, required int score});
  Future<void> submitFinalScore(
      {required String studentId,
      required String unitId,
      required bool status});
  Future<List<ScientificGradeItem>> getListScientificGradeItems();
}

class AssesmentDataSourceImpl implements AssesmentDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  AssesmentDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }
  @override
  Future<void> addMiniCex({required MiniCexPostModel model}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/assesments/mini-cexs/',
        options: await apiHeader.userOptions(),
        data: model.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<MiniCexStudentDetailModel> getMiniCexDetail(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/mini-cexs/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = MiniCexStudentDetailModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentMiniCex> getStudetnMiniCex({required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/mini-cexs/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentMiniCex.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> addScoreMiniCex(
      {required Map<String, dynamic> listItemRating,
      required String minicexId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/assesments/mini-cexs/$minicexId/score/v2',
        options: await apiHeader.userOptions(),
        data: listItemRating,
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> addScoreScientificAssignment(
      {required Map<String, dynamic> score, required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/assesments/scientific-assesments/$id/score',
        options: await apiHeader.userOptions(),
        data: score,
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<ListScientificAssignment> getScientificAssignmentDetail(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/scientific-assesments/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ListScientificAssignment.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentScientificAssignment>> getStudentScientificAssignment(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/scientific-assesments/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentScientificAssignment> listData = dataResponse.data
          .map((e) => StudentScientificAssignment.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> addScientificAssignment(
      {required MiniCexPostModel model}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/assesments/scientific-assesments',
        options: await apiHeader.userOptions(),
        data: model.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<PersonalBehaviorDetailModel> getPersonalBehaviorDetail(
      {required String id}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/personal-behaviours/$id',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = PersonalBehaviorDetailModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentScientificAssignment>> getStudentPersonalBehavior(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/personal-behaviours/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentScientificAssignment> listData = dataResponse.data
          .map((e) => StudentScientificAssignment.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyPersonalBehavior(
      {required int id, required bool status, required String pbId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/assesments/personal-behaviours/$pbId/items',
        options: await apiHeader.userOptions(),
        data: {"id": id, "verified": status},
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<FinalScoreResponse> getFinalScore(
      {required String unitId, required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/assesments/students/$studentId/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = FinalScoreResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> scoreCbtOsce(
      {required String studentId,
      required String type,
      required String unitId,
      required double score}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/assesments/students/$studentId/units/$unitId',
        options: await apiHeader.userOptions(),
        data: {
          'score': score,
          'type': type,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<WeeklyAssesmentResponse> getWeeklyAssesment(
      {required String unitId, required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/weekly-assesments/students/$studentId/units/$unitId/v2',
        options: await apiHeader.userOptions(),
      );
      print(response);
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = WeeklyAssesmentResponse.fromJson(dataResponse.data);

      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> scoreWeeklyAssesment(
      {required String id, required int score}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/weekly-assesments/$id',
        options: await apiHeader.userOptions(),
        data: {
          'score': score,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> submitFinalScore(
      {required String studentId,
      required String unitId,
      required bool status}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/assesments/students/$studentId/units/$unitId/submit',
        options: await apiHeader.userOptions(),
        data: {
          'verified': status,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<ScientificGradeItem>> getListScientificGradeItems() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/scientific-assesment-grade-items',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ScientificGradeItem> listData = dataResponse.data
          .map((e) => ScientificGradeItem.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }
}
