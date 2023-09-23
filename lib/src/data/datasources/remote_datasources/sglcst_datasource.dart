import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/sglcst/cst_model.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_cst_on_list_model.dart';
import 'package:elogbook/src/data/models/sglcst/sgl_model.dart';
import 'package:elogbook/src/data/models/sglcst/sglcst_post_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_post_model.dart';

abstract class SglCstDataSource {
  Future<void> uploadSgl({
    required SglCstPostModel postModel,
  });
  Future<void> uploadCst({
    required SglCstPostModel postModel,
  });
  Future<void> addNewSglTopic(
      {required TopicPostModel topic, required String sglId});
  Future<void> addNewCstTopic(
      {required TopicPostModel topic, required String cstId});
  Future<List<TopicModel>> getTopics();
  Future<List<TopicModel>> getTopicsByDepartmentId({required String unitId});
  Future<List<SglCstOnList>> getSglBySupervisor();
  Future<List<SglCstOnList>> getCstBySupervisor();
  Future<SglResponse> getSglByStudentId({required String studentId});
  Future<CstResponse> getCstByStudentId({required String studentId});
  Future<void> verifySglBySupervisor(
      {required String id, required bool status});
  Future<void> verifyCstBySupervisor(
      {required String id, required bool status});
  Future<void> verifyAllSglBySupervisor(
      {required String id, required bool status});
  Future<void> verifyAllCstBySupervisor(
      {required String id, required bool status});
  Future<void> verifyCstByCeu({required String id, required bool status});
  Future<void> verifySglByCeu({required String id, required bool status});
}

class SglCstDataSourceImpl implements SglCstDataSource {
  final Dio dio;
  final ApiHeader apiHeader;

  SglCstDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<void> uploadSgl({required SglCstPostModel postModel}) async {
    try {
      await dio.post(ApiService.baseUrl + '/sgls/',
          options: await apiHeader.userOptions(), data: postModel.toJson());
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadCst({required SglCstPostModel postModel}) async {
    try {
      await dio.post(ApiService.baseUrl + '/csts/',
          options: await apiHeader.userOptions(),
          data: {
            'supervisorId': postModel.supervisorId,
            'startTime': postModel.startTime,
            'endTime': postModel.endTime,
            'topicId': postModel.topicId,
          });
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<TopicModel>> getTopics() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<CstResponse> getCstByStudentId({required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/csts/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = CstResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SglCstOnList>> getCstBySupervisor() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/csts',
        options: await apiHeader.userOptions(),
      );

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<SglResponse> getSglByStudentId({required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/sgls/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = SglResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SglCstOnList>> getSglBySupervisor() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/sgls',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCstByCeu(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/csts/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCstBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/csts/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySglByCeu(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/$id',
          options: await apiHeader.userOptions(), data: {'verified': true});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/topics/$id',
          options: await apiHeader.userOptions(), data: {'verified': status});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addNewCstTopic(
      {required TopicPostModel topic, required String cstId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/csts/$cstId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addNewSglTopic(
      {required TopicPostModel topic, required String sglId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/sgls/$sglId/topics',
        options: await apiHeader.userOptions(),
        data: topic.toJson(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<TopicModel>> getTopicsByDepartmentId(
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
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllCstBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/csts/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllSglBySupervisor(
      {required String id, required bool status}) async {
    try {
      await dio.put(ApiService.baseUrl + '/sgls/$id/topics/verify',
          options: await apiHeader.userOptions(), data: {'verified': status});
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
