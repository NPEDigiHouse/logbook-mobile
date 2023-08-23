import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/competences/case_post_model.dart';
import 'package:elogbook/src/data/models/competences/list_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_skills_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_cases_model.dart';
import 'package:elogbook/src/data/models/competences/list_student_skills_model.dart';
import 'package:elogbook/src/data/models/competences/skill_post_model.dart';

abstract class CompetenceDataSource {
  Future<List<StudentCaseModel>> getStudentCases({required String unitId});
  Future<List<StudentSkillModel>> getStudentSkills({required String unitId});
  Future<void> addSkill({required SkillPostModel skillPostModel});
  Future<void> addCase({required CasePostModel casePostModel});
  Future<ListCasesModel> getListCase();
  Future<ListSkillsModel> getListSkill();
}

class CompetenceDataSourceImpl implements CompetenceDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  CompetenceDataSourceImpl(
      {required this.dio, required this.preferenceHandler});

  @override
  Future<void> addCase({required CasePostModel casePostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response =
          await dio.post(ApiService.baseUrl + '/competencies/cases',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: casePostModel.toJson());
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<void> addSkill({required SkillPostModel skillPostModel}) async {
    final credential = await preferenceHandler.getCredential();

    try {
      final response =
          await dio.post(ApiService.baseUrl + '/competencies/skills',
              options: Options(
                headers: {
                  "content-type": 'application/json',
                  "authorization": 'Bearer ${credential?.accessToken}'
                },
              ),
              data: skillPostModel.toJson());
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListCasesModel> getListCase() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/cases',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);
      print(dataResponse);
      final result = ListCasesModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListSkillsModel> getListSkill() async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/students/skills',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      final dataResponse = await DataResponse<dynamic>.fromJson(response.data);

      final result = ListSkillsModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentCaseModel>> getStudentCases(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/case-types/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
      print("TERP");
      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCaseModel> listData =
          dataResponse.data.map((e) => StudentCaseModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<List<StudentSkillModel>> getStudentSkills(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/skill-types/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );
      // print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception();
      }
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
}
