import 'package:data/datasources/remote_datasources/supervisors_datasource.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';

part 'supervisors_state2.dart';

class SupervisorCubit2 extends Cubit<SupervisorState2> {
  final SupervisorsDataSource dataSource;
  SupervisorCubit2({required this.dataSource}) : super(SupervisorState2());

  Future<void> getAllStudentDepartment({
    String? query,
    int? page,
    bool onScroll = false,
  }) async {
    try {
      if (!onScroll && query == null) {
        emit(state.copyWith(requestState: RequestState.loading));
      }
      final result = await dataSource.getAllStudentsByCeu(
        query: query,
        page: page,
      );

      List<StudentDepartmentModel> filteredStudents = result
          .where((element) => element.activeDepartmentId != null)
          .toList();

      if (page == 1 && !onScroll) {
        emit(state.copyWith(
          listData: filteredStudents,
          requestState: RequestState.data,
        ));
      } else {
        emit(state.copyWith(
            requestState: RequestState.data,
            listData: state.listData! + filteredStudents));
      }
    } catch (e) {
      emit(state.copyWith(requestState: RequestState.error));
    }
  }
}
