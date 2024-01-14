import 'package:data/models/assessment/final_score_response.dart';
import 'package:data/models/assessment/mini_cex_list_model.dart';
import 'package:data/models/assessment/student_scientific_assignment.dart';
import 'package:data/models/assessment/weekly_assesment_response.dart';
import 'package:data/models/clinical_records/student_clinical_record_model.dart';
import 'package:data/models/scientific_session/student_scientific_session_model.dart';
import 'package:data/models/self_reflection/student_self_reflection_model.dart';
import 'package:data/models/sglcst/cst_model.dart';
import 'package:data/models/sglcst/sgl_model.dart';
import 'package:data/models/special_reports/special_report_response.dart';
import 'package:data/models/students/student_by_id_model.dart';
import 'package:data/models/students/student_check_in_model.dart';
import 'package:data/models/students/student_check_out_model.dart';
import 'package:data/models/students/student_post_model.dart';
import 'package:data/models/students/student_profile_post.dart';
import 'package:data/models/students/student_statistic.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';

abstract class StudentDataSource {
  Future<StudentClinicalRecordResponse>
      getStudentClinicalRecordOfActiveDepartment();
  Future<StudentScientificSessionResponse>
      getStudentScientificSessionOfActiveDepartment();
  Future<StudentSelfReflectionModel> getStudentSelfReflection();
  Future<List<MiniCexListModel>> getStudentMiniCex();
  Future<List<StudentScientificAssignment>> getStudentScientificAssignment();
  Future<List<StudentScientificAssignment>> getStudentPersonalBehavior();
  Future<SglResponse> getStudentSgl({required String status});
  Future<CstResponse> getStudentCst({required String status});
  Future<SpecialReportResponse> getStudentSpecialReports();
  Future<FinalScoreResponse> getStudentFinalScore();
  Future<WeeklyAssesmentResponse> getStudentWeeklyAssesment();
  Future<void> updateStudentProfile(StudentProfile model);
  Future<List<StudentCheckInModel>> getStudentCheckIn();
  Future<void> verifyCheckIn({required String studentId});
  Future<List<StudentCheckOutModel>> getStudentCheckOut();
  Future<void> verifyCheckOut({required String studentId});
  Future<StudentById> getStudentById({required String studentId});
  Future<StudentStatistic> getStudentStatistic();
  Future<void> updateStudentData(
      {required StudentPostModel studentDataPostModel});
}

class StudentDataSourceImpl implements StudentDataSource {
  final Dio dio;
  final ApiHeader apiHeader;
  final TokenInterceptor tokenInterceptor;

  StudentDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<StudentClinicalRecordResponse>
      getStudentClinicalRecordOfActiveDepartment() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/clinical-records',
        options: await apiHeader.userOptions(),
      );
      print(response.data);
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentClinicalRecordResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentScientificSessionResponse>
      getStudentScientificSessionOfActiveDepartment() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/scientific-sessions',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result =
          StudentScientificSessionResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentSelfReflectionModel> getStudentSelfReflection() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/self-reflections',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentSelfReflectionModel.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateStudentProfile(StudentProfile model) async {
    try {
      print(model.toJson());
      await dio.put(
        '${ApiService.baseUrl}/students',
        options: await apiHeader.userOptions(),
        data: {
          if (model.clinicId != null) 'clinicId': model.clinicId,
          if (model.preclinicId != null) 'preclinicId': model.preclinicId,
          if (model.phoneNumber != null) 'phoneNumber': model.phoneNumber,
          if (model.address != null) 'address': model.address,
          if (model.graduationDate != null)
            'graduationDate': model.graduationDate,
          if (model.academicSupervisor != null)
            'academicSupervisor': model.academicSupervisor,
          if (model.examinerDpk != null) 'examinerDPK': model.examinerDpk,
          if (model.supervisingDpk != null)
            'supervisingDPK': model.supervisingDpk,
          if (model.rsStation != null) 'rsStation': model.rsStation,
          if (model.pkmStation != null) 'pkmStation': model.pkmStation,
          if (model.periodLengthStation != null)
            'periodLengthStation': model.periodLengthStation,
        },
      );
    } catch (e) {
      if (e is DioException) {
        print(e.message);
      }
      throw failure(e);
    }
  }

  @override
  Future<List<MiniCexListModel>> getStudentMiniCex() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/mini-cexs',
        options: await apiHeader.userOptions(),
      );
      final dataResponse =
          DataResponse<List<dynamic>>.fromJson(response.data['data']);
      List<MiniCexListModel> listData =
          dataResponse.data.map((e) => MiniCexListModel.fromJson(e)).toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentCheckInModel>> getStudentCheckIn() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/checkins',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCheckInModel> listData = dataResponse.data
          .map((e) => StudentCheckInModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyCheckIn({required String studentId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/students/checkins/$studentId',
        options: await apiHeader.userOptions(),
        data: {'verified': true},
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentScientificAssignment>>
      getStudentScientificAssignment() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/scientific-assesments',
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
  Future<List<StudentScientificAssignment>> getStudentPersonalBehavior() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/personal-behaviours',
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
  Future<CstResponse> getStudentCst({required String status}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/csts',
        options: await apiHeader.userOptions(),
        data: {"status": status},
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = CstResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<SglResponse> getStudentSgl({required String status}) async {
    try {
      final response = await dio.get('${ApiService.baseUrl}/students/sgls',
          options: await apiHeader.userOptions(), data: {"status": status});
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SglResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<SpecialReportResponse> getStudentSpecialReports() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/problem-consultations',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = SpecialReportResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<FinalScoreResponse> getStudentFinalScore() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/assesments/',
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
  Future<WeeklyAssesmentResponse> getStudentWeeklyAssesment() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/weekly-assesments/v2',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = WeeklyAssesmentResponse.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<List<StudentCheckOutModel>> getStudentCheckOut() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/checkouts',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<StudentCheckOutModel> listData = dataResponse.data
          .map((e) => StudentCheckOutModel.fromJson(e))
          .toList();

      return listData;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> verifyCheckOut({required String studentId}) async {
    try {
      await dio.put(
        '${ApiService.baseUrl}/students/checkouts/$studentId',
        options: await apiHeader.userOptions(),
        data: {'verified': true},
      );
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentStatistic> getStudentStatistic() async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/statistics',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentStatistic.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<StudentById> getStudentById({required String studentId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/students/$studentId',
        options: await apiHeader.userOptions(),
      );
      final dataResponse = DataResponse<dynamic>.fromJson(response.data);
      final result = StudentById.fromJson(dataResponse.data);
      return result;
    } catch (e) {
      throw failure(e);
    }
  }

  @override
  Future<void> updateStudentData(
      {required StudentPostModel studentDataPostModel}) async {
    try {
      await dio.put('${ApiService.baseUrl}/students',
          options: await apiHeader.userOptions(),
          data: studentDataPostModel.toJson());
    } catch (e) {
      if (e is DioException) {
        print(e.message);
      }
      throw failure(e);
    }
  }
}
