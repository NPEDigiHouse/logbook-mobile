import 'package:dartz/dartz.dart';
import 'package:data/models/history/history_cst_model.dart';
import 'package:data/models/history/history_sgl_model.dart';
import 'package:data/models/sglcst/cst_model.dart';
import 'package:data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:data/models/sglcst/sgl_model.dart';
import 'package:data/models/sglcst/sglcst_post_model.dart';
import 'package:data/models/sglcst/topic_model.dart';
import 'package:data/models/sglcst/topic_post_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/failure.dart';
import 'package:data/utils/filter_type.dart';
import 'package:dio/dio.dart';

abstract class SglCstDataSource {
  Future<Either<Failure, bool>> editSgl(
      {required String id,
      String? date,
      int? startTime,
      int? endTime,
      List<Map<String, dynamic>>? topics});
  Future<Either<Failure, bool>> deleteSgl({
    required String id,
  });
  Future<Either<Failure, bool>> deleteCst({
    required String id,
  });
  Future<Either<Failure, HistorySglModel>> getSgl({
    required String id,
  });
  Future<Either<Failure, HistoryCstModel>> getCst({
    required String id,
  });
  Future<Either<Failure, bool>> editCst(
      {required String id,
      int? startTime,
      String? date,
      int? endTime,
      List<Map<String, dynamic>>? topics});
  Future<Either<Failure, void>> uploadSgl({
    required SglCstPostModel postModel,
  });
  Future<Either<Failure, void>> uploadCst({
    required SglCstPostModel postModel,
  });
  Future<Either<Failure, void>> addNewSglTopic(
      {required TopicPostModel topic, required String sglId});
  Future<Either<Failure, void>> addNewCstTopic(
      {required TopicPostModel topic, required String cstId});

  Future<Either<Failure, List<TopicModel>>> getTopics();
  Future<Either<Failure, List<TopicModel>>> getTopicsByDepartmentId(
      {required String unitId});
  Future<Either<Failure, List<SglCstOnList>>> getSglBySupervisor(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType});
  Future<Either<Failure, List<SglCstOnList>>> getCstBySupervisor(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType});

  Future<Either<Failure, SglResponse>> getSglByStudentId(
      {required String studentId});
  Future<Either<Failure, CstResponse>> getCstByStudentId(
      {required String studentId});
  Future<Either<Failure, void>> verifySglBySupervisor(
      {required String id, required bool status});
  Future<Either<Failure, void>> verifyCstBySupervisor(
      {required String id, required bool status});
  Future<Either<Failure, void>> verifyAllSglBySupervisor(
      {required String id, required bool status});
  Future<Either<Failure, void>> verifyAllCstBySupervisor(
      {required String id, required bool status});
  Future<Either<Failure, void>> verifyCstByCeu(
      {required String id, required bool status});
  Future<Either<Failure, void>> verifySglByCeu(
      {required String id, required bool status});
}

class SglCstDataSourceImpl implements SglCstDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  SglCstDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<Either<Failure, void>> uploadSgl(
      {required SglCstPostModel postModel}) async {
    try {
      await dio.post('${ApiService.baseUrl}/sgls/',
          options: await apiHeader.userOptions(), data: postModel.toJson());
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> uploadCst(
      {required SglCstPostModel postModel}) async {
    try {
      await dio.post('${ApiService.baseUrl}/csts/',
          options: await apiHeader.userOptions(),
          data: {
            'supervisorId': postModel.supervisorId,
            'startTime': postModel.startTime,
            'endTime': postModel.endTime,
            'topicId': postModel.topicId,
          });
      return const Right(true);
    } catch (e) {
      print(e.toString());
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<TopicModel>>> getTopics() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/topics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, CstResponse>> getCstByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/csts/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      print(response.data);
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = CstResponse.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<SglCstOnList>>> getCstBySupervisor(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/csts/v2',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (unitId != null) "unit": unitId,
            if (page != null) "page": page,
            if (query != null) "query": query,
            if (filterType != FilterType.all)
              'type': filterType.name.toUpperCase(),
          });
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, SglResponse>> getSglByStudentId(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/sgls/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SglResponse.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<SglCstOnList>>> getSglBySupervisor(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/sgls/v2',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (unitId != null) "unit": unitId,
            if (page != null) "page": page,
            if (query != null) "query": query,
            if (filterType != FilterType.all)
              'type': filterType.name.toUpperCase(),
          });
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCstByCeu(
      {required String id, required bool status}) async {
    try {
      await dio.put('${ApiService.baseUrl}/csts/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCstBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put('${ApiService.baseUrl}/csts/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifySglByCeu(
      {required String id, required bool status}) async {
    try {
      print(id);
      print(status);
      await dio.put('${ApiService.baseUrl}/sgls/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
      return const Right(true);
    } catch (e) {
      print(e.toString());
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifySglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put('${ApiService.baseUrl}/sgls/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> addNewCstTopic(
      {required TopicPostModel topic, required String cstId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/csts/$cstId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> addNewSglTopic(
      {required TopicPostModel topic, required String sglId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/sgls/$sglId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<TopicModel>>> getTopicsByDepartmentId(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/topics/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return Right(listData);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyAllCstBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put('${ApiService.baseUrl}/csts/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyAllSglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put('${ApiService.baseUrl}/sgls/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSgl({required String id}) async {
    try {
      await dio.delete('${ApiService.baseUrl}/sgls/$id/',
          options: await apiHeader.userOptions());
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> editSgl(
      {required String id,
      int? startTime,
      int? endTime,
      String? date,
      List<Map<String, dynamic>>? topics}) async {
    try {
      await dio.put('${ApiService.baseUrl}/sgls/$id/edit',
          options: await apiHeader.userOptions(),
          data: {
            "date": date,
            if (startTime != null) "startTime": startTime,
            if (endTime != null) "endTime": endTime,
            if (topics != null && topics.isNotEmpty)
              "topics": [
                for (int i = 0; i < topics.length; i++)
                  {
                    'oldId': topics[i]['oldId'],
                    'newId': topics[i]['newId'],
                  }
              ],
          });
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCst({required String id}) async {
    try {
      await dio.delete('${ApiService.baseUrl}/csts/$id/',
          options: await apiHeader.userOptions());
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> editCst(
      {required String id,
      int? startTime,
      String? date,
      int? endTime,
      List<Map<String, dynamic>>? topics}) async {
    try {
      await dio.put('${ApiService.baseUrl}/csts/$id/edit',
          options: await apiHeader.userOptions(),
          data: {
            "date": date,
            if (startTime != null) "startTime": startTime,
            if (endTime != null) "endTime": endTime,
            if (topics != null && topics.isNotEmpty)
              "topics": [
                for (int i = 0; i < topics.length; i++)
                  {
                    'oldId': topics[i]['oldId'],
                    'newId': topics[i]['newId'],
                  }
              ],
          });
      return const Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, HistoryCstModel>> getCst({required String id}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/csts/$id/',
          options: await apiHeader.userOptions());
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = HistoryCstModel.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, HistorySglModel>> getSgl({required String id}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/sgls/$id/',
          options: await apiHeader.userOptions());
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = HistorySglModel.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }
}
