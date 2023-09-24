import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:elogbook/src/data/models/clinical_records/student_clinical_record_model.dart';
import 'package:elogbook/src/data/models/scientific_session/student_scientific_session_model.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/data/models/students/student_by_id_model.dart';
import 'package:elogbook/src/data/models/students/student_check_in_model.dart';
import 'package:elogbook/src/data/models/students/student_check_out_model.dart';
import 'package:elogbook/src/data/models/students/student_profile_post.dart';
import 'package:elogbook/src/data/models/students/student_statistic.dart';
import 'package:elogbook/src/data/models/supervisors/supervisor_student_model.dart';
import 'package:equatable/equatable.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentDataSource dataSource;
  final SupervisorsDataSource dataSourceSp;

  StudentCubit({required this.dataSource, required this.dataSourceSp})
      : super(StudentStateInit());

  Future<void> getStudentClinicalRecordOfActiveDepartment() async {
    try {
      emit(StudentStateLoading());

      final result =
          await dataSource.getStudentClinicalRecordOfActiveDepartment();
      try {
        emit((state as StudentStateSuccess).copyWith(
          clinicalRecordResponse: result,
        ));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentScientificSessionOfActiveDepartment() async {
    try {
      emit(StudentStateLoading());

      final result =
          await dataSource.getStudentScientificSessionOfActiveDepartment();
      try {
        emit((state as StudentStateSuccess).copyWith(
          scientificSessionResponse: result,
        ));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentDetailById({required String studentId}) async {
    try {
      emit(StudentStateLoading());

      final data = await dataSource.getStudentById(studentId: studentId);
      try {
        emit((state as StudentStateSuccess).copyWith(studentDetail: data));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStatisticByStudentId({required String studentId}) async {
    try {
      emit(StudentStateLoading());

      final result =
          await dataSourceSp.getStatisticByStudentId(studentId: studentId);
      emit((state as StudentStateSuccess).copyWith(studentStatistic: result));
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentSelfReflections() async {
    try {
      emit(StudentStateLoading());

      final result = await dataSource.getStudentSelfReflection();
      try {
        emit((state as StudentStateSuccess).copyWith(
          selfReflectionResponse: result,
        ));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> updateStudentData(
      {required StudentProfile studentProfile}) async {
    try {
      emit(StudentStateLoading());

      await dataSource.updateStudentProfile(studentProfile);
      try {
        emit((state as StudentStateSuccess).copyWith(
          successUpdateStudentProfile: true,
        ));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentCheckIn() async {
    try {
      emit(StudentStateLoading());

      final result = await dataSource.getStudentCheckIn();
      try {
        emit((state as StudentStateSuccess).copyWith(studentsCheckIn: result));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> verifyCheckIn({required String studentId}) async {
    try {
      emit(StudentStateLoading());

      await dataSource.verifyCheckIn(studentId: studentId);
      try {
        emit((state as StudentStateSuccess)
            .copyWith(successVerifyCheckIn: true));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentCheckOut() async {
    try {
      emit(StudentStateLoading());

      final result = await dataSource.getStudentCheckOut();
      try {
        emit((state as StudentStateSuccess).copyWith(studentsCheckOut: result));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getStudentStatistic() async {
    try {
      emit(StudentStateLoading());

      final result = await dataSource.getStudentStatistic();
      emit((state as StudentStateSuccess).copyWith(studentStatistic: result));
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> verifyCheckOut({required String studentId}) async {
    try {
      emit(StudentStateLoading());

      await dataSource.verifyCheckOut(studentId: studentId);
      try {
        emit((state as StudentStateSuccess)
            .copyWith(successVerifyCheckOut: true));
      } catch (e) {
        emit(StudentStateError(message: e.toString()));
      }
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }

  Future<void> getAllStudents() async {
    try {
      emit(StudentStateLoading());

      final result = await dataSourceSp.getAllStudents();

      emit((state as StudentStateSuccess).copyWith(students: result));
    } catch (e) {
      emit(StudentStateError(message: e.toString()));
    }
  }
}
