import 'package:data/datasources/remote_datasources/student_datasource.dart';
import 'package:data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:data/models/clinical_records/student_clinical_record_model.dart';
import 'package:data/models/scientific_session/student_scientific_session_model.dart';
import 'package:data/models/self_reflection/student_self_reflection_model.dart';
import 'package:data/models/students/student_by_id_model.dart';
import 'package:data/models/students/student_check_in_model.dart';
import 'package:data/models/students/student_check_out_model.dart';
import 'package:data/models/students/student_profile_post.dart';
import 'package:data/models/students/student_statistic.dart';
import 'package:data/models/supervisors/supervisor_student_model.dart';
import 'package:data/models/units/student_department_recap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentDataSource dataSource;
  final SupervisorsDataSource dataSourceSp;

  StudentCubit({required this.dataSource, required this.dataSourceSp})
      : super(StudentState());

  Future<void> getStudentClinicalRecordOfActiveDepartment() async {
    try {
      emit(state.copyWith(
        crState: RequestState.loading,
      ));

      final result =
          await dataSource.getStudentClinicalRecordOfActiveDepartment();

      emit(state.copyWith(
        clinicalRecordResponse: result,
        crState: RequestState.data,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          crState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentScientificSessionOfActiveDepartment() async {
    try {
      emit(state.copyWith(
        ssState: RequestState.loading,
      ));

      final result =
          await dataSource.getStudentScientificSessionOfActiveDepartment();
      try {
        emit(state.copyWith(
          scientificSessionResponse: result,
          ssState: RequestState.data,
        ));
      } catch (e) {
        emit(state.copyWith(ssState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          ssState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentDetailById({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      final data = await dataSource.getStudentById(studentId: studentId);
      try {
        emit(state.copyWith(studentDetail: data));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStatisticByStudentId({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result =
          await dataSourceSp.getStatisticByStudentId(studentId: studentId);
      emit(state.copyWith(studentStatistic: result));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentSelfReflections() async {
    try {
      emit(state.copyWith(
        fetchSR: RequestState.loading,
      ));

      final result = await dataSource.getStudentSelfReflection();
      emit(state.copyWith(
          selfReflectionResponse: result, fetchSR: RequestState.data));
    } catch (e) {
      emit(
        state.copyWith(
          fetchSR: RequestState.error,
        ),
      );
    }
  }

  Future<void> updateStudentData(
      {required StudentProfile studentProfile}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      await dataSource.updateStudentProfile(studentProfile);
      try {} catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentCheckIn() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentCheckIn();
      try {
        emit(state.copyWith(studentsCheckIn: result));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifyCheckIn(
      {required String studentId, required bool isVerified}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.verifyCheckIn(
          studentId: studentId, isVerified: isVerified);
      try {
        emit(state.copyWith(successVerifyCheckIn: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentCheckOut() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentCheckOut();
      try {
        emit(state.copyWith(studentsCheckOut: result));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentStatistic() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentStatistic();
      emit(state.copyWith(studentStatistic: result));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifyCheckOut({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.verifyCheckOut(studentId: studentId);
      try {
        emit(state.copyWith(successVerifyCheckOut: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getAllStudents() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSourceSp.getAllStudents();

      emit(state.copyWith(students: result));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentRecap({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentRecap(studentId: studentId);

      emit(state.copyWith(studentDepartmentRecap: result));
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
