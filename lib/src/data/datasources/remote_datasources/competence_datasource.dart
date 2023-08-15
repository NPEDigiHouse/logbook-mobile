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
  Future<ListStudentCasesModel> getStudentCases({required String nim});
  Future<ListStudentSkillsModel> getStudentSkills({required String nim});
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
      if (response != 201) {
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
      if (response != 201) {
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
      final dataResponse =
          await DataResponse<ListCasesModel>.fromJson(response.data);

      return dataResponse.data;
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
      final dataResponse =
          await DataResponse<ListSkillsModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListStudentCasesModel> getStudentCases({required String nim}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/cases/students/$nim',
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
          await DataResponse<ListStudentCasesModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<ListStudentSkillsModel> getStudentSkills({required String nim}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/competencies/cases/students/$nim',
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
          await DataResponse<ListStudentSkillsModel>.fromJson(response.data);

      return dataResponse.data;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
