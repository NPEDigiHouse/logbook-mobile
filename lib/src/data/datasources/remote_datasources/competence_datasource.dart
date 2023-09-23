import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/competences/case_post_model.dart';
import 'package:elogbook/src/data/models/competences/list_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_skills_model.dart';
import 'package:elogbook/src/data/models/competences/skill_post_model.dart';
import 'package:elogbook/src/data/models/competences/student_competence_model.dart';

abstract class CompetenceDataSource {
  Future<List<StudentCaseModel>> getStudentCases({required String unitId});
  Future<List<StudentCompetenceModel>> getCaseListStudent();
  Future<ListCasesModel> getListCaseOfStudent({required String studentId});
  Future<void> verifyCaseById({required String id, required int rating});
  Future<void> verifyAllCases({required String studentId});
  Future<List<StudentCompetenceModel>> getSkillListStudent();
  Future<ListSkillsModel> getListSkillOfStudent({required String studentId});
  Future<void> verifySkillById({required String id, required int rating});
  Future<void> verifyAllSkills({required String studentId});
  Future<List<StudentSkillModel>> getStudentSkills({required String unitId});
  Future<void> addSkill({required SkillPostModel skillPostModel});
  Future<void> addCase({required CasePostModel casePostModel});
  Future<ListCasesModel> getListCase();
  Future<ListSkillsModel> getListSkill();
}

class CompetenceDataSourceImpl implements CompetenceDataSource {
  final Dio dio;
  final ApiHeader apiHeader;

  CompetenceDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<void> addCase({required CasePostModel casePostModel}) async {
    try {
      await dio.post(
        ApiService.baseUrl + '/competencies/cases',
        options: await apiHeader.userOptions(),
        data: casePostModel.toJson(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addSkill({required SkillPostModel skillPostModel}) async {
    try {
      await dio.post(
        ApiService.baseUrl + '/competencies/skills',
        options: await apiHeader.userOptions(),
        data: skillPostModel.toJson(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListCasesModel> getListCase() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/cases',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = ListCasesModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListSkillsModel> getListSkill() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/skills',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = ListSkillsModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentCaseModel>> getStudentCases(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/case-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCaseModel> listData =
          dataResponse.data.map((e) => StudentCaseModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentSkillModel>> getStudentSkills(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/skill-types/units/$unitId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentSkillModel> listData =
          dataResponse.data.map((e) => StudentSkillModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentCompetenceModel>> getCaseListStudent() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/cases',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCompetenceModel> listData = dataResponse.data
          .map((e) => StudentCompetenceModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListCasesModel> getListCaseOfStudent(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/cases/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = ListCasesModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListSkillsModel> getListSkillOfStudent(
      {required String studentId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/skills/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      final result = ListSkillsModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentCompetenceModel>> getSkillListStudent() async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/skills',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCompetenceModel> listData = dataResponse.data
          .map((e) => StudentCompetenceModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllCases({required String studentId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/competencies/cases/students/$studentId',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyAllSkills({required String studentId}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/competencies/skills/students/$studentId',
        options: await apiHeader.userOptions(),
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCaseById({required String id, required int rating}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/competencies/cases/$id',
        options: await apiHeader.userOptions(),
        data: {
          "verified": true,
          "rating": rating,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> verifySkillById(
      {required String id, required int rating}) async {
    try {
      await dio.put(
        ApiService.baseUrl + '/competencies/skills/$id',
        options: await apiHeader.userOptions(),
        data: {
          "verified": true,
          "rating": rating,
        },
      );
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
