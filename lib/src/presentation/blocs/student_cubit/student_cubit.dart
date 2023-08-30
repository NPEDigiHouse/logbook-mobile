import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/clinical_records/student_clinical_record_model.dart';
import 'package:elogbook/src/data/models/scientific_session/student_scientific_session_model.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/data/models/students/student_check_in_model.dart';
import 'package:elogbook/src/data/models/students/student_check_out_model.dart';
import 'package:elogbook/src/data/models/students/student_profile_post.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentDataSource dataSource;
  StudentCubit({required this.dataSource}) : super(StudentState());

  Future<void> getStudentClinicalRecordOfActiveUnit() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentClinicalRecordOfActiveUnit();
      try {
        emit(state.copyWith(
          clinicalRecordResponse: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> getStudentScientificSessionOfActiveUnit() async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentScientificSessionOfActiveUnit();
      try {
        emit(state.copyWith(
          scientificSessionResponse: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
        requestState: RequestState.loading,
      ));

      final result = await dataSource.getStudentSelfReflection();
      try {
        emit(state.copyWith(
          selfReflectionResponse: result,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
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
      try {
        emit(state.copyWith(
          successUpdateStudentProfile: true,
        ));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }

  Future<void> verifyCheckIn({required String studentId}) async {
    try {
      emit(state.copyWith(
        requestState: RequestState.loading,
      ));
      await dataSource.verifyCheckIn(studentId: studentId);
      try {
        emit(state.copyWith(successVerifyCheckIn: true));
      } catch (e) {
        emit(state.copyWith(requestState: RequestState.error));
      }
    } catch (e) {
      print(e.toString());
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
      print(e.toString());
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
      print(e.toString());
      emit(
        state.copyWith(
          requestState: RequestState.error,
        ),
      );
    }
  }
}
