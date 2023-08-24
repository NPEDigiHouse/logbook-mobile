import 'package:bloc/bloc.dart';
import 'package:elogbook/src/data/datasources/remote_datasources/student_datasource.dart';
import 'package:elogbook/src/data/models/clinical_records/student_clinical_record_model.dart';
import 'package:elogbook/src/data/models/scientific_session/student_scientific_session_model.dart';
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
}
