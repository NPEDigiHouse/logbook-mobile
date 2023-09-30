import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/exception_handler.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/history/history_cst_model.dart';
import 'package:elogbook/src/data/models/history/history_sgl_model.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst.export.dart';

abstract class SglCstDataSource {
  Future<Either<Failure, bool>> editSgl(
      {required String id,
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
  Future<Either<Failure, List<SglCstOnList>>> getSglBySupervisor();
  Future<Either<Failure, List<SglCstOnList>>> getCstBySupervisor();

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

  SglCstDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<Either<Failure, void>> uploadSgl(
      {required SglCstPostModel postModel}) async {
    try {
      await dio.post(ApiService.baseUrl + '/sgls/',
          options: await apiHeader.userOptions(), data: postModel.toJson());
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> uploadCst(
      {required SglCstPostModel postModel}) async {
    try {
      await dio.post(ApiService.baseUrl + '/csts/',
          options: await apiHeader.userOptions(),
          data: {
            'supervisorId': postModel.supervisorId,
            'startTime': postModel.startTime,
            'endTime': postModel.endTime,
            'topicId': postModel.topicId,
          });
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<TopicModel>>> getTopics() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
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
        ApiService.baseUrl + '/csts/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = CstResponse.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<SglCstOnList>>> getCstBySupervisor() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/csts',
        options: await apiHeader.userOptions(),
      );

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
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
        ApiService.baseUrl + '/sgls/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = SglResponse.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<SglCstOnList>>> getSglBySupervisor() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/sgls',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
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
      await dio.put(ApiService.baseUrl + '/csts/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCstBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/csts/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifySglByCeu(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifySglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> addNewCstTopic(
      {required TopicPostModel topic, required String cstId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/csts/$cstId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> addNewSglTopic(
      {required TopicPostModel topic, required String sglId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/sgls/$sglId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, List<TopicModel>>> getTopicsByDepartmentId(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
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
      await dio.put(ApiService.baseUrl + '/csts/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyAllSglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSgl({required String id}) async {
    try {
      await dio.delete(ApiService.baseUrl + '/sgls/$id/',
          options: await apiHeader.userOptions());
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> editSgl(
      {required String id,
      int? startTime,
      int? endTime,
      List<Map<String, dynamic>>? topics}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/$id/edit',
          options: await apiHeader.userOptions(),
          data: {
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
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCst({required String id}) async {
    try {
      await dio.delete(ApiService.baseUrl + '/csts/$id/',
          options: await apiHeader.userOptions());
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> editCst(
      {required String id,
      int? startTime,
      int? endTime,
      List<Map<String, dynamic>>? topics}) async {
    try {
      await dio.put(ApiService.baseUrl + '/csts/$id/edit',
          options: await apiHeader.userOptions(),
          data: {
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
      return Right(true);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, HistoryCstModel>> getCst({required String id}) async {
    try {
      final response = await dio.get(ApiService.baseUrl + '/csts/$id/',
          options: await apiHeader.userOptions());
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = HistoryCstModel.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, HistorySglModel>> getSgl({required String id}) async {
    try {
      final response = await dio.get(ApiService.baseUrl + '/sgls/$id/',
          options: await apiHeader.userOptions());
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = HistorySglModel.fromJson(dataResponse.data);
      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }
}
