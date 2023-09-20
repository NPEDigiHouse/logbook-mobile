import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
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
  final AuthPreferenceHandler preferenceHandler;

  SglCstDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<void> uploadSgl({required SglCstPostModel postModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(ApiService.baseUrl + '/sgls/',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
            // followRedirects: false,
            // validateStatus: (status) {
            //   return status! < 500;
            // },
          ),
          data: postModel.toJson());
      // print(response);
      // if (response.statusCode != 201) {
      //   throw Exception();
      // }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> uploadCst({required SglCstPostModel postModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response = await dio.post(ApiService.baseUrl + '/csts/',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
            // followRedirects: false,
            // validateStatus: (status) {
            //   return status! < 500;
            // },
          ),
          data: {
            'supervisorId': postModel.supervisorId,
            'startTime': postModel.startTime,
            'endTime': postModel.endTime,
            'topicId': postModel.topicId,
          });
      // print(response);
      // if (response.statusCode != 201) {
      //   throw Exception();
      // }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<TopicModel>> getTopics() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);

      print("TERP");
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<CstResponse> getCstByStudentId({required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/csts/students/$studentId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = CstResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SglCstOnList>> getCstBySupervisor() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/csts',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<SglResponse> getSglByStudentId({required String studentId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/sgls/students/$studentId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = SglResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<SglCstOnList>> getSglBySupervisor() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/sgls',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      print(response);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<SglCstOnList> listData =
          dataResponse.data.map((e) => SglCstOnList.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCstByCeu(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(ApiService.baseUrl + '/csts/$id',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: {'verified': true});
      print(response.statusCode);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCstBySupervisor(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(ApiService.baseUrl + '/csts/topics/$id',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
            // followRedirects: false,
            // validateStatus: (status) {
            //   return status! < 500;
            // },
          ),
          data: {'verified': status});
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySglByCeu(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(ApiService.baseUrl + '/sgls/$id',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: {'verified': true});
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySglBySupervisor(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(ApiService.baseUrl + '/sgls/topics/$id',
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          data: {'verified': status});
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addNewCstTopic(
      {required TopicPostModel topic, required String cstId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/csts/$cstId/topics',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: topic.toJson(),
      );
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addNewSglTopic(
      {required TopicPostModel topic, required String sglId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.put(
        ApiService.baseUrl + '/sgls/$sglId/topics',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
        data: topic.toJson(),
      );
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<TopicModel>> getTopicsByDepartmentId(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/topics/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<TopicModel> listData =
          dataResponse.data.map((e) => TopicModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllCstBySupervisor(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response =
          await dio.put(ApiService.baseUrl + '/csts/$id/topics/verify',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: {'verified': status});
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllSglBySupervisor(
      {required String id, required bool status}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response =
          await dio.put(ApiService.baseUrl + '/sgls/$id/topics/verify',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: {'verified': status});
      print(response);
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
