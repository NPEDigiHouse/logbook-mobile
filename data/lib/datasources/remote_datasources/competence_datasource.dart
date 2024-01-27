import 'package:data/models/competences/case_post_model.dart';
import 'package:data/models/competences/list_cases_model.dart';
import 'package:data/models/competences/list_skills_model.dart';
import 'package:data/models/competences/list_student_cases_model.dart';
import 'package:data/models/competences/list_student_skills_model.dart';
import 'package:data/models/competences/skill_post_model.dart';
import 'package:data/models/competences/student_competence_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:data/utils/filter_type.dart';
import 'package:dio/dio.dart';

abstract class CompetenceDataSource {
  Future<List<StudentCaseModel>> getStudentCases({required String unitId});
  Future<List<StudentCompetenceModel>> getCaseListStudent(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType});
  Future<ListCasesModel> getListCaseOfStudent({required String studentId});
  Future<void> verifyCaseById({required String id, required int rating});
  Future<void> verifyAllCases({required String studentId});
  Future<List<StudentCompetenceModel>> getSkillListStudent(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType});
  Future<ListSkillsModel> getListSkillOfStudent({required String studentId});
  Future<void> verifySkillById({required String id, required int rating});
  Future<void> verifyAllSkills({required String studentId});
  Future<List<StudentSkillModel>> getStudentSkills({required String unitId});
  Future<void> addSkill({required SkillPostModel skillPostModel});
  Future<void> addCase({required CasePostModel casePostModel});
  Future<void> updateSkill(
      {required SkillPostModel skillPostModel, required String id});
  Future<void> updateCase(
      {required CasePostModel casePostModel, required String id});
  Future<ListCasesModel> getListCase();
  Future<ListSkillsModel> getListSkill();
  Future<bool> deleteCase(String id);
  Future<bool> deleteSkill(String id);
}

class CompetenceDataSourceImpl implements CompetenceDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  CompetenceDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<void> addCase({required CasePostModel casePostModel}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/competencies/cases',
        options: await apiHeader.userOptions(),
        data: casePostModel.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> addSkill({required SkillPostModel skillPostModel}) async {
    try {
      await dio.post(
        '${ApiService.baseUrl}/competencies/skills',
        options: await apiHeader.userOptions(),
        data: skillPostModel.toJson(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<ListCasesModel> getListCase() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/cases',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ListCasesModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<ListSkillsModel> getListSkill() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/skills',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ListSkillsModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentCaseModel>> getStudentCases(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/case-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCaseModel> listData =
          dataResponse.data.map((e) => StudentCaseModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentSkillModel>> getStudentSkills(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/skill-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentSkillModel> listData =
          dataResponse.data.map((e) => StudentSkillModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentCompetenceModel>> getCaseListStudent(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType}) async {
    try {
      final response = await dio.get(
          '${ApiService.baseUrl}/competencies/cases/v2',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (unitId != null) "unit": unitId,
            if (page != null) "page": page,
            if (query != null) "query": query,
            if (filterType != FilterType.all)
              'type': filterType.name.toUpperCase(),
          });

      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCompetenceModel> listData = dataResponse.data
          .map((e) => StudentCompetenceModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentCompetenceModel>> getSkillListStudent(
      {String? unitId,
      int? page,
      String? query,
      required FilterType filterType}) async {
    try {
      final response = await dio.get(
          '${ApiService.baseUrl}/competencies/skills/v2',
          options: await apiHeader.userOptions(),
          queryParameters: {
            if (unitId != null) "unit": unitId,
            if (page != null) "page": page,
            if (query != null) "query": query,
            if (filterType != FilterType.all)
              'type': filterType.name.toUpperCase(),
          });

      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCompetenceModel> listData = dataResponse.data
          .map((e) => StudentCompetenceModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<ListCasesModel> getListCaseOfStudent(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/competencies/cases/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ListCasesModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<ListSkillsModel> getListSkillOfStudent(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/competencies/skills/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = ListSkillsModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyAllCases({required String studentId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/competencies/cases/students/$studentId',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyAllSkills({required String studentId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/competencies/skills/students/$studentId',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyCaseById({required String id, required int rating}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/competencies/cases/$id',
        options: await apiHeader.userOptions(),
        data: {
          "verified": true,
          "rating": rating,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifySkillById(
      {required String id, required int rating}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/competencies/skills/$id',
        options: await apiHeader.userOptions(),
        data: {
          "verified": true,
          "rating": rating,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteCase(String id) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/competencies/cases/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<bool> deleteSkill(String id) async {
    try {
      await dio.delete(
        '${ApiService.baseUrl}/competencies/skills/$id',
        options: await apiHeader.userOptions(),
      );
      return true;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateCase(
      {required CasePostModel casePostModel, required String id}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/competencies/cases/$id/v2',
        options: await apiHeader.userOptions(),
        data: {
          if (casePostModel.type != null) "type": casePostModel.type,
          if (casePostModel.caseTypeId != null)
            "caseTypeId": casePostModel.caseTypeId,
        },
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateSkill(
      {required SkillPostModel skillPostModel, required String id}) async {
    try {
      print(skillPostModel.skillTypeId);
      await dio.put(
        '${ApiService.baseUrl}/competencies/skills/$id/v2',
        options: await apiHeader.userOptions(),
        data: {
          if (skillPostModel.type != null) "type": skillPostModel.type,
          if (skillPostModel.skillTypeId != null)
            "skillTypeId": skillPostModel.skillTypeId,
        },
      );
    } catch (e) {
      print((e as DioException).response);
      throw failure(e);
    }
  }
}
